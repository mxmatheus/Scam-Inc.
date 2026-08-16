#!/usr/bin/env python3
"""
SCAM INC. — Deterministic Asset Slicer Tool
Slices raw sprite sheets into individual named PNG assets based on tools/asset_manifest.json.
"""

import argparse
import json
import os
import sys
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

    cell_w = img_w / cols
    cell_h = img_h / rows

    output_dir = os.path.join(PROJECT_ROOT, output_rel)
    if not dry_run:
        os.makedirs(output_dir, exist_ok=True)

    print(
        f"[INFO] Slicing '{sheet_name}' ({img_w}x{img_h}) -> Grid: {cols}x{rows}, Cell: {cell_w:.1f}x{cell_h:.1f}, Target: {output_rel}"
    )

    generated_count = 0
    name_idx = 0

    for r in range(rows):
        for c in range(cols):
            name = names[name_idx]
            name_idx += 1
            filename = f"{prefix}{name}.png" if not name.startswith(prefix) else f"{name}.png"
            dest_path = os.path.join(output_dir, filename)

            left = int(round(c * cell_w))
            top = int(round(r * cell_h))
            right = int(round((c + 1) * cell_w))
            bottom = int(round((r + 1) * cell_h))

            # Constrain to image boundaries
            right = min(right, img_w)
            bottom = min(bottom, img_h)

            if dry_run:
                print(f"  [DRY-RUN] Would crop cell ({c},{r}) -> {filename} [{left},{top},{right},{bottom}]")
            else:
                cell_img = img.crop((left, top, right, bottom))
                cell_img.save(dest_path, "PNG", optimize=True)
                generated_count += 1

    return True, generated_count if not dry_run else len(names)


def main():
    parser = argparse.ArgumentParser(description="SCAM INC. Asset Slicer")
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
    elif args.all:
        sheets_to_process = list(manifest.keys())
    else:
        print("[INFO] No mode specified. Defaulting to --all.")
        sheets_to_process = list(manifest.keys())

    print(f"--- Starting Asset Slicer (Dry-run={args.dry_run}) ---")
    for sheet_name in sheets_to_process:
        config = manifest[sheet_name]
        success, count = slice_sheet(sheet_name, config, dry_run=args.dry_run)
        if success:
            total_generated += count
        else:
            all_success = False

    print("-----------------------------------------------------")
    if all_success:
        print(f"[SUCCESS] Completed! Total assets processed: {total_generated}")
        sys.exit(0)
    else:
        print(f"[FAILED] Some sheets failed to slice.", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
