# AI Photo 실행 가이드


새 앱 위치는 `~/ai_photo`다. ROS와 별도로 실행한다.
제품과 파일 구조는 [앱 README](README.md), 실제 설치·검증 기록은
[ENVIRONMENT.md](docs/ENVIRONMENT.md)를 참조한다.

## 가장 간단하게 앱 켜기

1. VS Code에서 **파일 → 파일에서 작업 영역 열기**를 선택하고
   홈 폴더의 `ai_photo/ai_photo.code-workspace`를 연다.
2. **Ctrl+Shift+P**를 누르고 **Flutter: Launch Emulator**를 선택한다.
3. 목록에서 **ai photographer api36**을 선택하고 Android 화면이 켜질 때까지 기다린다.
4. `lib/main.dart`를 열고 **F5**를 누른다. 실행 기기를 물으면 Android 에뮬레이터를 고른다.
5. 앱에서 **둘이 찍기 → 갤러리에서 사진 선택 → 이 사진처럼 찍기 → 사진 촬영** 순서로 사용한다.

실제 휴대폰을 쓸 때는 아래의 USB 디버깅 안내를 따른다.

## 1 VS Code에서 시작

VS Code의 **파일 → 파일에서 작업 영역 열기**로 앱 폴더 안의
`ai_photo.code-workspace`를 연다. Flutter와 Dart 확장은 설치되어 있다.
터미널에서 여는 방법은 다음과 같다.

```bash
cd ~/ai_photo
code ai_photo.code-workspace
```

앱 폴더의 `tooling-env.sh`는 Flutter, Android SDK, 앱 전용 캐시 경로를
현재 터미널에 연결한다. 새 터미널마다 먼저 불러온다. 시스템 Java는 기존 JDK를 사용한다.

```bash
cd ~/ai_photo
source tooling-env.sh
flutter --version
dart --version
java -version
adb --version
flutter doctor -v
```

Flutter/Dart, Android SDK/NDK와 캐시는 `.tooling/` 안에 있다. Git에는 포함되지 않는다.
Android만 개발하므로 doctor의 Chrome·Linux 데스크톱 개발 도구 경고는
Android 빌드 실패를 의미하지 않는다. 추가 SDK 라이선스 경고가 있으면 다음 명령으로
내용을 읽고 필요한 동의를 완료한다.

```bash
cd ~/ai_photo
source tooling-env.sh
flutter doctor --android-licenses
```

## 2 Android 휴대폰으로 실행

휴대폰의 개발자 옵션에서 **USB 디버깅**을 켜고 USB로 연결한다.
휴대폰에 표시되는 이 컴퓨터의 디버깅 허용을 승인한다.

```bash
cd ~/ai_photo
source tooling-env.sh
adb devices -l
flutter devices
flutter run
```

휴대폰이 `unauthorized`면 휴대폰의 허용 화면을 확인한다.
기기가 여러 개면 VS Code 하단의 기기 선택에서 Android 휴대폰을 선택하고
`lib/main.dart`를 연 뒤 **F5**를 누른다. 최초 실행 시 카메라 권한을 허용한다.
홈 → 둘이 찍기 → 갤러리에서 사진 선택 → 이 사진처럼 찍기 → 사진 촬영 순서다.
혼자 찍기·셀카·AI 안내·자동촬영은 아직 제공하지 않는다.
사진은 앱 전용 공간에 저장되며 앱 삭제 시 함께 삭제된다. 갤러리 내보내기는 후속이다.

## 3 에뮬레이터 실행

준비된 개발용 AVD 이름은 `ai_photographer_api36`이다.
아래 명령은 에뮬레이터를 실행하므로 별도 터미널에서 앱을 실행한다.

```bash
cd ~/ai_photo
source tooling-env.sh
emulator -avd ai_photographer_api36 -memory 2048 -camera-back virtualscene
```

다른 터미널:

```bash
cd ~/ai_photo
source tooling-env.sh
flutter devices
flutter run
```

에뮬레이터에 사진 파일을 드래그해 넣고 시스템 Photos/Files에서 보이는지 확인한 뒤
앱의 갤러리 선택에 사용한다. 가상 카메라 검증과 실제 휴대폰 촬영 검증은 별개다.
가속 오류가 나면 KVM 접근 권한과 BIOS 가상화 설정을 확인한다.

## 4 코드 검증과 APK

```bash
cd ~/ai_photo
source tooling-env.sh
flutter pub get
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
flutter build apk --debug
```

