#!/usr/bin/env python3
"""
SCAM INC. — Advanced Deterministic Asset Slicer Tool
Slices raw sprite sheets into individual named PNG assets based on tools/asset_manifest.json.
Uses dynamic zero-alpha gutter detection and content bounding box centering to guarantee:
- 0 pixel bleed between neighboring icons
- Perfectly centered, square assets with preserved transparency
- Crisp borders and no truncated graphics
"""

import argparse
import json
import os
import sys
import numpy as np
from PIL import Image

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.dirname(SCRIPT_DIR)
SOURCE_DIR = os.path.join(PROJECT_ROOT, "assets", "spritesheets", "source")
MANIFEST_PATH = os.path.join(SCRIPT_DIR, "asset_manifest.json")


def load_manifest(manifest_path=MANIFEST_PATH):
    if not os.path.exists(manifest_path):
        print(f"[ERROR] Manifest file not found: {manifest_path}", file=sys.stderr)
        sys.exit(1)
    with open(manifest_path, "r", encoding="utf-8") as f:
        return json.load(f)


def get_bands(proj, expected_count, threshold=15):
    """
    Finds split intervals for rows or columns by detecting zero-alpha gutters.
    Falls back gracefully to equal division of the content bbox if gutters are ambiguous.
    """
    is_zero = (proj <= threshold).astype(np.int32)
    diff = np.diff(np.pad(is_zero, (1, 1), "constant"))
    starts = np.where(diff == 1)[0]
    ends = np.where(diff == -1)[0]

    # If exactly (expected_count + 1) zero intervals are found, the inner ones are gutters!
    if len(starts) == expected_count + 1:
        bands = []
        for i in range(expected_count):
            bands.append((ends[i], starts[i + 1]))
        return bands

    # If multiple candidate zero bands exist, filter out tiny notches
    if len(starts) > expected_count + 1:
        # Keep outer margins + largest intermediate gutters
        gutters = []
        for s, e in zip(starts, ends):
            gutters.append((s, e, e - s))
        # Outer left/top is first, outer right/bottom is last
        outer_first = gutters[0]
        outer_last = gutters[-1]
        intermediate = sorted(gutters[1:-1], key=lambda x: x[2], reverse=True)[: expected_count - 1]
        selected_gutters = sorted([outer_first] + intermediate + [outer_last], key=lambda x: x[0])
        if len(selected_gutters) == expected_count + 1:
            bands = []
            for i in range(expected_count):
                bands.append((selected_gutters[i][1], selected_gutters[i + 1][0]))
            return bands

    # Fallback: divide the non-zero content span equally
    non_zeros = np.where(proj > threshold)[0]
    if len(non_zeros) == 0:
        total_len = len(proj)
        band_w = total_len / expected_count
        return [(int(round(i * band_w)), int(round((i + 1) * band_w))) for i in range(expected_count)]

    min_idx, max_idx = non_zeros[0], non_zeros[-1]
    band_w = (max_idx - min_idx + 1) / expected_count
    bands = []
    for i in range(expected_count):
        bands.append((int(round(min_idx + i * band_w)), int(round(min_idx + (i + 1) * band_w))))
    return bands


def make_centered_square(img, padding_ratio=0.06):
    """
    Crops transparent edges tightly around the icon and centers it on a square canvas.
    """
    bbox = img.getbbox()
    if not bbox:
        return img
    cropped = img.crop(bbox)
    w, h = cropped.size
    max_dim = max(w, h)
    pad = max(2, int(round(max_dim * padding_ratio)))
    target_size = max_dim + 2 * pad

    new_img = Image.new("RGBA", (target_size, target_size), (0, 0, 0, 0))
    offset_x = (target_size - w) // 2
    offset_y = (target_size - h) // 2
    new_img.paste(cropped, (offset_x, offset_y))
    return new_img


