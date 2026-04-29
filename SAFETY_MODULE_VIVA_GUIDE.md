# 🚨 Safety Module: Comprehensive Viva Guide

This guide is your "Weapon of Defense" for the Technical Viva. It breaks down every file, every layer, and every tricky function in the **Safety Module**.

---

## 🗺️ Part 1: The Safety Module File Map
If the examiner asks: *"Show me the files involved in the Safety module,"* you show them this structure inside `lib/features/safety`:

| Layer | Files | Responsibility |
| :--- | :--- | :--- |
| **Domain** | `entities/sos_alert_entity.dart` | The "Blueprint" of what an SOS alert looks like. |
| | `usecases/create_sos_alert.dart` | Pure logic for creating alerts. |
| **Data** | `models/sos_alert_model.dart` | Handles JSON/Firestore conversion (fromFirestore/toJson). |
| | `datasources/safety_remote_datasource.dart` | **The Firebase Engine.** Direct Firestore calls. |
| | `repositories/safety_repository_impl.dart` | The middle-man that connects Firebase to the UseCases. |
| **Presentation** | `viewmodels/safety_provider.dart` | **The Brain of the UI.** Manages state and listeners. |
| | `pages/sos_screen.dart` | The UI with the big SOS button and countdown. |
| | `pages/shake_alert_screen.dart` | Accelerometer logic and shake settings. |

---

## 🔄 Part 2: The "Journey" of an SOS Alert
**Question:** *"Explain the flow of code when I press the SOS button."*

1.  **UI (`sos_screen.dart`)**: User taps the button. A 5-second countdown starts.
2.  **ViewModel (`safety_provider.dart`)**: Once the timer hits zero, the UI calls `provider.createSosAlert()`.
3.  **GPS Integration**: The app uses the `geolocator` package to get the Latitude and Longitude.
4.  **UseCase (`create_sos_alert.dart`)**: The logic is passed to the UseCase to ensure it's a valid request.
5.  **Repository (`safety_repository_impl.dart`)**: The repository takes the "Entity" and passes it to the Data Source.
6.  **DataSource (`safety_remote_datasource.dart`)**:
    *   It creates a document in the `sos_alerts` collection.
    *   It creates a notification in the `notifications` collection for trusted contacts.
    *   It triggers an **SMS app launch** with a pre-filled Google Maps link.

---

## 🧪 Part 3: Deep Dive into "Complex" Logic

### 1. The Accelerometer (Shake-to-Alert)
**File:** `lib/features/safety/presentation/pages/shake_alert_screen.dart`
*   **Package:** `sensors_plus`
*   **Logic:** 
    *   We listen to the `accelerometerEventStream`.
    *   We calculate the **magnitude** of movement using the Pythagorean theorem: `sqrt(x² + y² + z²)`.
    *   If that number is higher than the `threshold` (determined by your sensitivity setting), we count it as a "shake."
    *   2-3 shakes in quick succession trigger the alert.

### 2. The In-App Fallback (iOS Alert)
**File:** `lib/features/safety/presentation/viewmodels/safety_provider.dart`
*   **Logic:** We have a `StreamSubscription` listening to the `notifications` collection in Firestore. 
*   **Why?** Because if you are on iOS and don't have a paid developer account, you can't get background push notifications. This listener ensures that **if the app is open**, you still get a red alert immediately.

---

## 💡 Part 4: "Explain these 5 lines" (Tricky Snippets)

### Snippet A: The Shake Threshold Logic
```dart
// ShakeAlertScreen.dart: L101
final threshold = 12.0 - (_sensitivity * 2.0);
```
**Explanation:** This is a dynamic threshold calculation. If sensitivity is 5 (High), the threshold is `12 - 10 = 2.0` (very easy to trigger). If sensitivity is 1 (Low), the threshold is `12 - 2 = 10.0` (needs a violent shake).

### Snippet B: The Firestore Snapshot Listener
```dart
// SafetyRemoteDataSourceImpl.dart: L119
return _firestore
    .collection('sos_alerts')
    .where('userId', isEqualTo: userId)
    .orderBy('createdAt', descending: true)
    .snapshots()
```
**Explanation:** 
*   `collection('sos_alerts')`: Choosing the table.
*   `where(...)`: Filtering to only see the current user's alerts.
*   `orderBy(...)`: Showing newest alerts first.
*   `.snapshots()`: This is **Real-time**. It doesn't just get data once; it keeps the connection open. If a new alert is added in the cloud, the UI updates automatically without refreshing!

### Snippet C: The SMS Trigger
```dart
// SafetyRemoteDataSourceImpl.dart: L558
final smsUrl = Uri.parse('sms:$cleanPhone?body=${Uri.encodeComponent(helpMessage)}');
if (await canLaunchUrl(smsUrl)) {
    await launchUrl(smsUrl, mode: LaunchMode.externalApplication);
}
```
**Explanation:** This uses `url_launcher`. It creates a special "SMS link." When the app calls `launchUrl`, it tells the OS to open the native Messages app with the phone number and the SOS message (including the GPS link) already typed in!

---

## ✅ Final Advice for the Viva:
*   **Entities vs Models:** Remember that **Entities** are for the Domain (clean, no JSON) and **Models** are for the Data layer (contains `fromFirestore` and `toJson`).
*   **Repositories:** If he asks why we have an "abstract class" and an "impl," say: *"It follows the Dependency Inversion Principle. It allows us to decouple the logic from the specific database implementation."*
*   **State Management:** If he asks about `notifyListeners()`, say: *"It tells the Flutter framework that the data has changed, so all widgets wrapped in a `Consumer` or `watch` need to rebuild."*
