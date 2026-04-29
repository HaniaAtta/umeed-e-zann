# App Icon Setup Guide

## Using icon.kitchen

1. Visit https://icon.kitchen/ 
2. Upload your app logo (`assets/images/logo.png` or `assets/images/امیدِ زن (logo) .png`)
3. Customize the icon design as needed
4. Download the generated icon set
5. Extract the downloaded files
6. Place the `app_icon.png` file in `assets/images/app_icon.png`

## Alternative: Manual Setup

If you prefer to use your existing logo directly:

1. Make sure you have a PNG file (recommended size: 1024x1024px) for the app icon
2. Place it at `assets/images/app_icon.png`
3. Run the following command to generate icons:

```bash
flutter pub run flutter_launcher_icons
```

## Configuration

The app icon configuration is already set up in `pubspec.yaml`:

```yaml
flutter_launcher_icons:
  android: true
  ios: true
  web: true
  windows: false
  macos: false
  image_path: "assets/images/app_icon.png"
  min_sdk_android: 21
  adaptive_icon_background: "#FFFFFF"
  adaptive_icon_foreground: "assets/images/app_icon.png"
```

## After Adding the Icon

Once you've placed `app_icon.png` in `assets/images/`, run:

```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

This will generate all platform-specific icons automatically.

## Current Status

⚠️ **Action Required**: You need to create/place `app_icon.png` at `assets/images/app_icon.png`

You can:
1. Use icon.kitchen to generate a professional icon from your logo
2. Or manually prepare a 1024x1024px PNG and place it in the assets/images folder

