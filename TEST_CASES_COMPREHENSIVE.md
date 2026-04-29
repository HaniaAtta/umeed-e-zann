# 🧪 Comprehensive Test Cases for Umeed-e-Zann App

## ✅ Already Tested
- ✅ **Sign Up** - Working perfectly
- ✅ **Forgot Password** - Working perfectly

---

## 📱 1. AUTHENTICATION MODULE

### 1.1 Login
- [ ] **TC-AUTH-001**: Login with valid credentials
  - Enter registered email and password
  - Verify successful login and navigation to home screen
  - Verify user data is loaded correctly

- [ ] **TC-AUTH-002**: Login with invalid email
  - Enter invalid email format (e.g., "test@")
  - Verify error message appears
  - Verify login button is disabled or shows error

- [ ] **TC-AUTH-003**: Login with wrong password
  - Enter correct email but wrong password
  - Verify error message: "Wrong password provided"
  - Verify user is not logged in

- [ ] **TC-AUTH-004**: Login with non-existent email
  - Enter email that doesn't exist in database
  - Verify error message: "No user found for that email"
  - Verify user is not logged in

- [ ] **TC-AUTH-005**: Login with empty fields
  - Leave email and password empty
  - Click login button
  - Verify validation errors appear

- [ ] **TC-AUTH-006**: Login with network error
  - Turn off internet connection
  - Attempt to login
  - Verify error message: "No internet connection. Please check your network and try again."
  - Verify WiFi-off icon appears in error message

- [ ] **TC-AUTH-007**: Login loading state
  - Enter valid credentials
  - Click login button
  - Verify loading indicator appears
  - Verify button is disabled during loading

- [ ] **TC-AUTH-008**: Navigate to Sign Up from Login
  - Click "Sign Up" link at bottom
  - Verify navigation to signup screen

- [ ] **TC-AUTH-009**: Navigate to Forgot Password
  - Click "Forgot Password?" link
  - Verify forgot password dialog appears

---

## 👤 2. PROFILE & SETTINGS MODULE

### 2.1 Profile Screen
- [ ] **TC-PROF-001**: View profile information
  - Navigate to Profile tab
  - Verify name, email, phone, location are displayed
  - Verify profile image is displayed (if uploaded)

- [ ] **TC-PROF-002**: Edit profile name
  - Click edit button or tap name field
  - Enter new name
  - Save changes
  - Verify name is updated in Firestore
  - Verify updated name appears on screen

- [ ] **TC-PROF-003**: Edit profile email
  - Edit email field
  - Enter new email
  - Save changes
  - Verify email is updated in Firestore
  - Verify updated email appears on screen

- [ ] **TC-PROF-004**: Edit profile phone
  - Edit phone field
  - Enter new phone number
  - Save changes
  - Verify phone is updated in Firestore

- [ ] **TC-PROF-005**: Edit profile location
  - Edit location field
  - Enter new location
  - Save changes
  - Verify location is updated in Firestore

- [ ] **TC-PROF-006**: Upload profile image
  - Click on profile image
  - Select image from gallery
  - Verify image uploads to Firebase Storage
  - Verify image URL is saved to Firestore
  - Verify new image appears on profile screen

- [ ] **TC-PROF-007**: Navigate to Settings
  - Click Settings button/icon
  - Verify navigation to Settings screen

- [ ] **TC-PROF-008**: Logout functionality
  - Click logout button
  - Verify user is logged out
  - Verify navigation to login screen

- [ ] **TC-PROF-009**: Delete account
  - Click delete account option
  - Confirm deletion
  - Verify account is deleted from Firestore
  - Verify navigation to signup/login screen

### 2.2 Settings Screen
- [ ] **TC-SETT-001**: View current settings
  - Navigate to Settings
  - Verify all settings are displayed
  - Verify current values are shown correctly

- [ ] **TC-SETT-002**: Toggle notifications ON
  - Toggle notifications switch to ON
  - Verify setting is saved to Firestore
  - Verify notifications are enabled

