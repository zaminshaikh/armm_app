#!/bin/sh
# ^ or use #!/bin/zsh if you want zsh
# Fail on first error:
set -e

echo "=== In ci_post_clone.sh ==="
echo "Current directory: $(pwd)"

# If $CI_PRIMARY_REPOSITORY_PATH points to /Volumes/workspace/repository,
# and your Flutter project is in apps/mobile, do:
cd "$CI_PRIMARY_REPOSITORY_PATH/apps/mobile"
echo "Now in: $(pwd)"

echo "=== Cloning Flutter SDK ==="
git clone https://github.com/flutter/flutter.git --depth 1 -b stable "$HOME/flutter"
export PATH="$PATH:$HOME/flutter/bin"

flutter --version

echo "=== Pre-caching iOS artifacts ==="
flutter precache --ios

echo "=== Running flutter pub get ==="
flutter pub get

echo "=== Installing pods ==="
cd ios
pod install

echo "=== ci_post_clone.sh completed successfully. ==="
exit 0