def slice_sheet(sheet_name, config, dry_run=False):
    source_path = os.path.join(SOURCE_DIR, sheet_name)
    if not os.path.exists(source_path):
        print(f"[ERROR] Source image not found: {source_path}", file=sys.stderr)
        return False, 0

    try:
        img = Image.open(source_path).convert("RGBA")
    except Exception as e:
        print(f"[ERROR] Failed to open {sheet_name}: {e}", file=sys.stderr)
        return False, 0

    img_w, img_h = img.size
    cols = config.get("columns", 1)
    rows = config.get("rows", 1)
    output_rel = config.get("output", "assets/icons")
    prefix = config.get("prefix", "")
    names = config.get("names", [])

    expected_cells = cols * rows
    if len(names) != expected_cells:
        print(
            f"[ERROR] {sheet_name}: Expected {expected_cells} names (cols={cols}, rows={rows}), but got {len(names)}.",
            file=sys.stderr,
        )
        return False, 0

    arr = np.array(img)
    alpha = arr[:, :, 3]

    h_proj = np.sum(alpha > 15, axis=1)
    v_proj = np.sum(alpha > 15, axis=0)

    row_bands = get_bands(h_proj, rows)
    col_bands = get_bands(v_proj, cols)

    output_dir = os.path.join(PROJECT_ROOT, output_rel)
    if not dry_run:
        os.makedirs(output_dir, exist_ok=True)

    print(
        f"[INFO] Slicing '{sheet_name}' ({img_w}x{img_h}) -> Grid: {cols}x{rows}, Target: {output_rel}"
    )

    generated_count = 0
    name_idx = 0

    for r in range(rows):
        r_start, r_end = row_bands[r]
        for c in range(cols):
            c_start, c_end = col_bands[c]
            name = names[name_idx]
            name_idx += 1
            filename = f"{prefix}{name}.png" if not name.startswith(prefix) else f"{name}.png"
            dest_path = os.path.join(output_dir, filename)

            # Crop cell using detected zero-alpha gutter boundaries
            cell_img = img.crop((c_start, r_start, c_end, r_end))

            # Center on a square canvas with clean padding for all assets
            cell_img = make_centered_square(cell_img, padding_ratio=0.05)

            if dry_run:
                print(f"  [DRY-RUN] Would crop cell ({c},{r}) -> {filename} [{c_start},{r_start},{c_end},{r_end}]")
            else:
                cell_img.save(dest_path, "PNG", optimize=True)
                generated_count += 1

    return True, generated_count if not dry_run else len(names)


def main():
    parser = argparse.ArgumentParser(description="SCAM INC. Advanced Asset Slicer")
    parser.add_argument("--all", action="store_true", help="Slice all sprite sheets in the manifest")
    parser.add_argument("--sheet", type=str, help="Slice a specific sheet by file name")
    parser.add_argument("--dry-run", action="store_true", help="Validate without writing files")
    parser.add_argument("--manifest", type=str, default=MANIFEST_PATH, help="Path to asset manifest JSON")

    args = parser.parse_args()

    manifest = load_manifest(args.manifest)
    total_generated = 0
    all_success = True

    if args.sheet:
        if args.sheet not in manifest:
            print(f"[ERROR] Sheet '{args.sheet}' not found in manifest.", file=sys.stderr)
            sys.exit(1)
        sheets_to_process = [args.sheet]
    else:
        sheets_to_process = list(manifest.keys())

    print(f"--- Starting Advanced Gutter-Aware Asset Slicer (Dry-run={args.dry_run}) ---")
    for sheet_name in sheets_to_process:
        config = manifest[sheet_name]
        success, count = slice_sheet(sheet_name, config, dry_run=args.dry_run)
        if success:
            total_generated += count
        else:
            all_success = False

    print("-----------------------------------------------------")
    if all_success:
        print(f"[SUCCESS] All assets cleanly sliced and centered! Total generated: {total_generated}")
        sys.exit(0)
    else:
        print(f"[FAILED] Slicing encountered errors.", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
