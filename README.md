# 🌸 Postpartum Recovery Companion

A calm tracking companion for mothers to organise daily recovery information and notice personal patterns — built with **Flutter**, **Firebase Authentication** and an on-device **SQLite** database.

> **Scope notice:** Tracking may help organise information and notice patterns. This app **does not diagnose or treat** any condition. It is not a medical device and does not replace advice from a doctor, midwife or lactation specialist.

---

## Table of contents

1. [Why this project](#why-this-project)
2. [Features](#features)
3. [How to use the app](#how-to-use-the-app)
4. [Architecture and data privacy](#architecture-and-data-privacy)
5. [Tech stack](#tech-stack)
6. [Folder structure](#folder-structure)
7. [What each file does](#what-each-file-does)
8. [Database schema](#database-schema)
9. [Download and run](#download-and-run)
10. [Proposed research and pilot](#proposed-research-and-pilot)
11. [Future scope](#future-scope)
12. [Future scope: Indian context](#future-scope-indian-context)
13. [Known limitations](#known-limitations)

---

## Why this project

Every postpartum journey is different, yet recovery information is hard to keep together. Scattered notes, fragmented apps and physical fatigue make it difficult to log daily check-ins consistently.

- A multi-state CDC follow-up (Robbins et al., *Preventing Chronic Disease*, 2023; 2019 PRAMS, N = 1,954 across 7 US states) found **7.2%** of mothers reported depressive symptoms at 9–10 months postpartum. This is self-reported survey data, not clinical diagnoses, and says nothing about app demand. It does show that recovery needs extend well beyond the standard six-week postpartum visit.
- The WHO recognises consistent information, reassurance and positive support as pillars of quality postnatal care.

**The journey the app supports:**

| Step | What happens |
|------|--------------|
| 01 Return home | Adjust to new rhythms, sleep patterns and physical changes |
| 02 Manage daily needs | Feeding intervals, personal recovery, hydration, restful pauses |
| 03 Review patterns | Look back at logs to gain clarity and share context with providers |

## Features

| # | Feature | Details |
|---|---------|---------|
| 1 | **Sign up / log in** | Email and password via Firebase Authentication, with password reset |
| 2 | **Breastfeeding tracker** | Choose the side, start a timer; start time, end time and duration are saved |
| 3 | **Meals and water** | Meal type, food and optional quantity; glasses of water per day |
| 4 | **Exercise log** | Activity, duration in minutes, optional notes |
| 5 | **Recovery check-in** | Sleep, energy, mood, pain and notes, once a day (viewable and editable later) |
| 6 | **History** | Feeding, meals, hydration, exercise and check-ins together in one place |
| 7 | **Profile** | Your name and your baby's name. Logging out keeps locally stored records |

## How to use the app

1. **Sign up or log in** with your email and password.
2. Open any tracker from **Home**.
3. Log activities through the day.
4. Open **History** to review and notice patterns.
5. Use **Profile** to save names or log out (your local records stay on the device).

## Architecture and data privacy

```
┌──────────────────┐   user identity only   ┌─────────────────────────┐
│ Flutter App (UI) │ ─────────────────────► │ Firebase Authentication │
└────────┬─────────┘                        └─────────────────────────┘
         │
         ▼
┌──────────────────┐          ✖  no cloud sync / no Firestore
│ Local SQLite DB  │ - - - - - - - - - - - ► ☁️ (server)
│    (sqflite)     │
└──────────────────┘
   All tracker and recovery data stays on the device
```

- **Firebase Authentication** handles registration and session tokens only. No health logs are stored there.
- **All tracker and recovery data is written to a local SQLite database** on the phone. Nothing is sent to Firestore or any server.
- Records are keyed by the Firebase user id (`firebase_uid`), so several accounts on one device do not see each other's data.

> ⚠️ **Honest note:** the local database is currently standard SQLite via `sqflite`, protected by Android's app sandbox. It is **not yet encrypted at the file level**. Adding SQLCipher is on the roadmap (see below).

## Tech stack

| Technology | Role |
|------------|------|
| **Flutter** | Cross-platform UI framework |
| **Dart** (SDK ^3.13.4) | App logic, strongly typed models |
| **Firebase Authentication** (`firebase_core`, `firebase_auth`) | Registration and sessions |
| **SQLite / `sqflite`** + `path` | On-device relational storage |

## Folder structure

```
postpartum/
├── lib/                          # All Dart source code
│   ├── main.dart                 # App entry, Home, and the 4 tracker screens
│   ├── firebase_options.dart     # Auto-generated Firebase config (FlutterFire CLI)
│   ├── auth/
│   │   ├── auth_service.dart     # Wrapper around FirebaseAuth
│   │   ├── login_page.dart       # Login screen
│   │   └── signup_page.dart      # Sign-up screen
│   ├── database/
│   │   └── app_database.dart     # SQLite setup, migrations, all queries
│   ├── models/
│   │   ├── feeding_session.dart  # Breastfeeding session model
│   │   ├── meal.dart             # Meal model
│   │   ├── exercise_session.dart # Exercise model
│   │   ├── recovery_checkin.dart # Daily check-in model
│   │   └── profile_model.dart    # Mother/baby profile model
│   ├── history/
│   │   └── history_page.dart     # Combined history view
│   └── profile/
│       └── profile_page.dart     # Profile edit and logout
├── android/                      # Android project (Gradle, manifest, launcher icons)
│   └── app/
│       ├── build.gradle.kts
│       ├── google-services.json  # Firebase config for Android
│       └── src/main/             # AndroidManifest.xml, MainActivity.kt, res/
├── web/                          # Web shell (index.html, manifest, icons)
├── pubspec.yaml                  # Dependencies and app metadata
├── pubspec.lock                  # Locked dependency versions
├── analysis_options.yaml         # Dart lint rules
├── firebase.json                 # FlutterFire project mapping
└── README.md                     # You are here
```

## What each file does

| File | Purpose |
|------|---------|
| [lib/main.dart](lib/main.dart) | Starts Firebase, picks **Login** or **Home** based on auth state, and contains `HomePage`, `BreastfeedingPage`, `NutritionPage`, `ExercisePage`, `RecoveryPage` and shared widgets (`SummaryCard`, `SessionCard`, `MealCard`, `TrackerCard`) |
| [lib/firebase_options.dart](lib/firebase_options.dart) | Per-platform Firebase keys, generated by `flutterfire configure` |
| [lib/auth/auth_service.dart](lib/auth/auth_service.dart) | `signUp`, `signIn`, `signOut`, `sendPasswordResetEmail`, auth-state stream |
| [lib/auth/login_page.dart](lib/auth/login_page.dart) | Email/password login UI and error handling |
| [lib/auth/signup_page.dart](lib/auth/signup_page.dart) | Account creation UI and validation |
| [lib/database/app_database.dart](lib/database/app_database.dart) | Opens the DB (schema v8), creates tables, runs upgrades, CRUD for feeding, meals, hydration, exercise, check-ins and profile |
| [lib/models/](lib/models) | Plain Dart classes with `toMap()` / `fromMap()` for SQLite rows |
| [lib/history/history_page.dart](lib/history/history_page.dart) | Shows all logged categories together |
| [lib/profile/profile_page.dart](lib/profile/profile_page.dart) | Save mother's and baby's name, log out |
| [pubspec.yaml](pubspec.yaml) | Dependencies: `sqflite`, `path`, `firebase_core`, `firebase_auth`, `cloud_firestore` (declared, currently unused) |
| [android/app/google-services.json](android/app/google-services.json) | Firebase config for the Android build |
| [firebase.json](firebase.json) | FlutterFire CLI output linking platforms to the Firebase project |

## Database schema

SQLite file on device, version **8**. Every table carries `firebase_uid`.

| Table | Stores |
|-------|--------|
| `feeding_sessions` | Side, start time, end time, duration |
| `meals` | Meal type, food, optional quantity, time |
| `daily_hydration` | Glasses of water per day |
| `exercise_sessions` | Activity, minutes, notes |
| `recovery_checkins` | Date, sleep minutes, energy, mood, pain, note (one per day) |
| `profiles` | `firebase_uid` (primary key), mother's name, baby's name |

## Download and run

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart ^3.13.4)
- Android Studio (Android SDK) or VS Code with the Flutter extension
- An Android phone with USB debugging, or an Android emulator
- `git`

Check your setup:

```bash
flutter doctor
```

### 1. Get the code

```bash
git clone https://github.com/aniket-bhatia/postpartum.git
cd postpartum
```

Or on GitHub click **Code → Download ZIP**, extract it and open the folder.

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Run

```bash
flutter devices          # list connected devices / emulators
flutter run              # run on the selected device
```

Open the folder in **VS Code** or **Android Studio**, pick a device and press **Run / F5**.

### 4. Build an APK to install on a phone

```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Using your own Firebase project

The repo ships with a Firebase config. To use your own:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Enable **Email/Password** under Firebase Console → Authentication → Sign-in method.

### Troubleshooting

| Problem | Fix |
|---------|-----|
| Gradle or build errors | `flutter clean && flutter pub get` |
| Login fails | Confirm Email/Password sign-in is enabled in Firebase |
| No devices found | Enable USB debugging, or start an emulator |

## Proposed research and pilot

*These are proposed steps, not completed clinical trials or published research.*

1. **Device tests:** verify core flows, inputs and battery use on target Android devices.
2. **User usability:** test logging and record retrieval with postpartum mothers in daily routines.
3. **Expert review:** feedback from mothers, maternal health nurses, midwives and lactation specialists.
4. **Limited pilot:** refine the UI, then run an opt-in evaluation cohort.

## Future scope

- **Cloud sync via GCP (proposal, not implemented):** Flutter client → authenticated API gateway / Cloud Run → managed Cloud SQL and secure storage, with HTTPS, rate limiting, encryption at rest and automated backups. Security, uptime, scaling and HIPAA-level compliance must be evaluated first; a VM is not automatically production-ready.
- **Encrypted local storage** (SQLCipher) and app lock / biometric unlock.
- **Pattern insights:** charts and weekly summaries of feeding, sleep, mood and pain.
- **Provider export:** shareable PDF summary for appointments.
- **Reminders:** feeding, hydration and check-in notifications.
- **Opt-in group-level research:** clear, revocable consent; de-identified aggregation; trends studied over 3–12 months. Today the app collects and uploads nothing for this purpose, and any future use requires formal **IRB approval** and independent consent.

## Future scope: Indian context

India has the largest annual number of births in the world, with very different postpartum realities across urban and rural settings. Ideas to make the app fit:

**Language and access**
- **Multilingual UI:** Hindi first, then Tamil, Telugu, Bengali, Marathi, Gujarati, Kannada, Malayalam and more, with simple icon-led screens and **voice input** for low-literacy users.
- **Offline-first by design:** the on-device SQLite approach already suits patchy connectivity; sync would happen opportunistically.
- **Lightweight build** for low-end Android phones, the dominant device class in India.
- **Phone-number / OTP login** (Firebase Phone Auth) alongside email, since many users do not rely on email.

**Cultural and family context**
- **Sanskar / "jaapa" / confinement practices:** the 40-day rest period (*sawa mahina* / *chilla*) tracked as an optional recovery timeline, respectfully and without judgement.
- **Indian diet logging:** a food list with dal, roti, khichdi, ghee, ajwain, gond laddoo, jeera water and regional dishes, instead of generic Western food items.
- **Family-supporter view:** an optional, consent-based way for a partner or mother-in-law to see non-sensitive summaries, such as hydration and feeds, since postpartum care in India is often shared by the family.
- **Breastfeeding support:** content aligned with exclusive breastfeeding for six months and local lactation guidance.

**Integration with India's health system** *(each needs partnerships, approvals and compliance review)*
- **ASHA / ANM / Anganwadi workers:** a companion view so frontline workers can review a mother's logs during home visits.
- **ABDM / ABHA (Ayushman Bharat Digital Mission):** optional consent-based linking with health records.
- **Government schemes:** reminders and information for **Janani Suraksha Yojana (JSY)**, **PMMVY** and **JSSK**, plus immunisation schedules from the **U-WIN** programme and **Mother and Child Protection (MCP) card** milestones.
- **Telemedicine:** links to **e-Sanjeevani** for teleconsultation.
- **Referral nudges:** gentle prompts to contact a doctor, ASHA worker or helpline when logged pain or mood stays concerning (not a diagnosis).

**Mental health**
- Postpartum depression is under-recognised and stigmatised in many communities. Future versions could add a validated screening questionnaire (e.g. **EPDS**, available in several Indian languages) *with clinical oversight*, plus links to **Tele-MANAS** (14416) and local support, always with the scope notice above.

**Privacy and regulation**
- Compliance with the **Digital Personal Data Protection Act, 2023 (DPDP)**: explicit consent, purpose limitation, right to erase, and data stored in India for any cloud sync (e.g. GCP Mumbai / Delhi regions).
- Any research use needs an Institutional Ethics Committee / **ICMR**-guideline review.

**Research with Indian partners**
- Pilot with a hospital, maternity clinic or NGO; validate with Indian mothers, ASHA workers, midwives and lactation consultants across urban and rural settings.

## Known limitations

- Android is the primary target; iOS, web and desktop are not tested.
- No cloud backup: uninstalling the app or losing the phone loses the data.
- Local database is not yet encrypted at file level.
- `cloud_firestore` is listed in `pubspec.yaml` but not used.
- Not clinically validated. Proposed pilot steps have not been carried out.

---

*Built as a first Flutter project. Feedback and suggestions are welcome via GitHub issues.*
