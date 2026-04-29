# App Icon Setup Instructions

## 🎯 Where Icon Files Need to Be

### 1. Source Icon File (You Create This)

**Location**: `assets/images/app_icon.png`

**Requirements**:
- Size: 1024x1024 pixels (recommended)
- Format: PNG with transparency (preferred)
- Background: Can be transparent or solid color

**How to Create**:

#### Option A: Using icon.kitchen (Recommended)
1. Visit https://icon.kitchen/
2. Upload your logo file:
   - `assets/images/logo.png` OR
   - `assets/images/امیدِ زن (logo) .png`
3. Customize the design (colors, padding, etc.)
4. Download the generated `app_icon.png`
5. Place it in: `assets/images/app_icon.png`

#### Option B: Manual Creation
1. Use any image editor (Photoshop, GIMP, Figma, etc.)
2. Create a 1024x1024px square image
3. Place your logo centered
4. Export as PNG
5. Save to: `assets/images/app_icon.png`

### 2. Generated Icon Files (Auto-Generated)

**These are created automatically** by `flutter_launcher_icons` - you don't need to create them manually!

**Generated Locations**:

#### Android Icons
```
android/app/src/main/res/
├── mipmap-hdpi/ic_launcher.png
├── mipmap-mdpi/ic_launcher.png
├── mipmap-xhdpi/ic_launcher.png
├── mipmap-xxhdpi/ic_launcher.png
└── mipmap-xxxhdpi/ic_launcher.png
```

#### iOS Icons
```
ios/Runner/Assets.xcassets/AppIcon.appiconset/
├── Contents.json
└── [Various sized icon files]
```

#### Web Icons
```
web/icons/
├── Icon-192.png
├── Icon-512.png
└── favicon.png
```

## ⚙️ Configuration Files

### 1. pubspec.yaml (Already Configured ✓)

```yaml
flutter_launcher_icons:
  android: true
  ios: true
  web: true
  windows: false
  macos: false
  image_path: "assets/images/app_icon.png"  # ← Your source icon
  min_sdk_android: 21
  adaptive_icon_background: "#FFFFFF"
  adaptive_icon_foreground: "assets/images/app_icon.png"
```

**No changes needed** - This is already configured correctly!

### 2. Android Manifest (Auto-Referenced)

The generated icons are automatically referenced in:
- `android/app/src/main/AndroidManifest.xml`

**No manual changes needed.**

### 3. iOS Info.plist (Auto-Referenced)

The generated icons are automatically referenced in:
- `ios/Runner/Info.plist`

**No manual changes needed.**

### 4. Web Manifest (Auto-Referenced)

The generated icons are automatically referenced in:
- `web/manifest.json`

**No manual changes needed.**

## 📝 Step-by-Step Setup

### Step 1: Create/Download Icon
1. Visit https://icon.kitchen/
2. Upload: `assets/images/logo.png`
3. Download: `app_icon.png`
4. Save to: `assets/images/app_icon.png`

### Step 2: Verify File Exists
```bash
# Check if file exists
ls -la assets/images/app_icon.png
```

### Step 3: Generate Icons
```bash
# Make sure dependencies are installed
flutter pub get

# Generate icons for all platforms
flutter pub run flutter_launcher_icons
```

### Step 4: Verify Generated Icons

**Android**:
```bash
ls android/app/src/main/res/mipmap-*/ic_launcher.png
```

**iOS**:
```bash
ls ios/Runner/Assets.xcassets/AppIcon.appiconset/
```

**Web**:
```bash
ls web/icons/
```

### Step 5: Test the App

```bash
# Run on Android
flutter run

# Run on iOS
flutter run

# Run on Web
flutter run -d chrome
```

## 🔍 Troubleshooting

### Icon Not Appearing?

1. **Check source file exists**:
   ```bash
   ls assets/images/app_icon.png
   ```

2. **Regenerate icons**:
   ```bash
   flutter clean
   flutter pub get
   flutter pub run flutter_launcher_icons
   ```

3. **Rebuild the app**:
   ```bash
   flutter clean
   flutter run
   ```

### Icon Looks Blurry?

- Ensure source icon is at least 1024x1024px
- Use high-quality PNG with transparency
- Avoid JPEG format

### Icon Not Updating?

1. **Clean build**:
   ```bash
   flutter clean
   ```

2. **Regenerate icons**:
   ```bash
   flutter pub run flutter_launcher_icons
   ```

3. **Uninstall app** from device/simulator

4. **Reinstall and run**:
   ```bash
   flutter run
   ```

## 📋 Checklist

- [ ] Source icon created/downloaded
- [ ] Source icon placed at `assets/images/app_icon.png`
- [ ] `flutter pub get` executed
- [ ] `flutter pub run flutter_launcher_icons` executed
- [ ] Icons generated in `android/app/src/main/res/mipmap-*/`
- [ ] Icons generated in `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
- [ ] Icons generated in `web/icons/`
- [ ] App tested on Android
- [ ] App tested on iOS
- [ ] App tested on Web

## 🎨 Adaptive Icons (Android)

The configuration includes adaptive icons:
- **Background**: White (`#FFFFFF`)
- **Foreground**: Your app icon

For custom adaptive icon background:
1. Edit `pubspec.yaml`:
   ```yaml
   adaptive_icon_background: "#YOUR_COLOR"
   ```

2. Or use a separate background image:
   ```yaml
   adaptive_icon_background: "assets/images/icon_background.png"
   ```

## 📚 Additional Resources

- [flutter_launcher_icons package](https://pub.dev/packages/flutter_launcher_icons)
- [icon.kitchen tool](https://icon.kitchen/)
- [Android Adaptive Icons Guide](https://developer.android.com/guide/practices/ui_guidelines/icon_design_adaptive)
- [iOS App Icon Guidelines](https://developer.apple.com/design/human-interface-guidelines/app-icons)

---

**Current Status**: ✅ Configuration ready, ⏳ Waiting for `app_icon.png` file

