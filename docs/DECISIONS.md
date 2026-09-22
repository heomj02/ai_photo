# 기술·제품 결정

## 2026-09-22: 시작 범위와 위치

사용자가 개발 도구 설치와 실행 준비까지 명시적으로 요청했다.
기존 ROS 프로젝트를 보존하기 위해 `ai_photographer/`에 Android 앱을 분리한다.
추가 ROS workspace나 중첩 Git 저장소를 만들지 않고 `COLCON_IGNORE`를 둔다.
첫 구현은 기본 촬영 흐름까지이며 ML/auto capture는 후속이다.
정확한 거리보다 화면 속 목표 일치도를 제품의 기준으로 유지한다.

## 개발 도구

Flutter stable과 그에 포함된 Dart를 사용한다. SDK는 `.tooling/`에 로컬 설치하고
Git에서 제외한다. VS Code를 편집기로 유지하며 Android Studio 전체 대신
Android Command-line Tools로 빌드 환경을 준비한다. 현재 설치된 JDK를 먼저 사용한다.
기기 연결과 가상화는 환경 접근 가능 여부를 확인하고, 확인하지 못하면 미검증으로 기록한다.
라이선스는 내용을 표시하고 사용자 동의가 필요한 경우 그 단계에서 처리한다.
VS Code 확장 3.142.0의 `dart.env`는 경로 변수를 치환하지 않으므로 전용 workspace에
이 컴퓨터의 실제 SDK/캐시 절대경로를 기록했다. 앱 폴더를 옮기거나 다른 사용자로
checkout하면 RUNBOOK의 경로 갱신 절차를 따른다. 셸 환경 파일은 위치를 자동 계산한다.

## 패키지 선택 기준

Flutter 공식 publisher의 패키지를 우선 검토한다. 설치 시점의 stable 호환성,
Android 최소 버전, native dependency, 최근 유지관리, 문서, 사용량을 확인한다.
설치된 버전은 pubspec과 lockfile로 기록한다.

| 패키지 | 사용 이유 | 대안 | 위험/대응 |
| --- | --- | --- | --- |
| camera | preview와 수동 촬영, 향후 image stream | 직접 CameraX 구현 | lifecycle 직접 관리, 기기별 실기기 테스트 |
| image_picker | 시스템 갤러리 단일 이미지 선택 | 직접 Photo Picker 연결 | Activity 종료 후 lost data 복구, 선택 취소 처리 |
| path_provider | 앱 영속 사진 저장 경로 | 임의 native 경로 하드코딩 | 앱 삭제 시 함께 삭제, gallery export는 후속 |
| camera_platform_interface (test 전용) | native 카메라를 대체해 lifecycle 경합 검증 | 실기기 테스트만 수행 | 기존 camera의 전이 의존성을 직접 선언, 실기기 검증은 별도 |

근거: [camera](https://pub.dev/packages/camera),
[image_picker](https://pub.dev/packages/image_picker),
[path_provider](https://pub.dev/packages/path_provider).
직접 native 채널을 만드는 비용을 줄이면서 플랫폼 경계를 유지한다.
선택 버전은 camera 0.12.1, image_picker 1.2.3, path_provider 2.1.6이며
공통 지원 하한에 맞춰 Android minSdk 24를 사용한다. 저장소 이름과 applicationId의
`com.example`은 개발용이며 스토어 배포 전 제품 식별자와 서명을 확정한다.
서버·로그인·유료 API·상태관리 프레임워크·ML 패키지는 아직 추가하지 않는다.

## 후속 선택

Pose는 Google ML Kit, MediaPipe, TensorFlow Lite의 유지관리와 기기 성능을
Phase 6에서 비교한다. 자체 학습은 하지 않는다. Repository/service 경계는
실제 기능이 생길 때 추가한다. 두 폰 통신 기술도 Phase 12에서 확정한다.
한 지시 우선, 온디바이스 처리, 추론 중 프레임 드롭, 좌표 정규화를 공통 원칙으로 둔다.

## 2026-09-22: 독립 작업 공간으로 이동

사용자의 명시적 요청에 따라 앱과 도구 전체를 홈의 `~/ai_photo`로 이동했다.
앞의 로봇 저장소 내 위치 결정은 이 결정으로 대체한다.
VS Code workspace 이름은 `ai_photo`이며 Dart 패키지명과 Android applicationId는 유지한다.
실행 문서와 개발 로그도 새 루트에 두고 독립 Git 저장소에서 관리한다.