- [ ] **TC-SETT-003**: Toggle notifications OFF
  - Toggle notifications switch to OFF
  - Verify setting is saved to Firestore
  - Verify notifications are disabled
  - Verify no new notifications are created

- [ ] **TC-SETT-004**: Change language preference
  - Select different language
  - Verify setting is saved to Firestore
  - Verify app language changes (if implemented)

- [ ] **TC-SETT-005**: Change theme (if implemented)
  - Toggle dark/light theme
  - Verify theme changes
  - Verify setting is saved

- [ ] **TC-SETT-006**: Settings persistence
  - Change settings
  - Close app
  - Reopen app
  - Verify settings are still saved

---

## 🛡️ 3. SAFETY MODULE

### 3.1 Safety Dashboard
- [ ] **TC-SAFE-001**: View safety dashboard
  - Navigate to Safety tab
  - Verify all safety features are displayed
  - Verify cards for SOS, Trusted Contacts, Live Tracking, etc.

- [ ] **TC-SAFE-002**: Navigate to SOS screen
  - Click on SOS Alert card
  - Verify navigation to SOS screen

- [ ] **TC-SAFE-003**: Navigate to Trusted Contacts
  - Click on Trusted Contacts card
  - Verify navigation to Trusted Contacts screen

- [ ] **TC-SAFE-004**: Navigate to Live Tracking
  - Click on Live Tracking card
  - Verify navigation to Live Tracking screen

- [ ] **TC-SAFE-005**: Navigate to Shake Alert
  - Click on Shake Alert card
  - Verify navigation to Shake Alert screen

- [ ] **TC-SAFE-006**: Navigate to Fake Call
  - Click on Fake Call card
  - Verify navigation to Fake Call screen

### 3.2 SOS Alert
- [ ] **TC-SOS-001**: Create SOS alert
  - Navigate to SOS screen
  - Click "Send SOS Alert" button
  - Grant location permission if prompted
  - Verify SOS alert is created in Firestore
  - Verify alert includes current location
  - Verify alert is sent to trusted contacts

- [ ] **TC-SOS-002**: View SOS alert history
  - Navigate to SOS screen
  - Scroll to alert history section
  - Verify past alerts are displayed
  - Verify alert details (time, location, status)

- [ ] **TC-SOS-003**: Location permission denied
  - Deny location permission
  - Try to create SOS alert
  - Verify appropriate error message
  - Verify permission request dialog appears

- [ ] **TC-SOS-004**: SOS alert with no trusted contacts
  - Remove all trusted contacts
  - Create SOS alert
  - Verify warning message appears
  - Verify alert is still created

### 3.3 Trusted Contacts
- [ ] **TC-CONT-001**: Add trusted contact
  - Navigate to Trusted Contacts screen
  - Click "Add Contact" button
  - Enter name, phone number, relation
  - Save contact
  - Verify contact is added to Firestore
  - Verify contact appears in list

- [ ] **TC-CONT-002**: View trusted contacts list
  - Navigate to Trusted Contacts screen
  - Verify all contacts are displayed
  - Verify contact details (name, phone, relation)

- [ ] **TC-CONT-003**: Edit trusted contact
  - Click on existing contact
  - Edit contact details
  - Save changes
  - Verify contact is updated in Firestore
  - Verify updated details appear

- [ ] **TC-CONT-004**: Delete trusted contact
  - Click delete button on contact
  - Confirm deletion
  - Verify contact is removed from Firestore
  - Verify contact disappears from list

- [ ] **TC-CONT-005**: Add duplicate phone number
  - Try to add contact with existing phone number
  - Verify error message appears
  - Verify contact is not added

- [ ] **TC-CONT-006**: Maximum contacts limit
  - Add contacts until limit is reached
  - Try to add one more contact
  - Verify error message about limit
  - Verify contact is not added

### 3.4 Live Tracking
- [ ] **TC-TRACK-001**: Start live tracking session
  - Navigate to Live Tracking screen
  - Click "Start Tracking" button
  - Grant location permission
  - Verify tracking session is created in Firestore
  - Verify location updates are sent

