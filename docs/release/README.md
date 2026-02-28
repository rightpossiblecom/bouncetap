# BounceTap Release Credentials

Keep this file and the keystore safe. If you lose them, you cannot update your app on the Google Play Store.

## Keystore Details
- **Keystore File**: `bouncetap-release.jks`
- **Key Alias**: `bouncetap`
- **Keystore/Key Password**: `bouncetap123`

## Android Config
- **Package Name**: `com.bouncetap.app`
- **Application ID**: `com.bouncetap.app`

## Instructions
1. Ensure `bouncetap-release.jks` is placed in `android/app/`.
2. Ensure `key.properties` is in `android/` or configured in `build.gradle.kts`.
3. To build the release version:
   `flutter build appbundle --release`
