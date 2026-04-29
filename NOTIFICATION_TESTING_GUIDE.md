# Notification Testing Guide for Safety Features

This guide explains how notifications work for shake alerts and live tracking, and how to properly test them.

## Understanding Notifications

### How Notifications Work

1. **Firestore Notifications**: When a shake alert or live tracking starts, notifications are created in the `notifications` collection in Firestore.

2. **SMS Notifications**: SMS messages are sent via `url_launcher`, which **opens your phone's SMS app** with a pre-filled message. **You must manually send the SMS** - it does not send automatically for security reasons.

3. **In-App Notifications**: Notifications appear in the app's notification center (if implemented) or can be viewed in Firestore.

---

## Important Notes

### ⚠️ SMS Behavior
- **SMS does NOT send automatically** - it opens the SMS app with a pre-filled message
- You must **manually tap "Send"** in the SMS app
- This is by design for security and privacy reasons
- The SMS app will open with:
  - Recipient phone number pre-filled
  - Message body pre-filled with SOS alert details
  - Google Maps link (if location is available)

### ⚠️ Notification Requirements
For notifications to work properly:
1. **Trusted contacts must be registered users** with accounts in the app
2. The `contactId` in `trusted_contacts` must match a `userId` in the `users` collection
3. The trusted contact must have the app installed and be logged in to see in-app notifications

---

## Testing Shake Alert Notifications

### Prerequisites
1. Add at least one trusted contact in **Safety** → **Trusted Contacts**
2. The trusted contact should have:
   - A phone number
   - A `contactId` that matches a user ID in the `users` collection (if you want in-app notifications)

### Test Steps

#### Test Case 1: Shake Alert Notification
1. Navigate to **Safety** → **Shake Alert**
2. Shake your device or click the "Trigger Alert" button
3. Wait for the alert to be created

**What Happens:**
- ✅ SOS alert is created in Firestore (`sos_alerts` collection)
- ✅ Notification is created in Firestore (`notifications` collection) for each trusted contact
- ✅ SMS app opens with pre-filled message (you must manually send)

**How to Verify:**

1. **Check Firestore - Notifications:**
   ```
   Collection: notifications
   Fields to check:
   - userId: Should be the contactId of your trusted contact
   - title: "SOS Alert"
   - message: Contains user's name and alert message
   - type: "sos_alert"
   - alertId: ID of the SOS alert
   - read: false
   - createdAt: Current timestamp
   ```

2. **Check Firestore - SOS Alerts:**
   ```
   Collection: sos_alerts
   Fields to check:
   - userId: Your user ID
   - location: { lat, lng }
   - message: Alert message
   - createdAt: Current timestamp
   ```

3. **Check SMS App:**
   - SMS app should open automatically
   - Recipient number should be pre-filled
   - Message should contain:
     - SOS ALERT emoji
     - User's name
     - Alert message
     - Location coordinates
     - Google Maps link
   - **You must manually tap "Send"**

---

## Testing Live Tracking Notifications

### Prerequisites
1. Add trusted contacts (same as shake alert)
2. Ensure location permissions are granted

### Test Steps

#### Test Case 1: Live Tracking Start Notification
1. Navigate to **Safety** → **Live Tracking**
2. Click "Start Live Tracking"
3. Wait for tracking to start

**What Happens:**
- ✅ Live tracking document is created in Firestore (`live_tracking` collection)
- ✅ Notification is created in Firestore for each trusted contact who is a viewer
- ✅ SMS app opens with pre-filled message (you must manually send)

**How to Verify:**

1. **Check Firestore - Notifications:**
   ```
   Collection: notifications
   Fields to check:
   - userId: Should be the contactId of your trusted contact
   - title: "Live Tracking Started"
   - message: Contains user's name and tracking message
   - type: "live_tracking"
   - trackingId: ID of the live tracking session
   - read: false
   - createdAt: Current timestamp
   ```

2. **Check Firestore - Live Tracking:**
   ```
   Collection: live_tracking
   Fields to check:
   - userId: Your user ID
   - viewerIds: Array of trusted contact IDs
   - status: "active"
   - startedAt: Current timestamp
   ```

3. **Check SMS App:**
   - SMS app should open automatically
   - Message should indicate live tracking has started

---

## Troubleshooting

### Issue: Notifications created in Firestore but not received

**Possible Causes:**
1. **Trusted contact is not a registered user**
   - Solution: The `contactId` must match a `userId` in the `users` collection
   - If the contact is not a user, they won't see in-app notifications
   - They will still receive SMS (if phone number is provided)