- [ ] **TC-TRACK-002**: Stop live tracking
  - Start tracking session
  - Click "Stop Tracking" button
  - Verify session is ended in Firestore
  - Verify location updates stop

- [ ] **TC-TRACK-003**: View active tracking session
  - Start tracking session
  - Verify session status is displayed
  - Verify current location is shown on map

- [ ] **TC-TRACK-004**: Share tracking link
  - Start tracking session
  - Click share button
  - Verify tracking link is generated
  - Verify link can be shared

### 3.5 Shake Alert
- [ ] **TC-SHAKE-001**: Enable shake alert
  - Navigate to Shake Alert screen
  - Toggle shake alert ON
  - Set sensitivity level
  - Save settings
  - Verify settings are saved to Firestore

- [ ] **TC-SHAKE-002**: Disable shake alert
  - Toggle shake alert OFF
  - Save settings
  - Verify settings are saved
  - Verify shake detection is disabled

- [ ] **TC-SHAKE-003**: Adjust sensitivity
  - Change sensitivity slider
  - Save settings
  - Verify sensitivity value is saved

- [ ] **TC-SHAKE-004**: Test shake detection (if possible)
  - Enable shake alert
  - Shake device
  - Verify SOS alert is triggered (if implemented)

### 3.6 Fake Call
- [ ] **TC-FAKE-001**: Initiate fake call
  - Navigate to Fake Call screen
  - Click "Start Fake Call" button
  - Verify fake call screen appears
  - Verify call is logged in Firestore

- [ ] **TC-FAKE-002**: View fake call history
  - Navigate to Fake Call screen
  - Scroll to history section
  - Verify past fake calls are displayed
  - Verify call details (time, duration)

- [ ] **TC-FAKE-003**: End fake call
  - Start fake call
  - Click "End Call" button
  - Verify call is ended
  - Verify call duration is recorded

---

## ⚖️ 4. LEGAL AID MODULE

### 4.1 Legal Home
- [ ] **TC-LEGAL-001**: View legal categories
  - Navigate to Legal tab
  - Verify all legal categories are displayed
  - Verify categories: Constitution, Family Law, Property Law, Labor Law, etc.

- [ ] **TC-LEGAL-002**: Navigate to legal article
  - Click on a legal category
  - Verify navigation to legal detail screen
  - Verify articles are displayed

### 4.2 Legal Articles
- [ ] **TC-ART-001**: View legal article content
  - Navigate to legal article
  - Verify article content is displayed
  - Verify text is readable

- [ ] **TC-ART-002**: Use Text-to-Speech (English)
  - Open article
  - Click TTS button
  - Select English language
  - Verify audio plays correctly
  - Verify text is read aloud

- [ ] **TC-ART-003**: Use Text-to-Speech (Urdu)
  - Open article
  - Click TTS button
  - Select Urdu language
  - Verify audio plays correctly
  - Verify Urdu text is read (or fallback to English)

- [ ] **TC-ART-004**: Use Text-to-Speech (Punjabi)
  - Open article
  - Click TTS button
  - Select Punjabi language
  - Verify audio plays correctly
  - Verify Punjabi text is read (or fallback)

- [ ] **TC-ART-005**: Stop Text-to-Speech
  - Start TTS
  - Click stop button
  - Verify audio stops

- [ ] **TC-ART-006**: Share article
  - Click share button
  - Verify share dialog appears
  - Verify article can be shared

### 4.3 AI Legal Assistant
- [ ] **TC-AI-001**: Send message to AI assistant
  - Navigate to AI Assistant screen
  - Type a legal question
  - Send message
  - Verify message appears in chat
  - Verify response is received

- [ ] **TC-AI-002**: Ask about Pakistan Constitution
  - Ask: "What are my constitutional rights?"
  - Verify response contains relevant constitutional information
  - Verify response is not generic "cannot find" message

- [ ] **TC-AI-003**: Ask about Family Law
  - Ask: "What are my rights in divorce?"
  - Verify response contains family law information
  - Verify response is accurate

- [ ] **TC-AI-004**: Ask about Property Law
  - Ask: "What are property inheritance rights?"
  - Verify response contains property law information