개발용 APK 위치는 `build/app/outputs/flutter-apk/app-debug.apk`다.
이 APK는 개발용이며 스토어 배포용 서명 설정은 포함하지 않는다.

## 5 다른 컴퓨터에서 개발 도구 다시 준비

현재 컴퓨터에는 설치 작업을 수행했다. 이 절은 SDK가 없는 새 checkout용이다.
Ubuntu의 Git, curl, unzip, xz-utils, zip, libglu1-mesa와 JDK가 필요하다.
현재 컴퓨터에서는 모두 확인되어 OS 패키지를 변경하지 않았다.
Flutter SDK에는 Dart가 포함된다. 설치 경로는 앱의 `.tooling/`을 유지한다.

기준: [Flutter 설치](https://docs.flutter.dev/install/manual),
[Android 개발 환경](https://docs.flutter.dev/platform-integration/android/setup),
[Android 명령줄 도구](https://developer.android.com/studio#command-line-tools-only).
버전을 바꾸려면 패키지 호환성과 Android 빌드를 함께 확인한다.

다른 사용자나 다른 위치에서 checkout했다면 먼저 전용 workspace의 환경 경로를 갱신한다.
Dart 확장의 `dart.env`는 `${workspaceFolder}`를 자동 치환하지 않는다.

```bash
cd ~/ai_photo
python3 - <<'PY'
import json
from pathlib import Path
p = Path('ai_photo.code-workspace')
workspace = json.loads(p.read_text())
for key, value in workspace['settings']['dart.env'].items():
    relative = value.split('/.tooling/', 1)[1]
    workspace['settings']['dart.env'][key] = str(Path.cwd() / '.tooling' / relative)
p.write_text(json.dumps(workspace, ensure_ascii=False, indent=2) + '\n')
PY
```

다음 다운로드·압축 해제는 **해당 SDK 폴더가 없을 때만** 실행한다.
기존 설치에 덮어쓰지 않는다.

```bash
cd ~/ai_photo
mkdir -p .tooling/downloads
curl -fL https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.47.5-stable.tar.xz -o .tooling/downloads/flutter.tar.xz
printf '%s\n' '2132e990f236f8d22e7c6314b29a191a95b10d7cbcfec9b4e2e303d996652cbb  .tooling/downloads/flutter.tar.xz' | sha256sum --check
```

체크섬이 `OK`인 경우에만 압축을 해제한다.

```bash
cd ~/ai_photo
tar -xf .tooling/downloads/flutter.tar.xz -C .tooling
curl -fL https://dl.google.com/android/repository/commandlinetools-linux-15859902_latest.zip -o .tooling/downloads/android-commandline.zip
printf '%s\n' '040d3996a65543d22ec4bf73e4c37aa37a8d4af4  .tooling/downloads/android-commandline.zip' | sha1sum --check
```

Android 다운로드도 체크섬 `OK`를 확인한 뒤 진행한다.
SDK 설치 중 라이선스 내용을 확인하고 동의 여부를 선택한다.

```bash
cd ~/ai_photo
mkdir -p .tooling/android-sdk/cmdline-tools
unzip -q .tooling/downloads/android-commandline.zip -d .tooling/android-sdk/cmdline-tools
mv .tooling/android-sdk/cmdline-tools/cmdline-tools .tooling/android-sdk/cmdline-tools/22.0
source tooling-env.sh
flutter --disable-analytics
dart --disable-analytics
sdkmanager --sdk_root="$ANDROID_HOME" 'platform-tools' 'platforms;android-36' 'platforms;android-35' 'build-tools;36.0.0' 'ndk;28.2.13676358'
code --install-extension Dart-Code.flutter
flutter pub get
```

에뮬레이터도 필요한 새 환경에서만 다음을 실행한다.

```bash
cd ~/ai_photo
source tooling-env.sh
sdkmanager --sdk_root="$ANDROID_HOME" 'emulator' 'system-images;android-36;google_apis;x86_64'
mkdir -p "$ANDROID_AVD_HOME"
avdmanager create avd --name ai_photographer_api36 --package 'system-images;android-36;google_apis;x86_64' --device pixel_7
```

SDK 도구가 `sdkmanager`/`avdmanager`의 후속 CLI를 권장하는 메시지를 표시할 수 있다.
이 프로젝트는 위에 고정한 Command-line Tools 22.0의 명령으로 검증한다.
