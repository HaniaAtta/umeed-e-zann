# 🧪 Quick Test Reference Guide

## ✅ Already Tested
- ✅ Sign Up
- ✅ Forgot Password

---

## 🎯 Priority Testing Order

### 🔴 CRITICAL (Test First)
1. **Login** (TC-AUTH-001 to TC-AUTH-009)
2. **Profile Image Upload** (TC-PROF-006)
3. **SOS Alert** (TC-SOS-001 to TC-SOS-004)
4. **Trusted Contacts** (TC-CONT-001 to TC-CONT-006)
5. **Settings - Notifications** (TC-SETT-002, TC-SETT-003)

### 🟠 HIGH PRIORITY (Test Next)
6. **AI Legal Assistant** (TC-AI-001 to TC-AI-009)
7. **Voice Assistant** (TC-VOICE-001 to TC-VOICE-005)
8. **Document Vault Upload** (TC-DOC-001)
9. **Course Progress & Bookmarks** (TC-COURSE-001 to TC-COURSE-006)
10. **Cycle Tracker** (TC-CYCLE-001 to TC-CYCLE-004)

### 🟡 MEDIUM PRIORITY
11. **Marketplace - Create Listing** (TC-LIST-001)
12. **Community - Create Post** (TC-POST-001)
13. **Quiz Functionality** (TC-QUIZ-001 to TC-QUIZ-005)
14. **Live Tracking** (TC-TRACK-001 to TC-TRACK-004)

### 🟢 LOW PRIORITY
15. **Fake Call** (TC-FAKE-001 to TC-FAKE-003)
16. **Chat** (TC-CHAT-001 to TC-CHAT-005)
17. **Certificates** (TC-CERT-001 to TC-CERT-004)

---

## 🔍 Quick Test Scenarios

### Test Login (5 minutes)
1. Open app → Login screen
2. Enter valid credentials → Should login successfully
3. Enter wrong password → Should show error
4. Turn off internet → Should show network error with WiFi icon
5. Click "Sign Up" link → Should navigate to signup

### Test Profile Image (3 minutes)
1. Go to Profile tab
2. Click on profile image
3. Select image from gallery
4. Verify image appears
5. Close and reopen app → Verify image persists

### Test SOS Alert (5 minutes)
1. Go to Safety tab → SOS screen
2. Grant location permission
3. Click "Send SOS Alert"
4. Verify alert is created
5. Check Firestore → Verify alert document exists

### Test Trusted Contacts (5 minutes)
1. Go to Safety → Trusted Contacts
2. Add new contact (name, phone, relation)
3. Verify contact appears in list
4. Delete contact
5. Verify contact is removed

### Test AI Legal Assistant (5 minutes)
1. Go to Legal tab → AI Assistant
2. Ask: "What are my constitutional rights?"
3. Verify response contains legal information
4. Ask: "What are divorce rights?"
5. Verify response is not generic "cannot find"

### Test Voice Assistant (5 minutes)
1. Go to Legal → Voice Assistant
2. Select Urdu language
3. Click microphone → Grant permission
4. Speak legal question in Urdu
5. Verify transcription and response

### Test Document Upload (3 minutes)
1. Go to Legal → Document Vault
2. Click "Upload Document"
3. Select document
4. Enter name and type
5. Verify document appears in list

### Test Course Bookmark (3 minutes)
1. Go to Growth tab
2. Open any course
3. Click bookmark icon
4. Go to Bookmarked Courses
5. Verify course appears

### Test Settings Notifications (3 minutes)
1. Go to Profile → Settings
2. Toggle notifications OFF
3. Verify setting is saved
4. Go back → Toggle ON
5. Verify setting is saved

### Test Today's Highlights (2 minutes)
1. Go to Home tab
2. Scroll to "Today's Highlights"
3. Verify highlights are displayed
4. Click on highlight
5. Verify navigation works

---

## 🐛 Common Issues to Check

### Network Errors
- [ ] Turn off internet → Try login → Should show network error
- [ ] Turn off internet → Try upload → Should show network error
- [ ] Turn off internet → Try AI assistant → Should show network error

### Permission Errors
- [ ] Deny location → Try SOS → Should show permission error
- [ ] Deny microphone → Try voice assistant → Should show permission error
- [ ] Deny storage → Try upload → Should show permission error

### Data Persistence
- [ ] Upload profile image → Close app → Reopen → Image should persist
- [ ] Add trusted contact → Close app → Reopen → Contact should persist
- [ ] Bookmark course → Close app → Reopen → Bookmark should persist

### Real-time Updates
- [ ] Open AI Assistant chat → Send message from another device → Should appear
- [ ] View notifications → Create notification from another device → Should appear

---

## 📊 Test Results Template

```
Module: [Module Name]
Date: [Date]
Tester: [Your Name]

✅ Passed: [Count]
❌ Failed: [Count]
⚠️  Issues: [Count]

Issues Found:
1. [Issue description]
2. [Issue description]

Notes:
[Any additional notes]
```

---

## 🎯 Focus Areas for This Session

Based on your app's current state, focus on:

1. **Authentication** ✅ (Already tested)
2. **Profile & Settings** - Test image upload and notification settings
3. **Safety Module** - Test SOS and Trusted Contacts (most critical)
4. **Legal AI Assistant** - Test chatbot responses
5. **Document Vault** - Test document upload
6. **Home Highlights** - Test dynamic highlights

---

## 💡 Testing Tips

1. **Test with real data**: Use actual email, phone numbers, etc.
2. **Test edge cases**: Empty fields, invalid inputs, network errors
3. **Test permissions**: Grant/deny permissions to see error handling
4. **Test offline**: Turn off internet to test error messages
5. **Test persistence**: Close and reopen app to verify data saves
6. **Test real-time**: Use multiple devices to test real-time features

---

**For detailed test cases, see: `TEST_CASES_COMPREHENSIVE.md`**

