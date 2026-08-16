# SCAM INC. — Android Release Documentation

## 📱 Application Overview
- **Application ID:** `com.scaminc.game`
- **Application Name:** `SCAM INC.`
- **Tagline:** The Art of Deception (Satirical Cyber Education)
- **Target Platform:** Android (API 21+ Lollipop to API 34+ Android 14)
- **Architecture:** 64-bit ARM (arm64-v8a) & x86_64 compatible
- **Orientation:** Locked Portrait Mode (`portraitUp`)

---

## 🛠️ Build Commands

### 1. Verification & Tests
```bash
flutter analyze
flutter test
```

### 2. Debug APK (For local emulator and device testing)
```bash
flutter build apk --debug
```

### 3. Release APK (For direct sideloading and internal distribution)
```bash
flutter build apk --release
```

### 4. Google Play Android App Bundle (AAB)
```bash
flutter build appbundle --release
```

---

## 🔒 Security & Privacy Checklist
- [x] No hardcoded production signing keys or keystore secrets committed to Git repository.
- [x] Offline-first progression architecture with zero mandatory server dependencies.
- [x] Zero collection of Personal Identifiable Information (PII) or device identifiers.
- [x] Satirical educational parody disclaimers presented on all onboarding and settings surfaces.
