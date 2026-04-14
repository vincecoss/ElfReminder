#!/bin/bash
set -e

APP_NAME="ElfReminder"
BUILD_DIR="build"
APP_BUNDLE="$BUILD_DIR/$APP_NAME.app"
CONTENTS="$APP_BUNDLE/Contents"
MACOS="$CONTENTS/MacOS"
RESOURCES="$CONTENTS/Resources"

# Clean
rm -rf "$BUILD_DIR"

# Create bundle structure
mkdir -p "$MACOS" "$RESOURCES"

# Compile
swiftc \
    -o "$MACOS/$APP_NAME" \
    -framework Cocoa \
    -swift-version 5 \
    ElfReminder/main.swift \
    ElfReminder/AppDelegate.swift

# Copy Info.plist
cp ElfReminder/Info.plist "$CONTENTS/Info.plist"

# Patch Info.plist with concrete values (replace build variables)
sed -i '' 's/$(DEVELOPMENT_LANGUAGE)/en/g' "$CONTENTS/Info.plist"
sed -i '' 's/$(EXECUTABLE_NAME)/ElfReminder/g' "$CONTENTS/Info.plist"
sed -i '' 's/$(PRODUCT_BUNDLE_IDENTIFIER)/com.vincentcossette.ElfReminder/g' "$CONTENTS/Info.plist"
sed -i '' 's/$(PRODUCT_NAME)/ElfReminder/g' "$CONTENTS/Info.plist"
sed -i '' 's/$(MARKETING_VERSION)/1.0/g' "$CONTENTS/Info.plist"
sed -i '' 's/$(CURRENT_PROJECT_VERSION)/1/g' "$CONTENTS/Info.plist"
sed -i '' 's/$(MACOSX_DEPLOYMENT_TARGET)/13.0/g' "$CONTENTS/Info.plist"

# Create PkgInfo
echo -n "APPL????" > "$CONTENTS/PkgInfo"

echo "Build successful: $APP_BUNDLE"