- [ ] **TC-AI-005**: Ask about Labor Law
  - Ask: "What are workplace rights for women?"
  - Verify response contains labor law information

- [ ] **TC-AI-006**: View chat history
  - Send multiple messages
  - Close and reopen AI Assistant
  - Verify chat history is loaded from Firestore
  - Verify all previous messages are displayed

- [ ] **TC-AI-007**: Clear chat history
  - Click clear history button
  - Confirm deletion
  - Verify chat history is cleared from Firestore
  - Verify chat screen is empty

- [ ] **TC-AI-008**: Typing indicator
  - Send message
  - Verify typing indicator appears while waiting
  - Verify indicator disappears when response arrives

- [ ] **TC-AI-009**: Error handling
  - Turn off internet
  - Send message
  - Verify error message appears
  - Verify user-friendly error is shown

### 4.4 Voice Assistant
- [ ] **TC-VOICE-001**: Start voice input (English)
  - Navigate to Voice Assistant screen
  - Select English language
  - Click microphone button
  - Grant microphone permission
  - Speak a legal question
  - Verify speech is transcribed
  - Verify transcription is sent to chatbot

- [ ] **TC-VOICE-002**: Start voice input (Urdu)
  - Select Urdu language
  - Click microphone button
  - Speak in Urdu
  - Verify speech is transcribed correctly
  - Verify response is received

- [ ] **TC-VOICE-003**: Start voice input (Punjabi)
  - Select Punjabi language
  - Click microphone button
  - Speak in Punjabi
  - Verify speech is transcribed correctly

- [ ] **TC-VOICE-004**: Stop voice input
  - Start voice input
  - Click stop button
  - Verify recording stops
  - Verify transcription is processed

- [ ] **TC-VOICE-005**: Microphone permission denied
  - Deny microphone permission
  - Try to start voice input
  - Verify error message appears
  - Verify permission request dialog appears

### 4.5 Document Vault
- [ ] **TC-DOC-001**: Upload document
  - Navigate to Document Vault
  - Click "Upload Document" button
  - Select document from device
  - Enter document name and type
  - Save document
  - Verify document is uploaded to Firebase Storage
  - Verify document metadata is saved to Firestore
  - Verify document appears in list

- [ ] **TC-DOC-002**: View document list
  - Navigate to Document Vault
  - Verify all uploaded documents are displayed
  - Verify document details (name, type, date)

- [ ] **TC-DOC-003**: Open document
  - Click on document in list
  - Verify document opens
  - Verify document can be viewed

- [ ] **TC-DOC-004**: Delete document
  - Click delete button on document
  - Confirm deletion
  - Verify document is deleted from Firebase Storage
  - Verify document metadata is removed from Firestore
  - Verify document disappears from list

- [ ] **TC-DOC-005**: Search documents
  - Enter search query
  - Verify filtered results appear
  - Verify search works correctly

### 4.6 Helpline & Support Contacts
- [ ] **TC-HELP-001**: View helpline numbers
  - Navigate to Helpline screen
  - Verify helpline numbers are displayed
  - Verify numbers are clickable

- [ ] **TC-HELP-002**: Call helpline
  - Click on helpline number
  - Verify phone dialer opens
  - Verify correct number is dialed

- [ ] **TC-HELP-003**: View support contacts
  - Navigate to Support Contacts screen
  - Verify support contacts are displayed
  - Verify contact details are shown

- [ ] **TC-HELP-004**: Contact support
  - Click on support contact
  - Verify contact method works (call/email)

---

## 📚 5. GROWTH/EDUCATION MODULE

### 5.1 Courses Home
- [ ] **TC-GROW-001**: View courses list
  - Navigate to Growth tab
  - Verify all courses are displayed
  - Verify course cards show title, description, image

- [ ] **TC-GROW-002**: Search courses
  - Enter search query
  - Verify filtered courses appear
  - Verify search works correctly

- [ ] **TC-GROW-003**: Filter courses by category
  - Select category filter
  - Verify filtered courses appear
  - Verify filter works correctly

