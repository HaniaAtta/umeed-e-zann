# 🔥 Firebase Integration Guide - Complete Architecture

## 📋 Table of Contents
1. [Firebase Initialization](#1-firebase-initialization)
2. [Firebase Services Layer](#2-firebase-services-layer)
3. [Provider Layer (State Management)](#3-provider-layer-state-management)
4. [UI Layer (Screens)](#4-ui-layer-screens)
5. [Data Flow Architecture](#5-data-flow-architecture)
6. [Firestore Collections Structure](#6-firestore-collections-structure)
7. [Firebase Storage Structure](#7-firebase-storage-structure)
8. [Connection Map](#8-connection-map)
9. [Password Reset Email Setup](#9-password-reset-email-setup)
10. [Error Handling & Logging](#10-error-handling--logging)

---

## 1. Firebase Initialization

### Entry Point: `lib/main.dart`

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase Core
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Enable Firebase App Check (Security)
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
  );

  runApp(const MyApp());
}
```

**Configuration Files:**
- `lib/firebase_options.dart` - Platform-specific Firebase config (API keys, project IDs)
- `android/app/google-services.json` - Android Firebase config
- `ios/Runner/GoogleService-Info.plist` - iOS Firebase config

**Dependencies (pubspec.yaml):**
```yaml
firebase_core: ^3.4.0          # Core Firebase SDK
firebase_auth: ^5.3.0           # Authentication
cloud_firestore: ^5.4.4         # NoSQL Database
firebase_storage: ^12.3.2       # File Storage
firebase_app_check: ^0.3.1+2   # Security
```

---

## 2. Firebase Services Layer

**Location:** `lib/data/services/`

All services directly interact with Firebase SDKs. They provide **business logic** and **data operations**.

### 2.1 Core Services

#### 🔐 AuthService (`lib/data/services/auth_service.dart`)
**Firebase Products Used:**
- `FirebaseAuth` - User authentication
- `FirebaseFirestore` - User profile storage

**Methods:**
- `signUp()` - Creates user in Firebase Auth + Firestore `users` collection
- `signIn()` - Authenticates user + loads profile from Firestore
- `signOut()` - Signs out from Firebase Auth
- `sendPasswordResetEmail()` - Sends password reset email via Firebase Auth + logs to Firestore
- `checkEmailExists()` - Checks if email exists in Firestore users collection
- `deleteAccount()` - Deletes user from Auth + Firestore
- `getCurrentUserData()` - Gets user profile from Firestore
- `updateUserData()` - Updates user profile in Firestore

**Firestore Collections:**
- `users/{userId}` - User profiles
- `password_reset_requests/{requestId}` - Password reset request logs
  - Fields: `email`, `requestedAt`, `status` ("email_sent" or "failed"), `emailExists`, `error`, `errorMessage`

---

#### 💾 FirestoreService (`lib/data/services/firestore_service.dart`)
**Firebase Products Used:**
- `FirebaseFirestore` - Generic CRUD operations

**Methods:**
- `createDocument()` - Create any document in any collection
- `getDocument()` - Get document by ID
- `updateDocument()` - Update document
- `deleteDocument()` - Delete document
- `getCollectionStream()` - Real-time stream of collection
- `queryDocuments()` - Query documents
- `searchDocuments()` - Client-side search
- `batchWrite()` - Batch operations

**Purpose:** Generic utility for any Firestore operations

---

#### 📁 StorageService (`lib/data/services/storage_service.dart`)
**Firebase Products Used:**
- `FirebaseStorage` - File storage
- `FirebaseAuth` - Get current user ID

**Methods:**
- `uploadProfileImage()` - Uploads to `profile_images/{userId}.jpg`
- `uploadDocument()` - Uploads to `documents/{userId}/{fileName}`
- `uploadProductImage()` - Uploads to `products/{productId}/image_{index}.jpg`
- `deleteFile()` - Deletes file from Storage

**Storage Paths:**
- `profile_images/{userId}.jpg`
- `documents/{userId}/{fileName}`
- `products/{productId}/image_{index}.jpg`

---

### 2.2 Module-Specific Services

#### 🛍️ MarketplaceService (`lib/data/services/marketplace_service.dart`)
**Firebase Products Used:**
- `FirebaseFirestore` - Product data

**Methods:**
- `createProduct()` - Creates product in `products` collection
- `getProduct()` - Gets product by ID
- `updateProduct()` - Updates product
- `deleteProduct()` - Deletes product
- `getAllProductsStream()` - Real-time stream of all products
- `getProductsBySeller()` - Gets products by seller ID
- `searchProducts()` - Client-side product search
- `getProductsByCategory()` - Filters by category

**Firestore Collections:**
- `products/{productId}` - Product listings

---

#### 📚 GrowthService (`lib/data/services/growth_service.dart`)
**Firebase Products Used:**
- `FirebaseFirestore` - Course progress & bookmarks
- `FirebaseAuth` - Get current user ID

**Methods:**
- `saveCourseProgress()` - Saves to `course_progress/{userId}_{courseId}`
- `getCourseProgress()` - Gets progress for user + course
- `getUserCourseProgress()` - Stream of all user progress
- `saveQuizResult()` - Saves quiz results in progress document
- `bookmarkCourse()` - Creates in `bookmarks/{userId}_{courseId}`
- `unbookmarkCourse()` - Deletes bookmark
- `isCourseBookmarked()` - Checks bookmark status
- `getBookmarkedCourseIds()` - Stream of bookmarked course IDs

**Firestore Collections:**
- `course_progress/{userId}_{courseId}` - User course progress
- `bookmarks/{userId}_{courseId}` - Bookmarked courses

---

#### ⚖️ LegalService (`lib/data/services/legal_service.dart`)
**Firebase Products Used:**
- `FirebaseFirestore` - Legal articles, documents, contacts
- `FirebaseAuth` - Get current user ID

**Methods:**
- `getLegalArticles()` - Stream of legal articles
- `getLegalArticle()` - Get article by ID
- `searchLegalArticles()` - Search articles
- `saveDocument()` - Saves to `user_documents/{documentId}`
- `getUserDocuments()` - Stream of user documents
- `deleteDocument()` - Deletes document
- `getSupportContacts()` - Gets support contacts
- `getLawyers()` - Gets lawyers directory
- `getNGOs()` - Gets NGOs directory
- `getHelplines()` - Gets helplines
- `logHelplineContact()` - Logs contact in `helpline_contacts`

**Firestore Collections:**
- `legal_articles/{articleId}` - Legal articles
- `user_documents/{documentId}` - User uploaded documents
- `support_contacts/{contactId}` - Support contacts
- `lawyers/{lawyerId}` - Lawyers directory
- `ngos/{ngoId}` - NGOs directory
- `helplines/{helplineId}` - Helplines
- `helpline_contacts/{contactId}` - Helpline contact logs

---

#### 👥 CommunityService (`lib/data/services/community_service.dart`)
**Firebase Products Used:**
- `FirebaseFirestore` - Forum posts & replies
- `FirebaseAuth` - Get current user ID

**Methods:**
- `createPost()` - Creates post in `forum_posts` collection
- `getAllPosts()` - Stream of all forum posts
- `getPost()` - Get post by ID + increment views
- `addReply()` - Creates reply in `forum_replies` + increments post reply count
- `getReplies()` - Stream of replies for a post
- `deletePost()` - Deletes post + all replies (batch)
- `searchPosts()` - Client-side post search

**Firestore Collections:**
- `forum_posts/{postId}` - Forum posts
- `forum_replies/{replyId}` - Forum replies

---

#### 🚨 SafetyService (`lib/data/services/safety_service.dart`)
**Firebase Products Used:**
- `FirebaseFirestore` - SOS alerts, contacts, tracking
- `FirebaseAuth` - Get current user ID

**Methods:**
- `createSOSAlert()` - Creates alert in `sos_alerts`
- `updateSOSStatus()` - Updates alert status
- `getUserSOSAlerts()` - Stream of user alerts
- `addTrustedContact()` - Creates in `trusted_contacts/{userId}_{contactId}`
- `removeTrustedContact()` - Deletes contact
- `getTrustedContacts()` - Stream of user contacts
- `startLiveTracking()` - Creates in `live_tracking`
- `updateLocation()` - Updates tracking location
- `stopLiveTracking()` - Deletes tracking
- `logFakeCall()` - Creates in `fake_calls`

**Firestore Collections:**
- `sos_alerts/{alertId}` - SOS emergency alerts
- `trusted_contacts/{userId}_{contactId}` - Trusted contacts
- `live_tracking/{trackingId}` - Live location tracking
- `fake_calls/{callId}` - Fake call logs

---

## 3. Provider Layer (State Management)

**Location:** `lib/modules/{module}/providers/` and `lib/features/wellness_hub/presentation/providers/`

Providers wrap services and provide **state management** using `ChangeNotifier`. They are registered in `main.dart` using `Provider` package.

### Provider Architecture:
```
UI Screen → Provider → Service → Firebase
```

### 3.1 Registered Providers (main.dart)

```dart
MultiProvider(
  providers: [
    // Core
    ChangeNotifierProvider(create: (_) => UserService()),
    ChangeNotifierProvider(create: (_) => NotificationService()),
    
    // Modules
    ChangeNotifierProvider(create: (_) => SafetyProvider()),
    ChangeNotifierProvider(create: (_) => GrowthProvider()),
    ChangeNotifierProvider(create: (_) => LegalProvider()),
    ChangeNotifierProvider(create: (_) => MarketplaceProvider()),
    
    // Wellness
    ChangeNotifierProvider(create: (_) => CycleTrackerProvider()),
    ChangeNotifierProvider(create: (_) => FamilyPlanningProvider()),
    ChangeNotifierProvider(create: (_) => MaternityWingProvider()),
  ],
)
```

### 3.2 Provider Examples

#### GrowthProvider (`lib/modules/growth/providers/growth_provider.dart`)
**Connects to:** `GrowthService`
**State:**
- `List<Course> courses`
- `Map<String, dynamic>? courseProgress`
- `List<String> bookmarkedCourseIds`
- `bool isLoading`
- `String? error`

**Methods:**
- `loadCourses()` → calls `GrowthService.getCourses()`
- `saveCourseProgress()` → calls `GrowthService.saveCourseProgress()`
- `loadCourseProgress()` → calls `GrowthService.getCourseProgress()`
- `bookmarkCourse()` → calls `GrowthService.bookmarkCourse()`
- `saveQuizResult()` → calls `GrowthService.saveQuizResult()`

---

#### MarketplaceProvider (`lib/modules/marketplace/providers/marketplace_provider.dart`)
**Connects to:** `MarketplaceService`
**State:**
- `List<Product> products`
- `bool isLoading`
- `String? error`

**Methods:**
- `loadProducts()` → subscribes to `MarketplaceService.getAllProductsStream()`
- `createProduct()` → calls `MarketplaceService.createProduct()`
- `updateProduct()` → calls `MarketplaceService.updateProduct()`
- `deleteProduct()` → calls `MarketplaceService.deleteProduct()`
- `searchProducts()` → calls `MarketplaceService.searchProducts()`

---

#### LegalProvider (`lib/modules/legal/providers/legal_provider.dart`)
**Connects to:** `LegalService`, `StorageService`
**State:**
- `List<Map<String, dynamic>> legalArticles`
- `List<Map<String, dynamic>> userDocuments`
- `bool isLoading`
- `String? error`

**Methods:**
- `loadLegalArticles()` → subscribes to `LegalService.getLegalArticles()`
- `saveDocument()` → calls `LegalService.saveDocument()` (after file upload)
- `loadUserDocuments()` → subscribes to `LegalService.getUserDocuments()`
- `deleteDocument()` → calls `LegalService.deleteDocument()`

---

#### SafetyProvider (`lib/modules/safety/providers/safety_provider.dart`)
**Connects to:** `SafetyService`
**State:**
- `List<Map<String, dynamic>> sosAlerts`
- `List<Map<String, dynamic>> trustedContacts`
- `bool isLoading`
- `String? error`

**Methods:**
- `createSOSAlert()` → calls `SafetyService.createSOSAlert()`
- `loadSOSAlerts()` → subscribes to `SafetyService.getUserSOSAlerts()`
- `addTrustedContact()` → calls `SafetyService.addTrustedContact()`
- `loadTrustedContacts()` → subscribes to `SafetyService.getTrustedContacts()`

---

## 4. UI Layer (Screens)

**Location:** `lib/modules/{module}/screens/` and `lib/features/wellness_hub/presentation/screens/`

Screens use `Provider.of()` or `Consumer` to access providers and display data.

### 4.1 Screen Connection Pattern

```dart
class MyScreen extends StatefulWidget {
  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  @override
  void initState() {
    super.initState();
    // Load data from provider
    final provider = Provider.of<MyProvider>(context, listen: false);
    provider.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) return CircularProgressIndicator();
        if (provider.error != null) return Text(provider.error!);
        
        return ListView.builder(
          itemCount: provider.items.length,
          itemBuilder: (context, index) {
            return ItemCard(item: provider.items[index]);
          },
        );
      },
    );
  }
}
```

### 4.2 Screen Examples

#### Marketplace Home (`lib/modules/marketplace/screens/marketplace_home.dart`)
**Connects to:** `MarketplaceProvider`
**Actions:**
- `initState()` → `Provider.of<MarketplaceProvider>(context, listen: false).loadProducts()`
- `ListView.builder` → displays `provider.products`
- "Add Product" button → navigates to `AddProductScreen`

---

#### Add Product Screen (`lib/modules/marketplace/screens/add_product_screen.dart`)
**Connects to:** `MarketplaceService`, `StorageService`, `AuthService`
**Flow:**
1. User fills form
2. `_submitProduct()`:
   - Gets user from `AuthService.getCurrentUserData()`
   - Creates `Product` object
   - Calls `MarketplaceService.createProduct()` → gets `productId`
   - Uploads images via `StorageService.uploadProductImage()` for each image
   - Updates product with image URLs via `MarketplaceService.updateProduct()`

---

#### Course Detail Screen (`lib/modules/growth/screens/course_detail_screen.dart`)
**Connects to:** `GrowthProvider`
**Actions:**
- `initState()` → `provider.loadCourseProgress(courseId)`
- Video completion → `provider.saveCourseProgress()`
- Quiz completion → `provider.saveQuizResult()` then `provider.saveCourseProgress()`
- Displays progress from `provider.courseProgress`

---

#### Document Vault Screen (`lib/modules/legal/screens/document_vault_screen.dart`)
**Connects to:** `LegalProvider`, `StorageService`, `AuthService`
**Flow:**
1. `initState()` → `provider.loadUserDocuments()`
2. `_uploadDocument()`:
   - User picks file via `FilePicker`
   - Uploads via `StorageService.uploadDocument()` → gets `fileUrl`
   - Saves metadata via `provider.saveDocument(title, type, fileUrl)`
3. Displays documents from `provider.userDocuments` stream

---

#### Forum Home (`lib/modules/community/screens/forum_home.dart`)
**Connects to:** `CommunityService` (directly, no provider)
**Actions:**
- `initState()` → subscribes to `_communityService.getAllPosts().listen()`
- Displays posts from `_posts` list
- "Create Post" → navigates to `CreatePostScreen`

---

#### Create Post Screen (`lib/modules/community/screens/create_post_screen.dart`)
**Connects to:** `CommunityService`, `AuthService`
**Flow:**
1. User fills form
2. `_submitPost()`:
   - Gets user from `AuthService.getCurrentUserData()`
   - Calls `CommunityService.createPost()`
   - Shows success/error message

---

## 5. Data Flow Architecture

### Complete Flow Example: Creating a Product

```
1. User Action (UI)
   └─> AddProductScreen._submitProduct()
       │
2. Authentication Check
   └─> AuthService.getCurrentUserData()
       │
3. Create Product in Firestore
   └─> MarketplaceService.createProduct()
       └─> FirebaseFirestore.collection('products').add()
           │
4. Upload Images to Storage
   └─> StorageService.uploadProductImage()
       └─> FirebaseStorage.ref('products/{productId}/image_{index}.jpg').putFile()
           │
5. Update Product with Image URLs
   └─> MarketplaceService.updateProduct()
       └─> FirebaseFirestore.collection('products').doc(productId).update()
           │
6. Real-time Update
   └─> MarketplaceProvider listens to stream
       └─> MarketplaceService.getAllProductsStream()
           └─> FirebaseFirestore.collection('products').snapshots()
               │
7. UI Update
   └─> Consumer<MarketplaceProvider> rebuilds
       └─> marketplace_home.dart displays new product
```

### Real-time Data Flow Example: Forum Posts

```
1. User Creates Post
   └─> CommunityService.createPost()
       └─> FirebaseFirestore.collection('forum_posts').add()
           │
2. Firestore Triggers Stream
   └─> forum_posts collection changes
       │
3. Stream Listener Updates
   └─> forum_home.dart listens to:
       └─> CommunityService.getAllPosts()
           └─> FirebaseFirestore.collection('forum_posts').snapshots()
               │
4. UI Automatically Updates
   └─> setState() called with new posts
       └─> ListView.builder rebuilds with new data
```

---

## 6. Firestore Collections Structure

### Users
```
users/
  {userId}/
    - email: String
    - name: String?
    - phone: String?
    - gender: String
    - createdAt: Timestamp
    - settings: Map
    - trustedContacts: List
```

### Products (Marketplace)
```
products/
  {productId}/
    - title: String
    - description: String
    - price: double
    - category: String
    - sellerId: String
    - sellerName: String
    - images: List<String>
    - isActive: bool
    - createdAt: Timestamp
    - updatedAt: Timestamp
```

### Course Progress (Growth)
```
course_progress/
  {userId}_{courseId}/
    - userId: String
    - courseId: String
    - completedVideoIds: List<String>
    - quizResults: Map<String, Map>
    - overallProgress: double
    - updatedAt: Timestamp

bookmarks/
  {userId}_{courseId}/
    - userId: String
    - courseId: String
    - bookmarkedAt: Timestamp
```

### Forum (Community)
```
forum_posts/
  {postId}/
    - userId: String
    - title: String
    - content: String
    - category: String
    - authorName: String
    - isAnonymous: bool
    - replies: int
    - views: int
    - createdAt: Timestamp
    - updatedAt: Timestamp

forum_replies/
  {replyId}/
    - userId: String
    - postId: String
    - content: String
    - authorName: String
    - isAnonymous: bool
    - createdAt: Timestamp
```

### Documents (Legal)
```
user_documents/
  {documentId}/
    - userId: String
    - title: String
    - type: String
    - fileUrl: String
    - description: String?
    - metadata: Map
    - uploadedAt: Timestamp

legal_articles/
  {articleId}/
    - title: String
    - content: String
    - category: String
    - isPublished: bool
    - createdAt: Timestamp
```

### Safety
```
sos_alerts/
  {alertId}/
    - userId: String
    - status: String
    - location: GeoPoint
    - createdAt: Timestamp

trusted_contacts/
  {userId}_{contactId}/
    - userId: String
    - name: String
    - phone: String
    - relationship: String

live_tracking/
  {trackingId}/
    - userId: String
    - locations: List<GeoPoint>
    - status: String
    - createdAt: Timestamp

fake_calls/
  {callId}/
    - userId: String
    - contactName: String
    - contactPhone: String
    - createdAt: Timestamp
```

### Password Reset Logging
```
password_reset_requests/
  {requestId}/
    - email: String
    - requestedAt: Timestamp
    - status: String ("email_sent" or "failed")
    - emailExists: bool
    - error: String? (if failed)
    - errorMessage: String? (if failed)
    - note: String? (additional info)
```

---

## 7. Firebase Storage Structure

```
firebase_storage/
  ├── profile_images/
  │   └── {userId}.jpg
  │
  ├── documents/
  │   └── {userId}/
  │       └── {fileName}
  │
  └── products/
      └── {productId}/
          ├── image_0.jpg
          ├── image_1.jpg
          └── image_2.jpg
```

---

## 8. Connection Map

### Authentication Flow
```
LoginScreen/SignupScreen
  └─> AuthService
      ├─> FirebaseAuth (sign in/up)
      └─> FirebaseFirestore (save/load user profile)

Forgot Password Flow:
LoginScreen._handleForgotPassword()
  └─> Shows email input dialog
      └─> AuthService.sendPasswordResetEmail()
          ├─> Checks email exists in Firestore
          ├─> FirebaseAuth.sendPasswordResetEmail() (sends email)
          └─> Logs to Firestore: password_reset_requests
              └─> Shows success dialog with instructions
```

### Marketplace Flow
```
marketplace_home.dart
  └─> MarketplaceProvider
      └─> MarketplaceService
          └─> FirebaseFirestore.collection('products')

add_product_screen.dart
  ├─> AuthService (get user)
  ├─> MarketplaceService (create product)
  └─> StorageService (upload images)
```

### Growth/Courses Flow
```
course_detail_screen.dart
  └─> GrowthProvider
      └─> GrowthService
          └─> FirebaseFirestore.collection('course_progress')
```

### Legal/Documents Flow
```
document_vault_screen.dart
  ├─> LegalProvider
  │   └─> LegalService
  │       └─> FirebaseFirestore.collection('user_documents')
  └─> StorageService
      └─> FirebaseStorage.ref('documents/{userId}/{fileName}')
```

### Community/Forum Flow
```
forum_home.dart
  └─> CommunityService (direct)
      └─> FirebaseFirestore.collection('forum_posts').snapshots()

create_post_screen.dart
  ├─> AuthService (get user)
  └─> CommunityService
      └─> FirebaseFirestore.collection('forum_posts').add()
```

### Safety Flow
```
safety_screen.dart
  └─> SafetyProvider
      └─> SafetyService
          ├─> FirebaseFirestore.collection('sos_alerts')
          ├─> FirebaseFirestore.collection('trusted_contacts')
          └─> FirebaseFirestore.collection('live_tracking')
```

---

## 🔑 Key Points

1. **Initialization:** Firebase is initialized once in `main.dart` before the app runs
2. **Services:** All Firebase operations go through service classes in `lib/data/services/`
3. **Providers:** State management layer that wraps services (registered in `main.dart`)
4. **Screens:** UI layer that uses providers via `Provider.of()` or `Consumer`
5. **Real-time:** Most data uses Firestore streams for automatic UI updates
6. **Storage:** Files are uploaded to Firebase Storage, URLs saved in Firestore
7. **Authentication:** All services check `FirebaseAuth.currentUser` for user ID

---

## 📝 Summary

**Firebase Integration Path:**
```
main.dart (Initialize)
  ↓
Services (lib/data/services/*.dart)
  ↓
Providers (lib/modules/*/providers/*.dart)
  ↓
Screens (lib/modules/*/screens/*.dart)
```

**Firebase Products Used:**
- ✅ Firebase Core - Initialization
- ✅ Firebase Auth - User authentication
- ✅ Cloud Firestore - Database (all collections)
- ✅ Firebase Storage - File storage (images, documents)
- ✅ Firebase App Check - Security

**Total Firebase Collections:** 16+
**Total Firebase Services:** 7
**Total Providers:** 7
**All Connected and Working!** ✅

---

## 9. Password Reset Email Setup

### ⚠️ Important: Firebase Email Configuration Required

Password reset emails are sent via **Firebase Auth**, not stored in Firestore. However, all reset requests are **logged** to Firestore for tracking.

### Setup Steps:

1. **Firebase Console** → **Authentication** → **Settings**
   - Enable **Email/Password** provider
   - Configure **Authorized domains**

2. **Firebase Console** → **Authentication** → **Templates**
   - Configure **Password reset** email template
   - Customize subject and body
   - Set action URL (default: Firebase URL)

3. **Check Email Delivery:**
   - Emails may go to **spam folder**
   - Check `password_reset_requests` collection in Firestore for logs
   - Verify email status: `"email_sent"` or `"failed"`

### Password Reset Flow:

```
1. User clicks "Forgot Password?"
   └─> Email input dialog appears

2. User enters email
   └─> AuthService.sendPasswordResetEmail()
       ├─> Checks if email exists (Firestore)
       ├─> Sends email via Firebase Auth
       └─> Logs request to password_reset_requests collection

3. Firebase Auth sends email
   └─> User receives email with reset link
   └─> Link expires after 1 hour

4. User clicks link
   └─> Opens Firebase's secure reset page
   └─> User sets new password

5. User logs in with new password
```

### Troubleshooting:

- **Email not received?** Check spam folder, verify Firebase email templates are configured
- **Check Firestore:** Look at `password_reset_requests` collection for error details
- **See:** `FIREBASE_EMAIL_SETUP_GUIDE.md` for detailed setup instructions

---

## 10. Error Handling & Logging

### Debug Logging:
- Uses `debugPrint()` instead of `print()` (Flutter best practice)
- Logs only in debug mode, not in production

### Error Tracking:
- All password reset attempts logged to `password_reset_requests`
- Failed operations include error codes and messages
- Success operations include status and timestamps

### Firestore Logging Collections:
- `password_reset_requests` - Password reset attempts
- Future: Can add logging for other critical operations
