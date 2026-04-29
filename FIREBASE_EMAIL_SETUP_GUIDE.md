# 🔧 Firebase Email Setup Guide - Password Reset

## ⚠️ Problem: Emails Not Being Sent

If password reset emails are not being sent, follow these steps to configure Firebase Auth email sending.

---

## 📋 Step-by-Step Setup

### 1. **Check Firebase Console - Authentication Settings**

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **umeed-e--zann**
3. Navigate to **Authentication** → **Settings** → **Users** tab
4. Check if **Email/Password** provider is enabled

### 2. **Configure Authorized Domains**

1. Go to **Authentication** → **Settings** → **Authorized domains**
2. Make sure these domains are authorized:
   - `localhost` (for development)
   - Your app's domain (if deployed)
   - `firebaseapp.com` (default)

### 3. **Configure Email Templates**

1. Go to **Authentication** → **Templates**
2. Click on **Password reset** template
3. Configure:
   - **Subject**: Customize the email subject
   - **Body**: Customize the email body
   - **Action URL**: Leave default or set custom URL

### 4. **Check Email Action Handler**

The password reset email needs a handler URL. By default, Firebase uses:
- `https://[PROJECT_ID].firebaseapp.com/__/auth/action`

**To set a custom handler:**
1. Go to **Authentication** → **Settings** → **Action URL**
2. Set your custom domain (if you have one)
3. Or use the default Firebase URL

### 5. **Verify Email Sending is Enabled**

1. Go to **Authentication** → **Settings** → **Email templates**
2. Ensure **Password reset** is enabled
3. Check that email sending is not blocked

---

## 🔍 Troubleshooting

### Issue 1: Email Goes to Spam
- **Solution**: Check spam/junk folder
- Ask users to mark Firebase emails as "Not Spam"
- Consider using a custom email domain (requires Firebase Blaze plan)

### Issue 2: "User Not Found" Error
- **Solution**: Make sure the email exists in Firebase Auth
- Check if user was created via signup
- Verify email in Firebase Console → Authentication → Users

### Issue 3: "Too Many Requests" Error
- **Solution**: Firebase limits password reset emails
- Wait 1 hour before trying again
- Consider implementing rate limiting in your app

### Issue 4: Email Not Received at All
- **Check Firebase Console** → **Authentication** → **Users** → Check if email is verified
- **Check Email Templates** are configured
- **Check Authorized Domains** are set correctly
- **Check Firebase Project** billing status (free tier has limits)

---

## 🧪 Testing Password Reset

### Test Steps:
1. Use a **real email address** (not a test email)
2. Make sure the email is **registered** in your app
3. Request password reset
4. Check **inbox AND spam folder**
5. Check Firebase Console → **Authentication** → **Users** → See if email is verified

### Check Logs:
1. Go to Firebase Console → **Firestore Database**
2. Check `password_reset_requests` collection
3. Look for entries with `status: "email_sent"` or `status: "failed"`
4. Check the `error` field if status is "failed"

---

## 📧 Email Template Customization

### Default Firebase Email Template:
```
Subject: Reset your password

Body:
Click the link below to reset your password:
[RESET_LINK]

If you didn't request this, ignore this email.
```

### Customize in Firebase Console:
1. **Authentication** → **Templates** → **Password reset**
2. Edit subject and body
3. Use variables:
   - `%LINK%` - Password reset link
   - `%EMAIL%` - User's email
   - `%DISPLAY_NAME%` - User's display name

---

## 🔐 Security Notes

1. **Firebase Auth** handles email sending securely
2. Reset links expire after **1 hour** (default)
3. Each link can only be used **once**
4. Links are cryptographically signed by Firebase

---

## ✅ Verification Checklist

- [ ] Email/Password provider is enabled
- [ ] Authorized domains are configured
- [ ] Email templates are set up
- [ ] Action URL is configured
- [ ] Test email is received (check spam)
- [ ] Firestore `password_reset_requests` collection shows entries
- [ ] No errors in Firebase Console logs

---

## 🆘 Still Not Working?

1. **Check Firebase Console** → **Authentication** → **Users** → Verify user exists
2. **Check Firestore** → `password_reset_requests` → See error details
3. **Check App Logs** → Look for FirebaseAuthException errors
4. **Try Different Email** → Some email providers block Firebase emails
5. **Check Firebase Project Status** → Ensure project is active and not suspended

---

## 📝 Code Implementation

The app already implements:
- ✅ Email validation
- ✅ Error handling
- ✅ Firestore logging
- ✅ User-friendly error messages

**Current Implementation:**
```dart
await _auth.sendPasswordResetEmail(email: email);
```

This calls Firebase Auth which handles email sending. If emails aren't sent, it's a **Firebase Console configuration issue**, not a code issue.

---

## 🔗 Useful Links

- [Firebase Auth Email Templates](https://firebase.google.com/docs/auth/custom-email-handler)
- [Firebase Auth Settings](https://console.firebase.google.com/project/_/authentication/settings)
- [Firebase Support](https://firebase.google.com/support)

---

**Last Updated:** Based on current Firebase Auth implementation
