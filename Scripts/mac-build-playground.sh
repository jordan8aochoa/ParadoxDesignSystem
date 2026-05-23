#!/usr/bin/env bash
# mac-build-playground.sh
#
# Mac mini side of the Windows->Mac handoff loop.
# Pulls latest, regenerates the Playground Xcode project via XcodeGen,
# builds it for the iPhone 16 Pro simulator, boots the sim, installs the app,
# launches it, and saves a screenshot to handoff-screenshots/latest.png.
#
# Prereqs:
#   - Xcode 16+ installed
#   - xcodegen installed (`brew install xcodegen`)
#   - Run from the repo root

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

SCHEME="ParadoxPlayground"
APP_BUNDLE_ID="com.paradox.playground"
SIM_NAME="iPhone 16 Pro"
PLAYGROUND_DIR="Playground/ParadoxPlayground"
SCREENSHOT_DIR="handoff-screenshots"

mkdir -p "$SCREENSHOT_DIR"

echo "==> git pull"
git pull --ff-only

echo "==> swift build (package)"
swift build

echo "==> swift test (package)"
swift test || { echo "tests failed"; exit 1; }

echo "==> xcodegen generate"
( cd "$PLAYGROUND_DIR" && xcodegen generate )

echo "==> Boot simulator: $SIM_NAME"
SIM_UDID=$(xcrun simctl list devices available | grep -E "$SIM_NAME \(" | head -1 | sed -E 's/.*\(([A-F0-9-]+)\).*/\1/')
if [ -z "${SIM_UDID:-}" ]; then
    echo "error: simulator '$SIM_NAME' not available"
    exit 2
fi
xcrun simctl boot "$SIM_UDID" 2>/dev/null || true
open -a Simulator

echo "==> xcodebuild build"
xcodebuild \
    -project "$PLAYGROUND_DIR/$SCHEME.xcodeproj" \
    -scheme "$SCHEME" \
    -destination "platform=iOS Simulator,id=$SIM_UDID" \
    -derivedDataPath ".build/xcode-derived" \
    -quiet \
    build

APP_PATH=$(find .build/xcode-derived/Build/Products -name "$SCHEME.app" -type d | head -1)
if [ -z "$APP_PATH" ]; then
    echo "error: $SCHEME.app not found after build"
    exit 3
fi

echo "==> Install + launch on simulator"
xcrun simctl install "$SIM_UDID" "$APP_PATH"
xcrun simctl launch "$SIM_UDID" "$APP_BUNDLE_ID" >/dev/null

sleep 2  # let SwiftUI settle before snapshot

echo "==> Screenshot"
xcrun simctl io "$SIM_UDID" screenshot "$SCREENSHOT_DIR/latest.png"
echo "Saved: $SCREENSHOT_DIR/latest.png"
