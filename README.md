# KARE Help Desk (Flutter + Firebase)

Student support app for Kalasalingam Academy of Research and Education (KARE).
Built with Flutter. Database: **Firebase** (Authentication + Cloud Firestore).

## Features

- Register and log in with a register number and password
- Student home with 12 campus information categories (academic, hostel, blocks, transport, library, food and canteen, exams, fees, medical, events, IT)
- Report an Issue (category, description, photo) with a KARE number such as KARE-1024
- My Complaints with live status (Pending, In Progress, Resolved)
- Super admin dashboard: counts, all complaints, change status, edit every information page, choose the domain admins
- Domain admins (Canteen, Hostel, Admin Block): each one sees and manages only the complaints and information pages of his own domain. The database rules enforce this, not only the app.
- Courses, subjects and fees for every course
- KARE Help Bot (RAG): Retrieve the matching information pages and courses from Firestore, Augment a prompt with them, Generate a short answer with Gemini (optional free API key). Without a key, or if the AI is busy or offline, it answers from the retrieved stored text. The student never sees an error.
- Android app (APK) and Chrome web version

Planned: campus map, notifications.

## Folders

| Path | What it holds |
|---|---|
| `lib/main.dart`, `lib/firebase_config.dart` | App start and Firebase settings |
| `lib/screens/` | All screens (login, home, complaints, admin, info pages, bot) |
| `lib/seed_data.dart` | Starter data: courses, fees, subjects and information pages |
| `lib/domains.dart` | Which complaint categories and pages belong to Canteen, Hostel and Admin Block |
| `lib/ai_config.dart` | Optional Gemini API key for the bot |
| `firestore.rules` | Security rules for the database |
| `assets/images/` | KARE logo and campus photo |
| `build_android.ps1`, `run_chrome.ps1`, `change_icon.bat` | Helper scripts for Windows |

## Part A - Set up Firebase (once, about 10 minutes)

1. Go to https://console.firebase.google.com and click **Create a project**. Name it `kare-helpdesk`. Google Analytics can be turned off.
2. **Authentication**: Build > Authentication > Get started > Sign-in method > **Email/Password** > Enable > Save.
3. **Firestore**: Build > Firestore Database > Create database > choose location **asia-south1 (Mumbai)** > start in **production mode** > Create.
4. **Rules**: in Firestore open the **Rules** tab, delete everything, paste the full contents of `firestore.rules` from this project, and click **Publish**.
5. **Web app values** (for Chrome and the web link):
   Project settings (gear icon) > General > Your apps > click the **</>** (Web) icon > nickname `kare-web` > Register app.
   Copy these values from the code shown into `lib/firebase_config.dart` (the `_web` block):
   apiKey, appId, messagingSenderId, projectId (authDomain and storageBucket follow the project id).
6. **Android app values** (only needed for the Android app):
   Project settings > Your apps > Add app > Android icon > package name **com.kare.kare_helpdesk** > Register app > download `google-services.json` and open it in VS Code. Copy into the `_android` block:
   - apiKey = `api_key` > `current_key`
   - appId = `client` > `client_info` > `mobilesdk_app_id`
   - messagingSenderId = `project_info` > `project_number`
   - projectId = `project_info` > `project_id`
   You can skip the "next" steps Firebase shows about Gradle.

## Part B - Run in Chrome

Easiest: double-click `RUN_APP.bat`. Or type the commands below.

    flutter create --org com.kare --project-name kare_helpdesk .
    flutter pub get
    flutter run -d chrome

(or:  powershell -ExecutionPolicy Bypass -File .\run_chrome.ps1 )

Register in the app and log in.

## Part B2 - Turn on the AI answers for the bot (optional, 2 minutes)

The bot works without this. To let Gemini write the answers:

1. Open https://aistudio.google.com/apikey and sign in with a Google account.
2. Click **Create API key** and copy it (starts with `AIza`).
3. Open `lib/ai_config.dart`, paste it between the quotes of `kGeminiApiKey`, save.
4. Run the app again. Ask "CSE fees": the answer now ends with a "Based on:" line.

The key is inside the app, so anybody who unpacks the app can read it. In Google AI Studio / Google Cloud, restrict the key to the Generative Language API and keep the free tier.

## Part C - Super admin, data and domain admins

1. Firebase console > Firestore Database > Data > collection **users** > click your document > change the field **role** from `student` to `admin` > Update. (This is the Super Admin.)
2. In the app log out and log in again. An **Admin** button appears.
3. Open Admin > tap the **cloud-upload icon** (top right) > **Load**. This fills in courses, fees, subjects, hostels, canteens and the other pages.
4. Publish the new `firestore.rules` (Firestore > Rules > paste > Publish).

### Domain admins (Canteen, Hostel, Admin Block)

1. The person registers in the app with any ID of 6 to 15 letters or digits, for example `CANTEEN01`, `HOSTEL01`, `ADMINBLOCK01`, and a password.
2. Super Admin: Admin > **Manage admins** icon (person with a gear) > search the ID > tap > choose **Make Canteen Admin** (or Hostel, Admin Block).
3. The new admin closes and opens the app once. An **Admin** button and a badge appear.

| Admin | Complaint categories | Information pages they can edit |
|---|---|---|
| Canteen Admin | Food & Canteen | Canteens |
| Hostel Admin | Hostel | Hostel |
| Admin Block Admin | Academic, Examination, Fees, Campus Complaint | Academic, Exams, Campus Blocks, course fees |
| Super Admin | everything | everything, and who the admins are |

Transport, Library, Medical, Events and IT belong to the Super Admin until you add more domains in `lib/domains.dart` and in `firestore.rules`.

## Change the phone icon

Put a square logo at `assets/images/kare_logo.png`, then double-click `change_icon.bat` in the project folder. It sets the icon and the app name and builds the APK.

## Build the Android app

    powershell -ExecutionPolicy Bypass -File .\build_android.ps1

File: build\app\outputs\flutter-apk\app-release.apk (upload to Google Drive > Anyone with the link).

## Web link for your boss

    flutter build web

Drag the `build\web` folder to https://app.netlify.com/drop. Then in Firebase console > Authentication > Settings > **Authorized domains** > Add domain > your `xxxx.netlify.app`.

## Where things are stored

| Data | Firestore location |
|---|---|
| Profiles and roles | users |
| Complaints (KARE-1024...) and photos | complaints (photo is a small compressed picture inside the complaint) |
| Complaint number counter | counters/complaints |
| Courses, fees, subjects | programs |
| Hostels, canteens, blocks, exams etc. | info_items |
