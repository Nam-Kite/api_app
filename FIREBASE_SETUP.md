# Firebase Flutter Integration Setup Guide

#### Environment Status ✓

- **Flutter Version**: 3.38.9
- **Dart Version**: 3.10.8
- **Firebase Packages**: Installed ✓
  - firebase_core: ^2.24.0
  - firebase_auth: ^4.15.0
  - cloud_firestore: ^4.13.0
  - firebase_analytics: ^10.7.0

---

## Next Steps

### 1. Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Create a project" or use an existing one
3. Enable Firestore Database, Authentication, and Analytics
4. Note your Project ID

### 2. Android Configuration

1. **Add google-services.json**
   - In Firebase Console: Project Settings → Download google-services.json
   - Place the file in: `android/app/google-services.json`

2. **Update Android build files**
   - Open `android/build.gradle.kts`
   - Add Google Services plugin dependency in buildscript:

   ```gradle
   dependencies {
       classpath("com.google.gms:google-services:4.3.15")
   }
   ```

   - Open `android/app/build.gradle.kts`
   - Apply the plugin at the bottom:

   ```gradle
   apply(plugin = "com.google.gms.google-services")
   ```

3. **Minimum SDK Version**
   - In `android/app/build.gradle.kts`, ensure minSdk is at least 21:
   ```gradle
   android {
       defaultConfig {
           minSdk = 21
       }
   }
   ```

### 3. iOS Configuration

1. **Add GoogleService-Info.plist**
   - In Firebase Console: Project Settings → Download GoogleService-Info.plist
   - In Xcode: Right-click Runner → Add Files
   - Select GoogleService-Info.plist
   - Check "Copy if needed" and select Runner target
   - Minimum iOS version: 12.0 or higher

2. **Update Info.plist**
   - Add GoogleAppID from GoogleService-Info.plist to `ios/Runner/Info.plist`:
   ```xml
   <key>GOOGLE_APP_ID</key>
   <string>YOUR_GOOGLE_APP_ID</string>
   ```

### 4. Update firebase_options.dart

1. Open `lib/firebase_options.dart`
2. Replace placeholder values with actual Firebase credentials from:
   - Firebase Console → Project Settings
   - android/app/google-services.json (for Android)
   - ios/Runner/GoogleService-Info.plist (for iOS)

   Example of what to fill:
   - apiKey: From Firebase Console
   - appId: From google-services.json or GoogleService-Info.plist
   - messagingSenderId: From Firebase Console
   - projectId: Your Firebase Project ID
   - storageBucket: yourproject.appspot.com

### 5. Install Dependencies

```bash
flutter clean
flutter pub get
```

### 6. Test Firebase Initialization

Run your app:

```bash
flutter run
```

If successful, you should see no initialization errors in the console.

### 7. Verify Configuration (Optional)

Add this to your main.dart to verify Firebase is initialized:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✓ Firebase initialized successfully');
  } catch (e) {
    print('✗ Firebase initialization failed: $e');
  }
  runApp(const MyApp());
}
```

---

## Common Issues & Solutions

### Issue: "Missing google-services.json"

- **Solution**: Download from Firebase Console and place in `android/app/`

### Issue: "GoogleService-Info.plist not found"

- **Solution**: Download from Firebase Console and add via Xcode

### Issue: "Minumum SDK version too low"

- **Android**: Update minSdk to 21 in `android/app/build.gradle.kts`
- **iOS**: Update minimum deployment target to 12.0

### Issue: "Version conflict errors"

- **Solution**: Run `flutter pub get` again or `flutter clean && flutter pub get`

---

## Useful Commands

```bash
# Verify Flutter environment
flutter doctor

# Check outdated packages
flutter pub outdated

# Get latest compatible versions
flutter pub get

# Clean and rebuild
flutter clean && flutter pub get

# Force Android rebuild
flutter clean
flutter build apk --debug

# Force iOS rebuild
flutter clean
flutter build ios --debug
```

---

## What's Already Done

✓ Firebase packages added to pubspec.yaml
✓ Firebase initialization code added to main.dart
✓ firebase_options.dart template created (with placeholders)
✓ Android and iOS are configured to accept Firebase

## What You Need to Do

1. Create Firebase Project in Firebase Console
2. Download configuration files (google-services.json and GoogleService-Info.plist)
3. Add configuration files to the project
4. Update android/build.gradle.kts and android/app/build.gradle.kts
5. Add GoogleAppID to ios/Runner/Info.plist
6. Fill in firebase_options.dart with real credentials
7. Run `flutter clean && flutter pub get`
8. Test by running the app

---

## Example: Basic Firestore Setup

After Firebase initialization, you can use Firestore:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

final firestore = FirebaseFirestore.instance;

// Write data
await firestore.collection('users').doc('user1').set({
  'name': 'John',
  'email': 'john@example.com',
});

// Read data
var doc = await firestore.collection('users').doc('user1').get();
print(doc.data());
```

---

## Example: Basic Authentication Setup

```dart
import 'package:firebase_auth/firebase_auth.dart';

final auth = FirebaseAuth.instance;

// Sign up
try {
  var userCredential = await auth.createUserWithEmailAndPassword(
    email: 'user@example.com',
    password: 'password123',
  );
  print('User created: ${userCredential.user?.uid}');
} catch (e) {
  print('Error: $e');
}

// Sign in
try {
  var userCredential = await auth.signInWithEmailAndPassword(
    email: 'user@example.com',
    password: 'password123',
  );
  print('Signed in: ${userCredential.user?.email}');
} catch (e) {
  print('Error: $e');
}
```

---

**Last Updated**: March 3, 2026
**Project**: api_app (Flutter)
