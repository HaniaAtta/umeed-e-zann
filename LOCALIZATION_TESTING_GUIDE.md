# 🌍 Localization Testing Guide

## ✅ All Languages Configured

Your app supports **6 languages**:
1. **English (en-US)** - English
2. **Urdu (ur-PK)** - اردو
3. **Punjabi (pa-PK)** - ਪੰਜਾਬੀ
4. **Turkish (tr-TR)** - Türkçe
5. **Sindhi (sd-PK)** - سنڌي
6. **Balochi (bal-PK)** - بلوچی

---

## 🎯 How to Test Localization

### Method 1: Using Side Drawer (Easiest)

1. **Open the app** and navigate to any screen
2. **Tap the menu icon** (☰) in the top-left corner to open the side drawer
3. **Scroll down** and find the **"Language"** option (with 🌐 icon)
4. **Tap "Language"** - This opens the Language Selector screen
5. **Select any language** from the list:
   - You'll see all 6 languages with their native names
   - The current language is highlighted with a checkmark
6. **Tap a language** to switch
7. **Watch the app change** - All text should update immediately!

### Method 2: Visual Indicators

When you change the language, you should see:
- ✅ **Home screen text changes** (Welcome, Quick Access, etc.)
- ✅ **Dashboard card titles change** (Safety Shield, Wellness Hub, etc.)
- ✅ **Navigation labels change**
- ✅ **Button text changes** (Save, Cancel, Delete, etc.)
- ✅ **RTL layout for Urdu, Sindhi, and Balochi** (text flows right-to-left)

---

## 📱 What to Test

### 1. Home Screen
- [ ] Welcome message changes
- [ ] "Quick Access" section title changes
- [ ] Dashboard card titles (Safety Shield, Wellness Hub, etc.)
- [ ] Search placeholder text
- [ ] "Today's Highlights" section

### 2. Navigation
- [ ] Side drawer menu items
- [ ] Bottom navigation bar (if visible)
- [ ] Screen titles in app bars

### 3. Common UI Elements
- [ ] Buttons (Save, Cancel, Delete, Edit, Add)
- [ ] Loading messages
- [ ] Error messages
- [ ] Success messages
- [ ] Empty state messages

### 4. RTL Languages (Urdu, Sindhi, Balochi)
- [ ] Text flows from right to left
- [ ] Icons and buttons are on the correct side
- [ ] Layout doesn't break

---

## 🔍 Quick Test Checklist

### Test Each Language:

#### English (en-US)
- Default language
- All text should be in English
- LTR (Left-to-Right) layout

#### Urdu (ur-PK) - اردو
- Text should be in Urdu script
- RTL (Right-to-Left) layout
- Check: "خوش آمدید" appears instead of "Welcome"

#### Punjabi (pa-PK) - ਪੰਜਾਬੀ
- Text should be in Gurmukhi script
- LTR layout
- Check: "ਜੀ ਆਇਆਂ ਨੂੰ" appears instead of "Welcome"

#### Turkish (tr-TR) - Türkçe
- Text should be in Turkish
- LTR layout
- Check: "Hoş Geldiniz" appears instead of "Welcome"

#### Sindhi (sd-PK) - سنڌي
- Text should be in Sindhi script
- RTL layout
- Check: "مرحبا" appears instead of "Welcome"

#### Balochi (bal-PK) - بلوچی
- Text should be in Balochi script
- RTL layout
- Check: "بہ آمد" appears instead of "Welcome"

---

## 🛠️ Technical Details

### How It Works:

1. **LocaleService** (`lib/core/services/locale_service.dart`)
   - Manages current language
   - Persists selection in SharedPreferences
   - Notifies listeners when language changes

2. **ARB Files** (`lib/l10n/`)
   - `app_en.arb` - English translations
   - `app_ur.arb` - Urdu translations
   - `app_pa.arb` - Punjabi translations
   - `app_tr.arb` - Turkish translations
   - `app_sd.arb` - Sindhi translations
   - `app_bal.arb` - Balochi translations

3. **AppLocalizations** (Generated)
   - Auto-generated from ARB files
   - Access via: `AppLocalizations.of(context)?.keyName`

4. **MaterialApp Configuration** (`lib/main.dart`)
   - `supportedLocales` - Lists all supported languages
   - `localizationsDelegates` - Handles localization
   - `locale` - Current locale from LocaleService

---

## 🐛 Troubleshooting

### Issue: Language doesn't change
**Solution:**
1. Make sure you're using `AppLocalizations.of(context)?.keyName` in your widgets
2. Check that `LocaleService` is registered in `MultiProvider`
3. Restart the app after first language change

### Issue: Some text doesn't translate
**Solution:**
1. Check if the string key exists in all ARB files
2. Make sure you're using `AppLocalizations.of(context)?.keyName` instead of hardcoded strings
3. Run `flutter gen-l10n` to regenerate localization files

### Issue: RTL layout looks broken
**Solution:**
1. Flutter automatically handles RTL for Urdu, Sindhi, and Balochi
2. Make sure you're using Flutter's built-in widgets (not custom hardcoded layouts)
3. Test on a real device for best results

### Issue: Language selector not visible
**Solution:**
1. Open side drawer (menu icon ☰)
2. Scroll down to find "Language" option
3. It should be near Settings and Profile options

---

## 📝 Adding New Translations

If you need to add a new translatable string:

1. **Add to `app_en.arb`** (English - template file):
```json
{
  "myNewKey": "My New Text"
}
```

2. **Add to all other ARB files** with translations:
   - `app_ur.arb`: `"myNewKey": "میرا نیا متن"`
   - `app_pa.arb`: `"myNewKey": "ਮੇਰਾ ਨਵਾਂ ਟੈਕਸਟ"`
   - etc.

3. **Run** `flutter gen-l10n` to regenerate

4. **Use in code**:
```dart
AppLocalizations.of(context)?.myNewKey ?? 'My New Text'
```

---

## ✅ Verification Steps

1. ✅ Open app → Side drawer → Language
2. ✅ Select each language one by one
3. ✅ Verify home screen text changes
4. ✅ Verify navigation labels change
5. ✅ Verify RTL works for Urdu/Sindhi/Balochi
6. ✅ Verify app remembers your selection (restart app)
7. ✅ Test on different screens

---

## 🎉 Success Indicators

You'll know localization is working when:
- ✅ Language selector shows all 6 languages
- ✅ Selecting a language immediately updates all text
- ✅ RTL languages (Urdu, Sindhi, Balochi) show right-to-left layout
- ✅ App remembers your language choice after restart
- ✅ No hardcoded English text remains visible

---

**Happy Testing! 🌍**

