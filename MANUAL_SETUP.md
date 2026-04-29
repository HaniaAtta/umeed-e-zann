# Umeed-e-Zann: Manual Setup & Final Feature Guide

This guide provides the final manual steps required to reach 100% functionality on a physical device and lists all the features implemented in the application.

## 🛠️ Resolving the Profile Image "Location Error"
The "location error" (e.g., *Object does not exist at location*) typically occurs when Firebase Storage rules or the bucket are not properly configured.

### 1. Update Firebase Storage Rules
Go to **Firebase Console** -> **Storage** -> **Rules** and replace them with this to allow users to manage their own folders:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /profile_images/{userId} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    match /documents/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /products/{productId}/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

### 2. Initialize the Bucket
If your Storage is brand new, ensure you have clicked **"Get Started"** in the Firebase Storage tab to initialize the default bucket.

---

## ⚡ Step-by-Step Manual Setup Guide (The Final 1%)

### 1. Enable Firestore Indexes (Fixes Empty Lists)
If modules like "Marketplace" or "Growth Academy" show empty lists or report a "Firestore Error":
1. Run the app on a physical device or emulator.
2. In **VS Code**, watch the **Debug Console**.
3. Look for an error message containing a link starting with `https://console.firebase.google.com...`.
4. Click the link and click **"Create Index"** in your browser.
5. Wait ~3 minutes for the index to build.

### 3. iOS Notification Fallback (In-App Alerts)
For student projects or cases without a paid Apple Developer Account:
1. **Foreground Alerts**: The app is equipped with a **Global Firestore Listener**. If the app is open (Foreground), any SOS alert triggered by a contact will appear as a high-priority dialog immediately.
2. **Demonstration**: In the **Safety Dashboard**, scroll to the bottom to find a **"TEST SOS IN-APP ALERT"** button. This allows you to demonstrate exactly how the emergency UI appears to trusted contacts.
3. **Android**: Push notifications work fully in the background via FCM with no additional cost.

---

## 📱 Complete Feature List (65+ Features)

The Umeed-e-Zann application is a comprehensive platform for women's empowerment, safety, and growth. Here is the full breakdown of features:

### 🔐 Authentication & Identity (10 Features)
1. **Secure Signup**: Email-based registration with Firebase.
2. **Identity Verification**: Phone and gender collection.
3. **Encrypted Login**: Secure session management.
4. **Password Recovery**: Automated reset emails.
5. **Account Deletion**: User-data privacy control.
6. **Dynamic Profile View**: Real-time user data display.
7. **Profile Editing**: Update name, phone, and gender.
8. **Location Management**: User regional settings.
9. **Image Picker (Gallery)**: Upload profile pictures from the library.
10. **Image Picker (Camera)**: Direct capture for profile verification.

### 🛡️ Safety & SOS Suite (15 Features)
11. **One-Touch SOS**: Instant emergency activation.
12. **SOS Countdown**: 5-second buffer to prevent false alarms.
13. **GPS Coordinate Capture**: High-accuracy real-time location retrieval.
14. **Emergency SMS Dispatch**: Automated alerts to trusted contacts.
15. **Emergency Email Integration**: Backend-triggered email alerts.
16. **Live Tracking Mode**: Real-time location synchronization with Firestore.
17. **Tracking Durations**: Selectable periods (15m, 30m, 60m, Until Stop).
18. **Shake-to-Alert**: Background accelerometer-based SOS trigger.
19. **Adjustable Sensitivity**: Low, Medium, High settings for shake detection.
20. **Fake Call Generator**: Realistic incoming call simulation.
21. **Custom Call Timers**: Set delays for the "exit" call.
22. **Trusted Contacts CRM**: Add personal emergency contacts.
23. **Contact Sync**: Real-time cloud backup of emergency list.
24. **SOS Status UI**: Visual confirmation of active emergency states.
25. **Background Persistence**: Safety services remain active when the app is minimized.

### 🎓 Growth Academy (12 Features)
26. **Course Catalog**: Centralized hub for skill-building.
27. **Category Filtering**: Coding, Marketing, Finance, etc.
28. **Course Search**: Quick finding of educational materials.
29. **Premium Video Player**: YouTube-integrated learning experience.
30. **Bookmarking System**: Save courses for later.
31. **Progress Tracking**: Visual bars showing completion percentage.
32. **Module Organization**: Clean breakdown of course lessons.
33. **Interactive Quizzes**: Multiple-choice assessment engine.
34. **Real-time Quiz Feedback**: Immediate correct/incorrect response indicators.
35. **Quiz Scoring**: Final performance summary.
36. **Knowledge Recap**: Explanations for quiz answers.
37. **Course History**: Track recently viewed educational content.

### 🏥 Wellness Hub (10 Features)
38. **Cycle Tracker**: Menstrual cycle logging and prediction.
39. **Symptom Logging**: Track cramps, headaches, and physical health.
40. **Mood Tracker**: Log daily feelings and emotional well-being.
41. **Maternity Wing**: Tracking milestones for expectant mothers.
42. **Mental Sanctuary**: Library of meditation and mindfulness guides.
43. **Symptom History**: View past health trends locally.
44. **Tele-Health Directory**: Search for trusted doctors.
45. **Professional Categorization**: Filter by Gynecologists or Psychologists.
46. **Wellness Insights**: Personalized health recommendations logic.
47. **Family Planning Guide**: Educational resources on reproductive health.

### 🛍️ Marketplace (10 Features)
48. **Product Catalog**: Beautiful grid view of items for sale.
49. **Granular Categorization**: Handmade, Clothing, Accessories, etc.
50. **Global Search**: Find products or services by name.
51. **Sell Item Form**: Comprehensive listing creation for users.
52. **Multi-Image Support**: Upload multiple photos per product.
53. **Product Details View**: Premium cards with pricing and description.
54. **Seller Identity**: Contact details for verified sellers.
55. **Verified Seller Badges**: Trust indicators for community members.
56. **Rating System**: Visual star ratings for products.
57. **Real-time Updates**: Marketplace items sync with Firestore.

### ⚖️ Legal Aid & Documents (10 Features)
58. **Rights Repository**: Organized database of women's legal rights.
59. **Legal Search**: Find specific laws or protections.
60. **STT Voice Assistant**: Hands-free command processing (Speech-to-Text).
61. **TTS Right Reader**: Automated reading of legal text (Text-to-Speech).
62. **Document Vault**: Secure cloud storage for sensitive files (ID, Marriage Certs).
63. **Folder Organization**: Categorized document management.
64. **Multi-format Support**: PDF, JPG, and PNG uploads.
65. **Secure Delete**: Permanent removal of cloud-stored documents.

### 🌍 Core Experience (8 Features)
66. **6-Language Localization**: English, Turkish, Urdu, Punjabi, Balochi, Sindhi.
67. **Dynamic RTL/LTR Switching**: Automatic layout flipping for regional languages.
68. **Responsive UI Engine**: Optimized for all screen sizes and resolutions.
69. **Glassmorphic Aesthetics**: Modern, premium design system.
70. **Global Navigation**: Intuitive side drawer access.
71. **Push Notifications**: Real-time foreground and background alerts.
72. **Real-time Firestore Sync**: Instant updates across the entire app.
73. **Resource Caching**: Local storage for faster performance.

---

## 📝 Updating Static Content
To replace placeholder text (e.g., "Detailed course content coming soon!") with your final project content:
1. Open [courses_data.dart](file:///Users/ali/StudioProjects/umeed_e_zann/lib/features/growth/data/models/courses_data.dart).
2. Edit the `title`, `description`, or `content` fields to match your actual course materials.
