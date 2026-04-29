# Settings Screen Functionalities

## Overview
The Settings screen allows users to manage their app preferences, privacy settings, and account settings. All settings are saved to Firebase Firestore in real-time.

## Implemented Features

### 1. Notifications Section
- **Push Notifications Toggle**: Enable/disable push notifications for important updates
  - Saved to Firestore: `users/{userId}/settings/notificationsEnabled`
  - Default: `true`
  
- **Email Notifications Toggle**: Enable/disable email notifications
  - Saved to Firestore: `users/{userId}/settings/emailNotificationsEnabled`
  - Default: `true`

### 2. Privacy & Security Section
- **Location Services Toggle**: Allow/disallow app to access location
  - Saved to Firestore: `users/{userId}/settings/locationEnabled`
  - Default: `true`
  - Used for features like SOS alerts, live tracking
  
- **Biometric Authentication Toggle**: Use fingerprint or face ID to unlock
  - Saved to Firestore: `users/{userId}/settings/biometricEnabled`
  - Default: `false`
  - Note: UI implementation only, actual biometric implementation pending

### 3. App Preferences Section
- **Language Selection**: Choose app language (English/Urdu)
  - Saved to Firestore: `users/{userId}/settings/language`
  - Options: 'English', 'Urdu'
  - Default: 'English'
  - Saved immediately when selection changes

### 4. About Section
- **App Version**: Displays current app version (1.0.0)
  - Read-only display

- **Terms of Service**: Link to terms of service page
  - Navigates to TermsOfServiceScreen

- **Privacy Policy**: Link to privacy policy page
  - Navigates to PrivacyPolicyScreen

### 5. Account Section
- **Delete Account**: Permanently delete user account
  - Shows confirmation dialog
  - Deletes user data from Firestore
  - Deletes user from Firebase Auth
  - Clears local user data
  - Navigates to Login screen after successful deletion
  - Shows success/error messages

## Backend Integration

### Data Storage
All settings are stored in Firestore under:
```
users/{userId}/settings/
  - notificationsEnabled: bool
  - emailNotificationsEnabled: bool
  - locationEnabled: bool
  - biometricEnabled: bool
  - language: String
```

### Services Used
- `AuthService`: For user data updates and account deletion
- `UserService`: For clearing local user data after account deletion

### Real-time Sync
- Settings are loaded from Firestore when screen opens
- Settings are saved immediately when toggled/changed
- No need to press a "Save" button - auto-saves

## User Experience
- All toggles update UI immediately
- Settings persist across app restarts
- Changes sync to Firebase in real-time
- Clear section headers for organization
- Confirmation dialogs for destructive actions (delete account)

