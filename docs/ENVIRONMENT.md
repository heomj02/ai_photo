# 개발 환경과 검증 기록

점검일: 2026-09-22 KST. 앱 위치: `~/ai_photo`.

## 시작 시 상태

Ubuntu 24.04.5 LTS / x86_64, OpenJDK 21.0.12, Git 2.43.0, VS Code는 있었다.
Flutter/Dart, Android SDK/adb, VS Code Flutter/Dart 확장은 확인되지 않았다.
Git/curl/unzip/xz/zip/libglu1-mesa는 이미 있어 OS 패키지 설치는 필요하지 않았다.
사용자가 개발 도구 설치와 앱 실행 준비까지 진행하도록 요청했다.

## 준비한 환경

| 항목 | 버전/상태 |
| --- | --- |
| Flutter | stable 3.47.5 |
| Dart | Flutter에 포함된 3.13.4 |
| Java | 기존 OpenJDK 21.0.12 사용 |
| Android Command-line Tools | 22.0 |
| Android SDK Platform | API 36, 플러그인 빌드용 API 35 |
| Android Build Tools | 36.0.0 |
| Android Platform Tools / adb | 37.0.1 |
| Android NDK | 28.2.13676358 |
| VS Code Flutter / Dart | 각 3.142.0 |
| Android Emulator | 37.1.11, API 36 Google APIs x86_64 |
| Android CMake | 플러그인 빌드에서 3.22.1 자동 설치 |
| KVM | 호스트에서 사용 가능 확인 |
| Android 실기기 | adb 목록에 없음 |

SDK와 캐시는 `.tooling/`에 보관하고 Git에서 제외했다.
Flutter/Dart 사용량 분석 전송은 비활성화했다. SDK 내부 상태 파일과
VS Code 확장처럼 도구가 직접 관리하는 일부 파일은 사용자 홈에 생길 수 있다.
시스템 Java 변경, ROS 패키지 변경, 새로운 ROS workspace 생성은 하지 않았다.

## 자동 검증

- Dart 포맷 적용 완료.
- 정적 분석: 문제 없음.
- 자동 테스트: 12개 통과. 모드 선택, 사진 선택·취소·실패·복구,
  선택 대기 중 화면 종료, 카메라 초기화 중 중단, 반복 초기화,
  권한 재시도, 거절 직후 자동 재요청 방지, 카메라 없음, 일시정지/복귀를 포함한다.
- Android debug APK: 빌드 성공 (최초 약 552초, 권한 수정 후 재빌드 약 15초).
- 에뮬레이터: `ai_photographer_api36` 생성·부팅·APK 설치·앱 시작 성공.
  Home 세 모드, 갤러리 사진 선택, Reference preview와 촬영 진입 버튼을 확인했다.
  가상 후면 카메라 preview, 수동 촬영, 앱 전용 영역의 JPEG 파일 생성을 확인했다.
  최종 APK에서 권한 거절 → 오류 화면 유지 → 명시적 재시도 → 허용 → 촬영 결과,
  다시 촬영, Home으로 나갔다 앱 복귀 후 카메라 재개를 확인했다.

스크린샷은 로컬 `.tooling/validation/`에 보관했다.
검증 후 화면 없는 에뮬레이터는 종료하며, RUNBOOK에서 같은 AVD를 다시 실행할 수 있다.

에뮬레이터에서 권한 거절 직후 앱 복귀 이벤트가 권한을 재요청하는 문제가 발견되어,
실패 후에는 명시적인 ‘다시 시도’로만 초기화하도록 수정하고 회귀 테스트를 추가했다.
검증에는 앱 기본 아이콘을 레퍼런스 fixture로 사용했고, 촬영 대상은 에뮬레이터의
가상 장면이다. 실제 사람·포즈·AI 성능을 검증한 것은 아니다.

실기기 카메라 품질·권한·센서·제조사별 동작은 아직 검증하지 않았다.
현재 앱에는 ML, AI 안내, 자동촬영, 두 폰 연결이 없다.

## 환경 진단 해석

Flutter doctor의 Chrome/Linux 데스크톱 도구 경고는 현재 Android 범위 밖이다.
빌드에 사용하는 Android SDK 라이선스는 설치 과정에서 처리했다.
추가 Android 구성 요소의 미수락 라이선스 경고가 남을 수 있으며,
확인 방법은 루트 [RUNBOOK.md](../RUNBOOK.md)에 있다.
제한된 도구 실행 환경에서는 USB와 KVM이 보이지 않지만,
호스트 점검에서 KVM이 사용 가능함을 확인했다.

## 작업 공간 이동

2026-09-22 사용자 요청으로 홈의 `~/ai_photo`로 이동했다.
SDK·캐시·AVD를 함께 이동하고 VS Code, Android local.properties, AVD 경로를 갱신했다.
앱의 생성 캐시는 새 위치에서 재생성했다. 독립 Git 저장소를 초기화했으며 아직 커밋하지 않았다.
이동 후 정적 분석·자동 테스트 12개·Android debug APK 재빌드를 통과했다.
새 경로의 SDK로 에뮬레이터를 부팅하고 APK 설치와 Home 화면을 확인했다.
