#!/bin/sh

# Fail on first error.
set -e

cd "$CI_PRIMARY_REPOSITORY_PATH"

echo "=== Cloning Flutter SDK ==="
git clone https://github.com/flutter/flutter.git --depth 1 -b stable "$HOME/flutter"
export PATH="$PATH:$HOME/flutter/bin"
flutter --version

echo "=== Pre-caching iOS artifacts ==="
flutter precache --ios

echo "=== Running flutter pub get ==="
flutter pub get

# Check if CocoaPods is already installed
echo "=== Checking for CocoaPods ==="
if ! command -v pod &> /dev/null
then
  echo "CocoaPods not found, installing via gem..."
  sudo gem install cocoapods
fi

echo "=== Installing pods in ios/ ==="
cd ios
pod install

echo "=== Done. ==="
exit 0