### 5.2 Course Details
- [ ] **TC-COURSE-001**: View course details
  - Click on a course
  - Verify course details screen opens
  - Verify course content is displayed

- [ ] **TC-COURSE-002**: Start course
  - Open course details
  - Click "Start Course" button
  - Verify course progress is created in Firestore
  - Verify course content is accessible

- [ ] **TC-COURSE-003**: Continue course
  - Open course that was started
  - Verify "Continue" button appears
  - Click continue
  - Verify course resumes from last position

- [ ] **TC-COURSE-004**: Bookmark course
  - Click bookmark icon
  - Verify course is bookmarked in Firestore
  - Verify bookmark icon changes state

- [ ] **TC-COURSE-005**: Unbookmark course
  - Click bookmark icon on bookmarked course
  - Verify course is unbookmarked
  - Verify bookmark icon changes state

- [ ] **TC-COURSE-006**: View course progress
  - Open course
  - Verify progress percentage is displayed
  - Verify progress is accurate

### 5.3 Quiz
- [ ] **TC-QUIZ-001**: Start quiz
  - Open course with quiz
  - Click "Take Quiz" button
  - Verify quiz screen opens
  - Verify questions are displayed

- [ ] **TC-QUIZ-002**: Answer quiz questions
  - Select answers for all questions
  - Click submit
  - Verify quiz is submitted
  - Verify results are calculated

- [ ] **TC-QUIZ-003**: View quiz results
  - Complete quiz
  - Verify results screen appears
  - Verify score is displayed
  - Verify correct/incorrect answers are shown

- [ ] **TC-QUIZ-004**: Save quiz results
  - Complete quiz
  - Verify results are saved to Firestore
  - Verify results appear in progress

- [ ] **TC-QUIZ-005**: Retake quiz
  - Click "Retake Quiz" button
  - Verify quiz restarts
  - Verify previous answers are cleared

### 5.4 My Progress
- [ ] **TC-PROG-001**: View course progress
  - Navigate to My Progress screen
  - Verify all courses with progress are displayed
  - Verify progress percentages are shown

- [ ] **TC-PROG-002**: View quiz results
  - Navigate to My Progress
  - Verify quiz results are displayed
  - Verify scores are shown correctly

### 5.5 Certificates
- [ ] **TC-CERT-001**: View certificates
  - Navigate to Certificates screen
  - Verify all earned certificates are displayed
  - Verify certificate details (course name, date)

- [ ] **TC-CERT-002**: Generate certificate
  - Complete a course
  - Verify certificate is generated
  - Verify certificate is saved to Firestore

- [ ] **TC-CERT-003**: Download certificate
  - Click on certificate
  - Click download button
  - Verify certificate is downloaded
  - Verify certificate can be opened

- [ ] **TC-CERT-004**: Share certificate
  - Click share button on certificate
  - Verify share dialog appears
  - Verify certificate can be shared

### 5.6 Bookmarked Courses
- [ ] **TC-BOOK-001**: View bookmarked courses
  - Navigate to Bookmarked Courses screen
  - Verify all bookmarked courses are displayed
  - Verify courses are correct

- [ ] **TC-BOOK-002**: Remove bookmark from list
  - Click unbookmark button
  - Verify course is removed from bookmarked list
  - Verify course is unbookmarked in Firestore

---

## 🏥 6. WELLNESS HUB MODULE

### 6.1 Wellness Dashboard
- [ ] **TC-WELL-001**: View wellness dashboard
  - Navigate to Wellness tab
  - Verify all wellness features are displayed
  - Verify cards for Cycle Tracker, Family Planning, Maternity, etc.

### 6.2 Cycle Tracker
- [ ] **TC-CYCLE-001**: Log period
  - Navigate to Cycle Tracker
  - Click "Log Period" button
  - Enter period details
  - Save log
  - Verify log is saved to Firestore
  - Verify log appears in calendar

- [ ] **TC-CYCLE-002**: View cycle calendar
  - Navigate to Cycle Tracker
  - Verify calendar is displayed
  - Verify period days are marked
  - Verify cycle phases are shown

