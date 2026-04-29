# Firestore Indexes Setup Guide

## Overview
This app requires composite indexes in Firestore for efficient querying. The indexes are defined in `firestore.indexes.json`.

## Required Indexes

The following composite indexes are required:

1. **sos_alerts** collection:
   - Fields: `userId` (ASCENDING), `createdAt` (DESCENDING)
   - Used for: Querying SOS alerts by user, ordered by creation date

2. **fake_calls** collection:
   - Fields: `userId` (ASCENDING), `createdAt` (DESCENDING)
   - Used for: Querying fake call history by user, ordered by creation date

3. **certificates** collection:
   - Fields: `userId` (ASCENDING), `issuedAt` (DESCENDING)
   - Used for: Querying certificates by user, ordered by issue date

## Deployment Options

### Option 1: Automatic Deployment (Recommended)
If you're using Firebase CLI, the indexes will be automatically deployed when you run:
```bash
firebase deploy --only firestore:indexes
```

### Option 2: Manual Creation via Firebase Console
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: `umeed-e--zann`
3. Navigate to **Firestore Database** → **Indexes** tab
4. Click **Create Index**
5. For each index:
   - Select the collection group
   - Add fields in the order specified above
   - Set the order (ASCENDING/DESCENDING) as specified
   - Click **Create**

### Option 3: Using the Error Links
When the app encounters a missing index, Firebase provides direct links in the error messages. You can click these links to create the indexes automatically.

## Error Handling
The app now handles missing index errors gracefully:
- Instead of crashing, it returns empty lists/streams
- Error messages are logged to the console for debugging
- Users can continue using the app while indexes are being created

## Verification
After creating the indexes:
1. Wait a few minutes for them to build (Firebase will show "Building" status)
2. Once built, restart the app
3. The queries should work without errors

## Notes
- Index building can take a few minutes to several hours depending on data size
- Indexes are required for queries that filter by one field and order by another
- The app will continue to work (with empty results) until indexes are created

