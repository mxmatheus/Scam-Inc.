# SCAM INC. — Master Development Contract

> **Document Version:** 1.0.0  
> **Project:** SCAM INC. (The Art of Deception)  
> **Target Platform:** Android (Portrait)  
> **Framework:** Flutter / Dart  

---

## 1. Architectural Rules

The application strictly adheres to a decoupled layered architecture:

```
Presentation Layer (Flutter Widgets / Screens / Modals)
         ↓
State Management (Riverpod Notifiers & AsyncNotifiers)
         ↓
Domain & Game Services (EconomyService, HeatService, TrustService, PrestigeService, EventService, OfflineService)
         ↓
Data Repositories (SaveRepository, SettingsRepository)
         ↓
Local Persistence (SharedPreferences / Hive / JSON File Storage)
```

### Core Architecture Principles:
1. **No Business Logic in Widgets:** Widgets must never calculate income, cost scaling, offline progression, or heat decay. All calculations belong in domain services.
2. **No Direct Storage Access from Widgets:** Widgets never directly read from or write to disk. All persistence goes through repositories via Riverpod providers.
3. **Deterministic Logic:** Game rules, formulas, and random event outcome probabilities must be deterministic, pure, and 100% unit-testable.
4. **Immutable State:** Domain models and state objects must be immutable value types (`copyWith`, equality, JSON serialization).
5. **No Global Mutable Singletons:** All service and repository dependencies must be provided and injected via Riverpod.

---

## 2. Naming & Code Style Conventions

- **Files & Folders:** lowercase `snake_case` (e.g., `fake_delivery_sms.dart`, `operation_card.dart`).
- **Classes & Types:** `UpperCamelCase` (e.g., `PlayerState`, `EconomyService`).
- **Variables & Functions:** `lowerCamelCase` (e.g., `calculateIncomePerSecond()`, `activeOperations`).
- **Constants:** `lowerCamelCase` or `SCREAMING_SNAKE_CASE` for global enums/keys.
- **Assets:** lowercase `snake_case` filenames (e.g., `fake_delivery_sms.png`, `core_money.png`).
- **No Magic Numbers:** All economy base values, multipliers, intervals, and asset keys must reside in centralized configuration/seed classes.

---

## 3. State Management & Data Flow Rules

- State management is exclusively handled by **Riverpod 2.x+**.
- State flows unidirectionally from domain services down into providers and then into UI consumers.
- User actions in the UI invoke methods on Notifiers / Controllers, which in turn delegate to Game Services and Repositories.
- Save operations are debounced or triggered on significant lifecycle/gameplay events (e.g., app backgrounding, prestige, major unlock) — never on every continuous tick rebuild.

---

## 4. Asset Pipeline Rules

- **Source Sprite Sheets:** Raw sprite sheets provided by artists/AI are stored permanently under `assets/spritesheets/source/` and are **never edited directly**.
- **Manifest-Driven Slicing:** All sprite cutting parameters (rows, columns, cell dimensions, output paths, and file names) are defined in `tools/asset_manifest.json`.
- **Deterministic Script:** `tools/asset_slicer.py` performs dimension validation, grid validation, transparent cropping, and atomic extraction.
- **Asset Constants Registry:** All asset paths are accessed through typed constants (e.g., `AppAssets.operations.fakeDeliverySms`), never as scattered ad-hoc strings in widgets.

---

## 5. Persistence & Save Rules

- **Offline-First:** The game requires zero server communication for full gameplay.
- **Atomic Writes:** Save files must be written atomically to prevent save corruption if the app is killed mid-write.
- **Corruption Fallback:** In the event of a corrupt save file, the system must safely fallback to a default new player state or a backup save rather than crashing.
- **Save Versioning & Migrations:** Every save file must include a `saveVersion` integer. Schema migrations must be explicitly handled.

---

## 6. Content Safety & Fictional Boundaries

- **Satirical & Abstract:** SCAM INC. is a corporate satire and educational anti-scam experience.
- **Strict Safety Boundaries:**
  - No actionable phishing instructions, real scripts, or fake landing page payloads.
  - No real-world credential harvesting or account takeover mechanisms.
  - No real person or actual corporate brand impersonation.
  - No executable malware or network exploit tutorials.
- **Educational Awareness:** Mini-games and events must emphasize recognizable scam red flags (e.g., artificial urgency, suspicious links, impersonated authority) to promote digital safety.

---

## 7. UI / UX Design Standards

- **Portrait Android:** Strict portrait-only orientation lock.
- **Visual Aesthetic:** Modern, clean corporate SaaS dashboard (neutral off-white/slate surfaces, 2px borders, rounded cards, subtle elevations).
- **No Cliché Tropes:** No purple-on-dark neon hacker stereotypes, no messy particle overlays.
- **Accessibility:** High contrast text, scalable typography, readable number abbreviations (e.g., 1.25K, 4.5M, 10.2B), and respect for reduced motion settings.

---

## 8. Definition of Done (DoD) for Milestones

A milestone is considered DONE only when:
1. All specified behaviors for that milestone are implemented.
2. No unrelated or future features are prematurely added.
3. Relevant unit/widget tests pass with 100% success.
4. `flutter analyze` reports zero errors and zero warnings.
5. `dart format` is compliant.
6. The milestone result is summarized following the standard project template.
