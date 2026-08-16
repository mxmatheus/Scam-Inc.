# SCAM INC. — The Art of Deception

<p align="center">
  <img src="assets/branding/logo_primary.png" alt="SCAM INC. Logo" width="180"/>
</p>

<p align="center">
  <b>A Satirical Mobile Idle / Tycoon Game about Running a Digital Corporate Empire & Spotting Anti-Scam Red Flags.</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Platform-Android-green.svg" alt="Platform Android"/>
  <img src="https://img.shields.io/badge/Framework-Flutter%203.41+-blue.svg" alt="Flutter Framework"/>
  <img src="https://img.shields.io/badge/Language-Dart%203.11+-0175C2.svg" alt="Dart Language"/>
  <img src="https://img.shields.io/badge/Architecture-Riverpod%20%2B%20Offline--First-purple.svg" alt="Architecture"/>
  <img src="https://img.shields.io/badge/License-Proprietary-red.svg" alt="License"/>
</p>

---

## 📌 Overview

**SCAM INC.** is a portrait mobile idle/tycoon management simulation built with **Flutter**. Players take the helm of a fictional, satirical digital operation, balancing exponential revenue generation (**S-Coins**) with corporate reputation (**Trust**) and law enforcement risk (**Heat**).

Beneath its humorous corporate satire exterior lies an **educational anti-scam awareness engine**: mini-games (e.g. *Suspicious Chat*, *Scam Baiter*) expose real-world digital deception tactics and teach players to identify common red flags (urgency, fake authority, unverified links) in an engaging, gamified format.

> ⚠️ **Disclaimer:** *SCAM INC.* is entirely fictional and satirical. It does not contain actionable technical instructions for real-world phishing, credential theft, malware distribution, or financial fraud.

---

## 🎮 Core Gameplay Loop

```
            ┌───────────────────────┐
            │       TAP / COLLECT   │
            └───────────┬───────────┘
                        ↓
            ┌───────────────────────┐
            │    OPERATIONS         │
            │    & AUTOMATION       │
            └───────────┬───────────┘
                        ↓
            ┌───────────────────────┐
            │       S-COINS         │
            └───────────┬───────────┘
                        ↓
            ┌───────────────────────┐
            │      UPGRADES         │
            └───────────┬───────────┘
                        ↓
            ┌───────────────────────┐
            │    MORE REVENUE       │
            └───────────┬───────────┘
                        ↓
            ┌───────────────────────┐
            │       MORE HEAT       │
            └───────────┬───────────┘
                        ↓
            ┌───────────────────────┐
            │  RISK MANAGEMENT      │ (Mini-Games & Events)
            └───────────┬───────────┘
                        ↓
            ┌───────────────────────┐
            │      PRESTIGE         │ (Offshore Escape)
            └───────────┬───────────┘
                        ↓
            ┌───────────────────────┐
            │ PERMANENT PROGRESSION │ (Laundered Cash Skill Tree)
            └───────────────────────┘
```

---

## 🏛️ Architecture & Project Structure

The project strictly follows clean layered separation:

```
lib/
├── app/                  # Application bootstrap, routing, and SaaS corporate theme
│   ├── app.dart
│   └── theme.dart
├── core/                 # Shared tokens, constants, and utilities
│   ├── constants/        # Typed asset paths (AppAssets) & game constants
│   ├── utils/            # Number formatting (K, M, B, T, Qa...)
│   └── widgets/          # Reusable UI components (ScamCard, ScamButton, ScamIcon...)
├── data/                 # Data layer
│   ├── local/            # Local storage implementations (offline-first)
│   ├── repositories/     # SaveRepository, SettingsRepository
│   └── seed/             # Static game balance & operation catalogs
├── features/             # Feature UI & controllers
│   ├── dashboard/        # Main portrait hub
│   ├── operations/       # Operation tiers & automation
│   ├── minigames/        # Suspicious Chat & Scam Baiter mini-games
│   ├── prestige/         # Offshore escape & skill tree
│   └── settings/         # Accessibility & preferences
├── game/                 # Pure domain business logic (Unit-testable)
│   ├── economy/          # Income formulas, level scaling
│   ├── heat/             # Risk & raid systems (0–100)
│   ├── trust/            # Multiplier & unlock requirements
│   ├── prestige/         # Lifetime progression & reset math
│   └── offline/          # Offline income & heat calculations
├── services/             # Platform abstractions (Ads, IAP, Analytics)
└── main.dart             # App entry point (Portrait lock + Riverpod ProviderScope)
```

---

## 🎨 Asset Pipeline

Source sprite sheets are deterministically sliced into discrete, transparent PNGs:

```bash
# Slice all sprite sheets defined in tools/asset_manifest.json
python tools/asset_slicer.py --all

# Or test slicing without writing files
python tools/asset_slicer.py --all --dry-run
```

All sliced assets are stored in categorized directories:
- `assets/branding/`
- `assets/icons/core/`
- `assets/icons/resources/`
- `assets/icons/operations/`
- `assets/icons/status/`
- `assets/icons/achievements/`
- `assets/illustrations/company/`
- `assets/illustrations/events/`
- `assets/illustrations/prestige/`
- `assets/illustrations/tutorial/`
- `assets/avatars/characters/`
- `assets/avatars/chat/`

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev) (3.41.0 or higher)
- [Dart SDK](https://dart.dev) (3.11.0 or higher)
- Python 3.10+ with `Pillow` (for asset tooling)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/mxmatheus/Scam-Inc..git
   cd Scam-Inc.
   ```

2. **Install Flutter packages:**
   ```bash
   flutter pub get
   ```

3. **Verify Asset Pipeline:**
   ```bash
   python tools/asset_slicer.py --all
   ```

4. **Run Static Analysis & Tests:**
   ```bash
   flutter analyze
   flutter test
   ```

5. **Launch the Game:**
   ```bash
   flutter run
   ```

---

## 🧪 Quality Standards & CI

All pull requests and commits are verified against:
- `dart format --set-exit-if-changed .`
- `flutter analyze` (Zero errors, zero warnings)
- `flutter test` (100% test pass rate)

---

## 📄 License

Proprietary © 2026 SCAM INC. All rights reserved.
