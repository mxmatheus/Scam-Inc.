# SCAM INC. — Contributing Guidelines & AI Agent Workflow

Welcome to the **SCAM INC.** development team. This document outlines the expected workflow, rules, and best practices for developing and maintaining the codebase.

---

## 1. Development Principles

1. **Step-by-Step Milestones:** Never implement multiple large milestones in a single turn. Focus on fulfilling the exact requirements of the active milestone and satisfying its Definition of Done (DoD).
2. **Layered Separation:**
   - **Presentation:** Widgets display state and emit user events. Never perform economic formulas or direct disk writes in widgets.
   - **State:** Riverpod providers manage view models and user action dispatch.
   - **Services:** Pure domain logic (Economy, Heat, Trust, Prestige, Offline, Events).
   - **Repositories:** Data access abstraction (Save, Settings).
   - **Data/Local:** Storage engines (Hive, SharedPreferences, JSON).
3. **Deterministic & Test-Driven:** All core mathematical formulas, multipliers, and transition states must be verified with unit tests.

---

## 2. Asset Workflow

- **Never directly modify raw sprite sheets** in `assets/spritesheets/source/`.
- If new sprites are added, update `tools/asset_manifest.json` with the corresponding grid and naming scheme.
- Run `python tools/asset_slicer.py --all` to re-generate the slice outputs.
- Register generated paths in `lib/core/constants/asset_constants.dart`.

---

## 3. Pull Requests & Validation Checklist

Before submitting code:
- [ ] `dart format .` is executed and clean.
- [ ] `flutter analyze` reports zero errors and zero warnings.
- [ ] `flutter test` passes 100%.
- [ ] No debug `print()` statements left behind.
- [ ] No hard-coded economic balance numbers in UI widgets.
- [ ] No actual malware, exploit scripts, or real-world phishing instructions included.