- [ ] **TC-CYCLE-003**: View cycle predictions
  - Verify predicted period dates are shown
  - Verify ovulation dates are shown
  - Verify predictions are accurate

- [ ] **TC-CYCLE-004**: View cycle statistics
  - Verify cycle length is displayed
  - Verify average cycle length is shown
  - Verify statistics are accurate

### 6.3 Family Planning
- [ ] **TC-FP-001**: Take family planning quiz
  - Navigate to Family Planning
  - Start quiz
  - Answer all questions
  - Submit quiz
  - Verify results are calculated

- [ ] **TC-FP-002**: View contraception recommendations
  - Complete quiz
  - Verify recommendations are displayed
  - Verify recommendations match user answers
  - Verify recommendations are ranked

- [ ] **TC-FP-003**: View contraception details
  - Click on recommended method
  - Verify details are displayed
  - Verify information is accurate

### 6.4 Maternity Wing
- [ ] **TC-MAT-001**: Create pregnancy profile
  - Navigate to Maternity Wing
  - Enter due date
  - Save profile
  - Verify profile is saved to Firestore

- [ ] **TC-MAT-002**: View pregnancy week
  - Create pregnancy profile
  - Verify current week is displayed
  - Verify week calculation is accurate

- [ ] **TC-MAT-003**: View baby size reference
  - Verify baby size comparison is shown
  - Verify fruit comparison is displayed
  - Verify size matches current week

- [ ] **TC-MAT-004**: Log appointment
  - Add appointment
  - Enter appointment details
  - Save appointment
  - Verify appointment is saved to Firestore

- [ ] **TC-MAT-005**: View appointments
  - Verify all appointments are displayed
  - Verify appointment details are shown
  - Verify appointments are sorted by date

- [ ] **TC-MAT-006**: PPD Assessment
  - Take PPD assessment
  - Answer all questions
  - Submit assessment
  - Verify score is calculated
  - Verify recommendations are shown

### 6.5 Mental Health
- [ ] **TC-MENT-001**: View mental health resources
  - Navigate to Mental Health screen
  - Verify resources are displayed
  - Verify content is accessible

- [ ] **TC-MENT-002**: Use vent box
  - Click on vent box feature
  - Enter thoughts/feelings
  - Save entry
  - Verify entry is saved

---

## 🛒 7. MARKETPLACE MODULE

### 7.1 Marketplace Home
- [ ] **TC-MARK-001**: View marketplace
  - Navigate to Marketplace tab
  - Verify products are displayed
  - Verify product cards show image, title, price

- [ ] **TC-MARK-002**: Search products
  - Enter search query
  - Verify filtered products appear
  - Verify search works correctly

- [ ] **TC-MARK-003**: Filter products
  - Select category filter
  - Verify filtered products appear
  - Verify filter works correctly

- [ ] **TC-MARK-004**: View product details
  - Click on product
  - Verify product details screen opens
  - Verify all product information is displayed

### 7.2 Create Listing
- [ ] **TC-LIST-001**: Create product listing
  - Navigate to Create Listing
  - Enter product details (title, description, price)
  - Upload product images
  - Select category
  - Save listing
  - Verify product is saved to Firestore
  - Verify product appears in marketplace

- [ ] **TC-LIST-002**: Upload product images
  - Click upload image button
  - Select images from gallery
  - Verify images are uploaded to Firebase Storage
  - Verify images appear in preview

- [ ] **TC-LIST-003**: Edit listing
  - Open existing listing
  - Edit product details
  - Save changes
  - Verify changes are saved to Firestore
  - Verify updated details appear

- [ ] **TC-LIST-004**: Delete listing
  - Click delete button
  - Confirm deletion
  - Verify product is removed from Firestore
  - Verify product disappears from marketplace

---

## 👥 8. COMMUNITY MODULE

### 8.1 Forum Home
- [ ] **TC-COMM-001**: View forum posts
  - Navigate to Community
  - Verify all posts are displayed
  - Verify post details (title, author, date)

- [ ] **TC-COMM-002**: Search posts
  - Enter search query
  - Verify filtered posts appear
  - Verify search works correctly

