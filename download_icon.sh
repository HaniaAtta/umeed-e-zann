#!/bin/bash

# Script to download icon from icon.kitchen
# The URL provided is a configuration link. You need to:
# 1. Open the URL in your browser
# 2. Click the download button on the icon.kitchen website
# 3. Extract the downloaded zip file
# 4. Place the PNG icon file (1024x1024 or larger) as assets/images/app_icon.png

ICON_URL="https://icon.kitchen/i/H4sIAAAAAAAAA6tWKkvMKU0tVrKqVkpJLMoOyUjNTVWySkvMKU7VUUpLd87PyS9SslIqSk%2FSMDI11VGAEZpKOkpJKNKGBmY6CmaGQFljI02lWh2l3PyU0hyQ0dFKiXkpRfmZKUA9mfnFQLI8NUkpthYA9NHtr30AAAA%3D"

echo "Icon Kitchen URL: $ICON_URL"
echo ""
echo "Since icon.kitchen uses a web interface, please:"
echo "1. Open the URL above in your browser"
echo "2. Click the download button to get the icon package"
echo "3. Extract the zip file"
echo "4. Copy the largest PNG icon (preferably 1024x1024) to: assets/images/app_icon.png"
echo ""
echo "After placing the icon, run: flutter pub run flutter_launcher_icons"












