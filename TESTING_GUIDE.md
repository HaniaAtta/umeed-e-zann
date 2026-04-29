# Testing Guide for Umeed-e-Zann App

This guide provides step-by-step instructions to test all the recently fixed features.

## Table of Contents
1. [Bookmark Functionality](#bookmark-functionality)
2. [Course Progress Tracking](#course-progress-tracking)
3. [Certificates](#certificates)
4. [Helpline & Support Contacts](#helpline--support-contacts)
5. [Side Drawer Navigation](#side-drawer-navigation)
6. [Voice Assistant](#voice-assistant)
7. [AI Legal Assistant](#ai-legal-assistant)
8. [Profile Updates](#profile-updates)

---

## Bookmark Functionality

### Test Case 1: Bookmark a Course
**Steps:**
1. Navigate to **Home** → **Growth** module
2. Find any course card
3. Click the bookmark icon (bookmark outline) in the top-right corner of the course card
4. The icon should change to a filled bookmark (colored)

**Expected Result:**
- ✅ Bookmark icon changes from outline to filled
- ✅ Course is saved to Firestore in `bookmarks` collection
- ✅ Bookmark persists after app restart

**How to Verify in Firestore:**
- Go to Firebase Console → Firestore Database
- Navigate to `bookmarks` collection
- Find document with your `userId`
- Verify the course ID is in the `courseIds` array

### Test Case 2: Unbookmark a Course
**Steps:**
1. Navigate to a course that is already bookmarked
2. Click the filled bookmark icon
3. The icon should change back to outline

**Expected Result:**
- ✅ Bookmark icon changes from filled to outline
- ✅ Course is removed from Firestore `bookmarks` collection

### Test Case 3: View Bookmarked Courses
**Steps:**
1. Navigate to **Home** → **Growth** module
2. Click on **"Bookmarked Courses"** or open side drawer → **"My Bookmarks"**
3. View the list of bookmarked courses

**Expected Result:**
- ✅ All bookmarked courses are displayed
- ✅ Courses match what you bookmarked
- ✅ Empty state shown if no bookmarks exist

---

## Course Progress Tracking

### Test Case 1: Watch a Video and Update Progress
**Steps:**
1. Navigate to **Growth** module
2. Select any course
3. Click on a video lesson
4. Watch the video (or skip to end)
5. Complete the video

**Expected Result:**
- ✅ Progress percentage updates immediately
- ✅ Progress bar on course card updates
- ✅ Progress saved to Firestore in `course_progress` collection
- ✅ Progress persists after app restart

**How to Verify:**
- Check the course card - progress bar should show updated percentage
- In course detail screen, completed videos should be marked
- Firestore: `course_progress` collection → document with `courseId` and `userId`
- Verify `overallProgress` field is updated (0.0 to 1.0)

### Test Case 2: Complete Multiple Videos
**Steps:**
1. Open a course with multiple videos
2. Watch video 1 → Progress should update
3. Watch video 2 → Progress should update further
4. Watch video 3 → Progress should continue updating

**Expected Result:**
- ✅ Progress increments with each video watched
- ✅ Overall progress calculated correctly (videos + quizzes)
- ✅ All progress saved to Firebase

### Test Case 3: Complete Quiz and Update Progress
**Steps:**
1. Navigate to a course with quizzes
2. Complete a quiz
3. Check progress update

**Expected Result:**
- ✅ Quiz completion updates overall progress
- ✅ Progress includes both video and quiz completion

---

## Certificates

### Test Case 1: Generate Certificate for Completed Course
**Prerequisites:**
- Complete a course that has `certificateAvailable: 'Yes'`
- Achieve at least 80% overall progress OR 100% completion

**Steps:**
1. Navigate to **Growth** module
2. Click on **"Certificates"** or open side drawer → **"My Certificates"**
3. View available certificates

**Expected Result:**
- ✅ Completed courses with certificates available are shown
- ✅ Certificate can be generated/downloaded
- ✅ Certificate saved to Firestore in `certificates` collection
- ✅ Certificate shows correct completion date

**How to Verify in Firestore:**
- Navigate to `certificates` collection
- Find document with your `userId` and `courseId`
- Verify fields: `courseName`, `issuedAt`, `userId`, `courseId`

### Test Case 2: Certificate Not Available
**Steps:**
1. Complete a course that has `certificateAvailable: 'No'`
2. Navigate to Certificates screen

**Expected Result:**
- ✅ Course does not appear in certificates list
- ✅ Only courses with `certificateAvailable: 'Yes'` show certificates

---

## Helpline & Support Contacts

### Test Case 1: View Helpline Numbers
**Steps:**
1. Navigate to **Legal Aid** module
2. Click on **"Helpline"** or open side drawer → **"Helplines Directory"**
3. View the list of helpline numbers

**Expected Result:**
- ✅ All helpline numbers are displayed
- ✅ Each helpline shows: name, contact number, description, availability
- ✅ Page is not empty

### Test Case 2: Call Helpline
**Steps:**
1. Navigate to Helpline screen
2. Click on any helpline number

**Expected Result:**
- ✅ Phone dialer opens
- ✅ Correct number is pre-filled
- ✅ User can initiate call

### Test Case 3: View Support Contacts
**Steps:**
1. Navigate to **Legal Aid** module
2. Click on **"Support Contacts"**
3. View NGOs and lawyers list

**Expected Result:**
- ✅ Support contacts are displayed
- ✅ Contact details shown (name, phone, email, website)
- ✅ Page is not empty

### Test Case 4: Contact Support
**Steps:**
1. Navigate to Support Contacts screen
2. Click on a phone number
3. Click on an email address
4. Click on a website URL

**Expected Result:**
- ✅ Phone numbers open dialer
- ✅ Email addresses open email app
- ✅ Website URLs open in browser

---

## Side Drawer Navigation

### Test Case 1: Open Side Drawer from Profile
**Steps:**
1. Navigate to **Profile** screen (from bottom nav or side drawer)
2. Click the hamburger menu icon (☰) in the app bar
3. Side drawer should open

**Expected Result:**
- ✅ Side drawer slides in from left
- ✅ All menu items are visible
- ✅ User profile info shown at top

### Test Case 2: Navigate from Side Drawer
**Steps:**
1. Open side drawer from any screen
2. Click on various menu items:
   - My Progress
   - My Bookmarks
   - My Certificates
   - Document Vault
   - Helplines Directory
   - Settings
   - Profile
   - Logout

**Expected Result:**
- ✅ Each menu item navigates to correct screen
- ✅ Drawer closes after navigation
- ✅ No "coming soon" messages appear

### Test Case 3: Helpline from Home Page
**Steps:**
1. Navigate to **Home** screen
2. Click on **"Helpline Directories"** card or use side drawer

**Expected Result:**
- ✅ Navigates directly to Helpline screen
- ✅ No "coming soon" snackbar appears

---

## Voice Assistant

### Test Case 1: Start Voice Recognition
**Steps:**
1. Navigate to **Legal Aid** module
2. Click on **"Voice Assistant"**
3. Select language (Urdu, Punjabi, or English)
4. Click the microphone button to start listening

**Expected Result:**
- ✅ Microphone permission requested (if not granted)
- ✅ Voice recognition starts
- ✅ Visual feedback (pulsing animation) shows listening state
- ✅ Speech is transcribed in real-time

### Test Case 2: Transcribe Speech
**Steps:**
1. Start voice recognition
2. Speak a legal question (e.g., "What are my rights in a divorce?")
3. Wait for transcription to complete

**Expected Result:**
- ✅ Speech is transcribed correctly
- ✅ Transcribed text appears on screen
- ✅ Question is sent to chatbot automatically
- ✅ Response appears below transcription

### Test Case 3: Multi-language Support
**Steps:**
1. Open Voice Assistant
2. Select **Urdu** language
3. Speak in Urdu
4. Select **Punjabi** language
5. Speak in Punjabi
6. Select **English** language
7. Speak in English

**Expected Result:**
- ✅ Each language is recognized correctly
- ✅ Locale changes appropriately
- ✅ Transcription works for all languages

---

## AI Legal Assistant

### Test Case 1: Ask Legal Question
**Steps:**
1. Navigate to **Legal Aid** module
2. Click on **"AI Assistant"**
3. Type a legal question (e.g., "What is Article 25 of the Constitution?")
4. Send the message

**Expected Result:**
- ✅ Question appears in chat
- ✅ Response appears within a few seconds
- ✅ Response is relevant to the question
- ✅ Response does not say "cannot find anything related"

### Test Case 2: Chat History
**Steps:**
1. Ask multiple questions in AI Assistant
2. Close and reopen the AI Assistant screen

**Expected Result:**
- ✅ Previous chat history is loaded
- ✅ All messages are displayed
- ✅ Messages are saved to Firestore

### Test Case 3: Clear Chat History
**Steps:**
1. Open AI Assistant
2. Click on clear/delete chat option
3. Confirm deletion

**Expected Result:**
- ✅ Chat history is cleared
- ✅ Firestore chat messages are deleted
- ✅ Screen shows empty chat state

### Test Case 4: Non-Legal Questions
**Steps:**
1. Ask a non-legal question (e.g., "What's the weather?")
2. Observe the response

**Expected Result:**
- ✅ Response indicates question is not legal-related
- ✅ Response suggests asking legal questions instead
- ✅ No "cannot find" message appears

---

## Profile Updates

### Test Case 1: Update Profile Information
**Steps:**
1. Navigate to **Profile** screen
2. Click edit icon (pencil)
3. Update name, email, phone, or location
4. Click save (checkmark icon)

**Expected Result:**
- ✅ Changes are saved to Firestore
- ✅ Profile updates immediately
- ✅ Changes persist after app restart
- ✅ Success message appears

**How to Verify in Firestore:**
- Navigate to `users` collection
- Find document with your `userId`
- Verify updated fields match what you entered

### Test Case 2: Upload Profile Image
**Steps:**
1. Navigate to **Profile** screen
2. Click edit icon
3. Click on profile picture
4. Select image from gallery
5. Wait for upload to complete

**Expected Result:**
- ✅ Image is uploaded to Firebase Storage
- ✅ Image URL is saved to Firestore
- ✅ Profile picture updates immediately
- ✅ Image persists after app restart

**How to Verify:**
- Firebase Storage: Check `profile_images` folder
- Firestore: Check `users` collection → `profileImageUrl` field

### Test Case 3: Profile Image Display
**Steps:**
1. Upload a profile image
2. Navigate away from profile
3. Return to profile screen

**Expected Result:**
- ✅ Profile image loads from Firebase Storage
- ✅ Image displays correctly
- ✅ Fallback to logo if image fails to load

---

## Additional Testing Notes

### Firestore Collections to Monitor:
1. **bookmarks** - User bookmarked courses
2. **course_progress** - Course completion progress
3. **certificates** - Generated certificates
4. **chat_messages** - AI Assistant chat history
5. **users** - User profile data

### Common Issues to Check:
- ✅ Network connectivity errors are handled gracefully
- ✅ Loading states are shown during async operations
- ✅ Error messages are user-friendly
- ✅ Data persists after app restart
- ✅ No crashes or exceptions in console

### Performance Checks:
- ✅ Screens load within 2-3 seconds
- ✅ Images load efficiently
- ✅ No memory leaks (check with Flutter DevTools)
- ✅ Smooth animations and transitions

---

## Quick Test Checklist

Use this checklist for quick verification:

- [ ] Bookmark a course → Check Firestore
- [ ] View bookmarked courses → Should show in list
- [ ] Watch a video → Progress updates
- [ ] Complete a course → Certificate available
- [ ] Open side drawer from profile → Drawer opens
- [ ] Click helpline from home → Navigates correctly
- [ ] Call helpline number → Dialer opens
- [ ] Use voice assistant → Speech transcribed
- [ ] Ask AI assistant question → Response appears
- [ ] Update profile → Changes saved
- [ ] Upload profile image → Image displays

---

## Troubleshooting

### If bookmark doesn't save:
- Check internet connection
- Verify Firebase connection
- Check Firestore rules allow write access
- Check console for errors

### If progress doesn't update:
- Verify video completion is detected
- Check Firestore `course_progress` collection
- Ensure `overallProgress` calculation is correct

### If certificate doesn't generate:
- Verify course has `certificateAvailable: 'Yes'`
- Check progress is at least 80%
- Verify Firestore `certificates` collection

### If side drawer doesn't open:
- Check if `drawer` property is in Scaffold
- Verify SideDrawer import is correct
- Check for any build errors

---

**Last Updated:** Based on latest fixes for bookmarks, progress, certificates, helpline, and side drawer.

