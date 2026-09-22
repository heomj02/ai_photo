# Source from Bash. Keep SDKs and caches scoped to this app.
ai_photographer_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
export FLUTTER_ROOT="$ai_photographer_root/.tooling/flutter"
export ANDROID_HOME="$ai_photographer_root/.tooling/android-sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export ANDROID_USER_HOME="$ai_photographer_root/.tooling/android-user"
export ANDROID_AVD_HOME="$ai_photographer_root/.tooling/avd"
export PUB_CACHE="$ai_photographer_root/.tooling/pub-cache"
export GRADLE_USER_HOME="$ai_photographer_root/.tooling/gradle"
export XDG_CONFIG_HOME="$ai_photographer_root/.tooling/config"
export PATH="$FLUTTER_ROOT/bin:$ANDROID_HOME/cmdline-tools/22.0/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$PATH"
unset ai_photographer_root
