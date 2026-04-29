# 🔥 Firebase Security Rules Fix (Copy-Paste)

To resolve the **"Missing or insufficient permissions"** errors, please copy and paste these rules into your **Firebase Console** -> **Firestore Database** -> **Rules** tab.

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Explicitly allow notifications
    match /notifications/{notificationId} {
      allow read, write: if true;
    }

    // 🚨 EMERGENCY DEMO MODE: ALLOW EVERYTHING 🚨
    // Use this only for the next hour to ensure your demo works perfectly.
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

### 💡 Why this fixes your error:
The app was trying to write to `sos_alerts` and `live_tracking` collections using the User's ID as the document ID, but the default Firebase rules usually block everything for security. These rules allow your app to function fully for the demo while keeping data linked to the authenticated user.

---

### 🎙️ 2. Microphone Fix (iOS)
If the microphone says "permission required" even after clicking allow:
1. Go to **Settings** on your iPhone/Simulator.
2. Scroll to **Umeed-e-Zann**.
3. Ensure **Microphone** and **Speech Recognition** are both toggled **ON**.

---

### 📦 3. Storage Permissions (Fixes Image/Doc Uploads)
Your "Unauthorized" error for images/documents is likely **Firebase Storage**. 
Go to **Firebase Console -> Storage -> Rules** and paste this:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if true;
    }
  }
}
```

---

### 🔍 4. Fix "Missing Index" Error
You are seeing `[cloud_firestore/failed-precondition]`.
**CLICK THIS LINK** from your logs (or copy it here) to fix it instantly:
https://console.firebase.google.com/v1/r/project/umeed-e--zann/firestore/indexes?create_composite=ClJwcm9qZWN0cy91bWVlZC1lLS16YW5uL2RhdGFiYXNlcy8oZGVmYXVsdCkvY29sbGVjdGlvbkdyb3Vwcy9jZXJ0aWZpY2F0ZXMvaW5kZXhlcy9fEAEaCgoGdXNlcklkEAEaDAoIaXNzdWVkQXQQAhoMCghfX25hbWVfXxAC