### 8.2 Create Post
- [ ] **TC-POST-001**: Create new post
  - Click "Create Post" button
  - Enter post title and content
  - Select category
  - Publish post
  - Verify post is saved to Firestore
  - Verify post appears in forum

- [ ] **TC-POST-002**: Upload images to post
  - Add images to post
  - Verify images are uploaded
  - Verify images appear in post

### 8.3 Post Details
- [ ] **TC-POSTD-001**: View post details
  - Click on post
  - Verify post details screen opens
  - Verify full post content is displayed

- [ ] **TC-POSTD-002**: Comment on post
  - Open post
  - Add comment
  - Submit comment
  - Verify comment is saved to Firestore
  - Verify comment appears in post

- [ ] **TC-POSTD-003**: Like post
  - Click like button
  - Verify like is saved to Firestore
  - Verify like count increases

---

## 💬 9. CHAT MODULE

### 9.1 Chat List
- [ ] **TC-CHAT-001**: View chat list
  - Navigate to Chat
  - Verify all chats are displayed
  - Verify chat details (name, last message, time)

- [ ] **TC-CHAT-002**: Start new chat
  - Click "New Chat" button
  - Select user
  - Start chat
  - Verify chat is created
  - Verify navigation to chat screen

### 9.2 Chat Screen
- [ ] **TC-CHAT-003**: Send text message
  - Open chat
  - Type message
  - Send message
  - Verify message is saved to Firestore
  - Verify message appears in chat

- [ ] **TC-CHAT-004**: Receive message
  - Wait for incoming message
  - Verify message appears in chat
  - Verify message is displayed correctly

- [ ] **TC-CHAT-005**: Send image
  - Click attach image button
  - Select image
  - Send image
  - Verify image is uploaded
  - Verify image appears in chat

---

## 🏠 10. HOME/DASHBOARD MODULE

### 10.1 Home Screen
- [ ] **TC-HOME-001**: View home dashboard
  - Navigate to Home tab
  - Verify dashboard is displayed
  - Verify all sections are visible

- [ ] **TC-HOME-002**: View Today's Highlights
  - Verify highlights section is displayed
  - Verify highlights are dynamic (from different modules)
  - Verify highlights are clickable

- [ ] **TC-HOME-003**: Search functionality
  - Enter search query
  - Verify search works
  - Verify navigation to relevant module

- [ ] **TC-HOME-004**: View notifications
  - Click notification icon
  - Verify notifications screen opens
  - Verify notifications are displayed

- [ ] **TC-HOME-005**: Navigate to modules
  - Click on module cards
  - Verify navigation to respective modules
  - Verify navigation works correctly

### 10.2 Notifications
- [ ] **TC-NOTIF-001**: View notifications
  - Navigate to Notifications
  - Verify all notifications are displayed
  - Verify notification details are shown

- [ ] **TC-NOTIF-002**: Mark notification as read
  - Click on notification
  - Verify notification is marked as read
  - Verify read status is saved to Firestore

- [ ] **TC-NOTIF-003**: Delete notification
  - Swipe or click delete
  - Verify notification is deleted
  - Verify notification is removed from Firestore

- [ ] **TC-NOTIF-004**: Notification settings respect
  - Disable notifications in settings
  - Verify no new notifications are created
  - Enable notifications
  - Verify notifications work again

---

## 🔍 11. SEARCH FUNCTIONALITY

- [ ] **TC-SEARCH-001**: Global search
  - Enter search query in home search bar
  - Verify search results appear
  - Verify results are relevant

- [ ] **TC-SEARCH-002**: Search history
  - Perform multiple searches
  - Verify search history is saved
  - Verify history can be viewed

- [ ] **TC-SEARCH-003**: Search navigation
  - Search for "safety"
  - Verify navigation to Safety module
  - Verify search works for all modules

---

## 📱 12. NAVIGATION & UI

- [ ] **TC-NAV-001**: Bottom navigation
  - Click on each tab
  - Verify navigation works
  - Verify correct screen is displayed