2. **Contact ID mismatch**
   - Check: `trusted_contacts` collection → `contactId` field
   - Verify: This `contactId` exists in `users` collection as a document ID
   - Fix: Update `contactId` to match an actual user ID

3. **Notification service not implemented**
   - The app may not have a notification listener/display system
   - Notifications are stored in Firestore but may not be displayed in-app
   - Check if there's a notifications screen in the app

### Issue: SMS app doesn't open

**Possible Causes:**
1. **No phone number in trusted contact**
   - Check: `trusted_contacts` collection → `phone` field
   - Ensure phone number is in correct format (e.g., +923001234567)

2. **SMS permission denied**
   - Check app permissions in device settings
   - Grant SMS permission if needed

3. **No SMS app installed**
   - Install a default SMS app
   - Some devices require a default SMS app to be set

### Issue: Progress not updating

**Possible Causes:**
1. **Video not marked as completed**
   - Progress updates when video is opened, not when watched
   - Check if video URL is valid and opens correctly

2. **Firebase save error**
   - Check console for error messages
   - Verify internet connection
   - Check Firestore rules allow write access

3. **Provider not updating**
   - Check if `notifyListeners()` is called after saving
   - Verify UI is listening to provider changes

---

## Manual Testing Checklist

### Shake Alert
- [ ] Add trusted contact with phone number
- [ ] Add trusted contact with contactId (matching a user ID)
- [ ] Trigger shake alert
- [ ] Verify notification created in Firestore `notifications` collection
- [ ] Verify SMS app opens with pre-filled message
- [ ] Manually send SMS
- [ ] Check if trusted contact (if logged in) sees notification in app

### Live Tracking
- [ ] Add trusted contacts
- [ ] Start live tracking
- [ ] Verify notification created in Firestore
- [ ] Verify SMS app opens
- [ ] Check live tracking document in Firestore
- [ ] Verify location updates are being saved

### Course Progress
- [ ] Open a course
- [ ] Click on a video lesson
- [ ] Verify video opens
- [ ] Check Firestore `course_progress` collection
- [ ] Verify `overallProgress` is updated
- [ ] Check course card shows updated progress
- [ ] Restart app and verify progress persists

---

## Firestore Collections Reference

### notifications
```json
{
  "userId": "contactId_of_trusted_contact",
  "title": "SOS Alert" | "Live Tracking Started",
  "message": "User name has sent an SOS alert...",
  "type": "sos_alert" | "live_tracking",
  "alertId": "alert_id" | "trackingId": "tracking_id",
  "read": false,
  "createdAt": "timestamp"
}
```

### sos_alerts
```json
{
  "userId": "your_user_id",
  "location": {
    "lat": 31.5204,
    "lng": 74.3587
  },
  "message": "SOS Alert triggered by shake detection",
  "createdAt": "timestamp"
}
```

### live_tracking
```json
{
  "userId": "your_user_id",
  "viewerIds": ["contactId1", "contactId2"],
  "status": "active" | "stopped",
  "startedAt": "timestamp",
  "locations": [
    {
      "lat": 31.5204,
      "lng": 74.3587,
      "accuracy": 10.0,
      "timestamp": "timestamp"
    }
  ],
  "lastUpdated": "timestamp"
}
```

### trusted_contacts
```json
{
  "userId": "your_user_id",
  "contactId": "user_id_of_contact", // Must match a user ID
  "name": "Contact Name",
  "phone": "+923001234567",
  "isActive": true
}
```

---

## Expected Behavior Summary

### ✅ What Works
- Firestore notifications are created
- SMS app opens with pre-filled message
- Location is included in SMS
- Google Maps link is provided
- Notifications persist in Firestore

### ⚠️ What Requires Manual Action
- **SMS must be manually sent** (security requirement)
- Trusted contacts must be registered users to see in-app notifications
- Notification display in app depends on notification service implementation

### ❌ What Doesn't Work Automatically
- SMS does not send automatically (by design)
- Push notifications require Firebase Cloud Messaging setup
- In-app notification display requires notification service implementation

---

## Next Steps for Full Notification Support

To enable full notification support:

1. **Implement Push Notifications**
   - Set up Firebase Cloud Messaging (FCM)
   - Send push notifications when alerts are created
   - Display notifications even when app is closed

2. **Implement In-App Notification Service**
   - Create a notification listener service
   - Display notifications in-app
   - Mark notifications as read
   - Create a notifications screen

3. **Auto-Send SMS (Optional)**
   - Requires SMS permission and special handling
   - May not work on all devices
   - Consider using a third-party SMS service

---

**Last Updated:** Based on current implementation with Firestore notifications and SMS via url_launcher.

