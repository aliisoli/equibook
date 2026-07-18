# Firebase setup (next step)

EquiBook currently runs with a **local demo store** on your device/emulator so you can test without cloud accounts. When you are ready for multi-device sync, connect Firebase.

## 1. Create a Firebase project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a project named `equibook`
3. Enable **Authentication → Email/Password**
4. Create a **Cloud Firestore** database (start in test mode, then deploy the rules in `/firebase`)
5. Enable **Storage**

## 2. Register the Android app

1. Add an Android app with package name `com.equibook.equibook`
2. Download `google-services.json` into `android/app/`
3. Follow FlutterFire setup:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

## 3. Deploy rules

```bash
firebase deploy --only firestore:rules,storage
```

Rules templates live in:

- `firebase/firestore.rules`
- `firebase/storage.rules`

## 4. Swap the data layer

Replace `AppStore` local persistence with Firebase Auth + Firestore + Storage repositories. Keep the same models and screens — only the data source changes.