- [ ] **TC-NAV-002**: Side drawer
  - Open side drawer
  - Verify drawer options are displayed
  - Verify navigation from drawer works

- [ ] **TC-NAV-003**: Back button
  - Navigate to detail screen
  - Click back button
  - Verify navigation back works

- [ ] **TC-NAV-004**: Responsive design
  - Test on different screen sizes
  - Verify UI adapts correctly
  - Verify no layout issues

---

## 🔐 13. SECURITY & PERMISSIONS

- [ ] **TC-PERM-001**: Location permission
  - Request location permission
  - Grant permission
  - Verify permission is granted
  - Deny permission
  - Verify appropriate error message

- [ ] **TC-PERM-002**: Camera permission
  - Request camera permission
  - Grant/deny permission
  - Verify appropriate handling

- [ ] **TC-PERM-003**: Microphone permission
  - Request microphone permission
  - Grant/deny permission
  - Verify appropriate handling

- [ ] **TC-PERM-004**: Storage permission
  - Request storage permission
  - Grant/deny permission
  - Verify appropriate handling

---

## 🌐 14. NETWORK & OFFLINE

- [ ] **TC-NET-001**: Network error handling
  - Turn off internet
  - Try to perform actions
  - Verify error messages appear
  - Verify user-friendly messages

- [ ] **TC-NET-002**: Network recovery
  - Turn off internet
  - Perform action (should fail)
  - Turn on internet
  - Retry action
  - Verify action succeeds

- [ ] **TC-NET-003**: Offline data display
  - Load data while online
  - Turn off internet
  - Verify cached data is displayed
  - Verify appropriate offline message

---

## 📊 15. DATA PERSISTENCE

- [ ] **TC-DATA-001**: Data persistence
  - Create/update data
  - Close app
  - Reopen app
  - Verify data is still present
  - Verify data is loaded from Firestore

- [ ] **TC-DATA-002**: Real-time updates
  - Open screen with real-time data
  - Update data from another device
  - Verify changes appear automatically
  - Verify real-time sync works

---

## 🎨 16. UI/UX TESTING

- [ ] **TC-UI-001**: Loading states
  - Perform actions that require loading
  - Verify loading indicators appear
  - Verify UI is responsive

- [ ] **TC-UI-002**: Error messages
  - Trigger errors
  - Verify error messages are user-friendly
  - Verify error messages are clear

- [ ] **TC-UI-003**: Success messages
  - Perform successful actions
  - Verify success messages appear
  - Verify messages are appropriate

- [ ] **TC-UI-004**: Empty states
  - Navigate to empty lists
  - Verify empty state messages appear
  - Verify empty states are helpful

---

## 📝 TESTING NOTES

### Priority Levels:
- **P0 (Critical)**: Authentication, Profile, Safety (SOS, Trusted Contacts)
- **P1 (High)**: Legal Aid (AI Assistant, Articles), Growth (Courses), Wellness (Cycle Tracker)
- **P2 (Medium)**: Marketplace, Community, Chat
- **P3 (Low)**: Advanced features, Nice-to-have features

### Test Environment:
- Test on both Android and iOS (if applicable)
- Test on different screen sizes
- Test with good and poor network conditions
- Test with various permission scenarios

### Expected Results:
- All P0 tests should pass
- At least 80% of P1 tests should pass
- Critical bugs should be fixed immediately
- Non-critical bugs can be logged for future fixes

---

## ✅ Test Completion Checklist

After testing, mark completed tests and note any issues:

- [ ] All Authentication tests completed
- [ ] All Profile & Settings tests completed
- [ ] All Safety module tests completed
- [ ] All Legal Aid tests completed
- [ ] All Growth/Education tests completed
- [ ] All Wellness Hub tests completed
- [ ] All Marketplace tests completed
- [ ] All Community tests completed
- [ ] All Chat tests completed
- [ ] All Home/Dashboard tests completed
- [ ] All Navigation tests completed
- [ ] All Permission tests completed
- [ ] All Network tests completed

---

**Total Test Cases: 200+**

**Last Updated**: [Current Date]
**Tested By**: [Your Name]
**App Version**: [Current Version]

