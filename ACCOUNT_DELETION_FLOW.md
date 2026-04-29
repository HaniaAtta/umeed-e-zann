# Account Deletion Flow

## Overview
This document describes the complete flow for deleting a user account in the app.

## Flow Diagram

```
User clicks "Delete Account" in Settings
    ↓
Confirmation Dialog appears
    ↓
User confirms "Delete Forever"
    ↓
Settings Screen → AuthProvider.deleteAccount()
    ↓
AuthProvider → AuthRepository.deleteAccount()
    ↓
AuthRepository → AuthRemoteDataSource.deleteAccount()
    ↓
Delete Firestore user document
    ↓
Delete Firebase Auth user
    ↓
Clear local UserService data
    ↓
Navigate to Signup Screen
    ↓
Show success message
```

## Step-by-Step Flow

### 1. **User Initiates Deletion** (`settings_screen.dart`)
- Location: `lib/features/profile/presentation/pages/settings_screen.dart`
- Method: `_deleteAccount(BuildContext context)`
- User clicks "Delete Account" button in Settings screen

### 2. **Confirmation Dialog**
- Shows an AlertDialog with:
  - Title: "Confirm Deletion"
  - Message: "This will permanently delete your account and all associated data. This action cannot be undone."
  - Actions:
    - "Cancel" button (closes dialog)
    - "Delete Forever" button (proceeds with deletion)

### 3. **Account Deletion Process** (when user confirms)

#### 3.1. **Presentation Layer** (`settings_screen.dart`)
```dart
// Delete account (this also signs out the user)
final authProvider = Provider.of<AuthProvider>(context, listen: false);
await authProvider.deleteAccount();
```

#### 3.2. **Provider Layer** (`auth_provider.dart`)
- Location: `lib/features/auth/presentation/viewmodels/auth_provider.dart`
- Method: `deleteAccount()`
- Actions:
  - Sets loading state to `true`
  - Clears any previous errors
  - Calls repository to delete account
  - Sets `_currentUser` to `null` on success
  - Handles errors and sets error message

#### 3.3. **Repository Layer** (`auth_repository_impl.dart`)
- Location: `lib/features/auth/data/repositories/auth_repository_impl.dart`
- Method: `deleteAccount()`
- Actions:
  - Calls remote data source to delete account
  - Propagates exceptions if deletion fails

#### 3.4. **Data Source Layer** (`auth_remote_datasource.dart`)
- Location: `lib/features/auth/data/datasources/auth_remote_datasource.dart`
- Method: `deleteAccount()`
- Actions:
  1. **Get current user** from Firebase Auth
  2. **Delete Firestore document**: 
     ```dart
     await _firestore.collection('users').doc(user.uid).delete();
     ```
  3. **Delete Firebase Auth user**:
     ```dart
     await user.delete();
     ```

### 4. **Local Data Cleanup** (`settings_screen.dart`)
```dart
// Clear local user data
_userService.clearUserData();
```
- Clears all local user data from UserService:
  - Name, Email, Phone, Gender, Date of Birth, Location

### 5. **Navigation** (`settings_screen.dart`)
```dart
Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
  AppRouter.signup,
  (route) => false,
);
```
- Navigates to Signup screen
- Removes all previous routes from navigation stack
- User is effectively logged out

### 6. **Success Feedback**
- Shows a success SnackBar after navigation:
  - Message: "Account deleted successfully"
  - Duration: 3 seconds
  - Background: Success color (green)

## Error Handling

### Error Scenarios:
1. **No user logged in**: Throws exception "No user logged in"
2. **Firestore deletion fails**: Exception propagated up
3. **Firebase Auth deletion fails**: Exception propagated up
4. **Network errors**: Exception caught and displayed to user

### Error Display:
- Error SnackBar shown in Settings screen
- Message: "Failed to delete account: [error message]"
- Duration: 4 seconds
- Background: Danger color (red)

## Important Notes

### ⚠️ What Gets Deleted:
- ✅ User document in Firestore (`users/{userId}`)
- ✅ Firebase Auth user account
- ✅ Local app data (UserService)

### ⚠️ What Does NOT Get Deleted:
- ❌ User's data in other collections (e.g., `sos_alerts`, `fake_calls`, `certificates`, etc.)
- ❌ Files in Firebase Storage (profile images, documents, etc.)
- ❌ Any data in other Firebase services

### 🔒 Security Considerations:
- User must be authenticated to delete account
- Deletion requires explicit confirmation
- Cannot be undone once completed
- User is automatically signed out after deletion

## Code Locations

| Layer | File | Method |
|-------|------|--------|
| UI | `lib/features/profile/presentation/pages/settings_screen.dart` | `_deleteAccount()` |
| Provider | `lib/features/auth/presentation/viewmodels/auth_provider.dart` | `deleteAccount()` |
| Repository | `lib/features/auth/data/repositories/auth_repository_impl.dart` | `deleteAccount()` |
| Data Source | `lib/features/auth/data/datasources/auth_remote_datasource.dart` | `deleteAccount()` |
| Service | `lib/core/services/user_service.dart` | `clearUserData()` |

## Testing the Flow

1. **Navigate to Settings** → Profile → Settings
2. **Scroll to "Delete Account"** section
3. **Click "Delete Account"** button
4. **Confirm deletion** in the dialog
5. **Verify**:
   - User document deleted from Firestore
   - Firebase Auth user deleted
   - App navigates to Signup screen
   - Success message appears
   - Local data cleared

## Potential Improvements

1. **Cascade Deletion**: Consider deleting related data in other collections
2. **Storage Cleanup**: Delete user's files from Firebase Storage
3. **Soft Delete**: Option to mark account as deleted instead of hard delete
4. **Data Export**: Allow users to export their data before deletion
5. **Re-authentication**: Require password confirmation before deletion (security best practice)

