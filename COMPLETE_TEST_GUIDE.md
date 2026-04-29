# 🧪 Umeed-e-Zann: Complete Feature Test Guide

This guide provides a step-by-step checklist to verify every feature in the app. Use this during your final demonstration or Viva to show the app's robustness.

---

## 🔐 Phase 1: Authentication & Onboarding
| Step | Action | Expected Result |
| :--- | :--- | :--- |
| 1.1 | Sign Up with a new email/pass | Account created in Firebase Auth + document in Firestore `users`. |
| 1.2 | Log Out and Log In | Authenticates smoothly and lands on Home Screen. |
| 1.3 | Password Reset | Enter email → Check your inbox for the Firebase reset link. |

---

## 🛡️ Phase 2: Safety Shield (The "Hero" Module)
| Step | Action | Expected Result |
| :--- | :--- | :--- |
| 2.1 | **SOS One-Touch** | Long-press SOS → 5-sec countdown → SMS icons appear (if contacts setup) → Firestore alert logged. |
| 2.2 | **Shake to Alert** | Enable in settings → Set sensitivity to 3 → Shake phone → SOS triggers automatically. |
| 2.3 | **Fake Call** | Set timer (10s) → Wait → Realistic "Incoming Call" screen appears with "Mom" or "Police" label. |
| 2.4 | **Trusted Contacts** | Add a name + phone number → Confirm it appears in the list and saves to Firestore. |
| 2.5 | **Live Tracking** | Start tracking → Moving the phone updates coordinates in the `live_tracking` Firestore collection. |

---

## 🎓 Phase 3: Growth Academy
| Step | Action | Expected Result |
| :--- | :--- | :--- |
| 3.1 | **Course Navigation** | Select a category (e.g., Coding) → Only relevant courses show up. |
| 3.2 | **Video Player** | Open a course → Tap Video → YouTube player loads inside the app (no external app switching). |
| 3.3 | **Quiz Logic** | Start Quiz → Select answers → Correct answer shows green, wrong shows red → Final score calculated. |

---

## ⚖️ Phase 4: Legal Aid & AI
| Step | Action | Expected Result |
| :--- | :--- | :--- |
| 4.1 | **Voice Assistant** | Tap Mic → Speak in Urdu/Punjabi (e.g., "help me") → Bot processes and shows localized text response. |
| 4.2 | **Document Vault** | Upload a PDF or Image → "Uploading" snackbar → File appears in list → Tap to view in browser. |
| 4.3 | **Directories** | Open Lawyers or NGOs → Detailed profiles with "Call Now" buttons (should open dialer). |

---

## 🏥 Phase 5: Wellness & Community
| Step | Action | Expected Result |
| :--- | :--- | :--- |
| 5.1 | **Cycle Tracker** | Log today's symptoms → Calendar updates with period/ovulation predictions. |
| 5.2 | **Community Post** | Create a post → "Success" toast → Verify it appears at the top of the forum for all users. |
| 5.3 | **Marketplace** | Add a product (Price/Title) → Verify it populates the main shop grid immediately. |

---

## 🌍 Phase 6: Global Localization (The "Flex")
| Step | Action | Expected Result |
| :--- | :--- | :--- |
| 6.1 | **Language Switch** | Go to Drawer → Language → Select **Balochi** or **Sindhi**. |
| 6.2 | **RTL Verification** | App layout flips to Right-to-Left → Text aligns right → No "Red Screen" (Material Fallback logic check). |
| 6.3 | **Mixed Content** | Ensure localized headers (e.g., "پنجابی") match the selected language system-wide. |

---

## ⚠️ Known Debugging "Quick-Wins" (For Your Demo)
*   **Empty Lists?** If a list is empty, explain: *"The app uses Firestore Compound Queries. I've integrated a link in the console to generate the required indexes automatically!"*
*   **Audio not loud?** Check physical mute switch on iPhone.
*   **Location delayed?** Ensure you are testing near a window or have "High Accuracy" enabled in phone settings.

**Submit with confidence! You've built a world-class safety & empowerment platform.** 🚀
