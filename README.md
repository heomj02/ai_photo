# AI Photographer

레퍼런스 사진을 선택하고 촬영자와 모델이 안내를 따라 비슷한 사진을 재현하는
Android 우선 Flutter 앱이다. 이후 혼자 찍기, 두 휴대폰 연결, 주변 배경 추천,
Creator Reference와 색감 보정으로 확장한다.

## 책임과 구조

홈 폴더의 `ai_photo`를 루트로 사용하는 독립 Flutter 작업 공간이다.
로봇 프로젝트와 별개의 Git 저장소에서 변경을 관리한다.

| 경로 | 역할 |
| --- | --- |
| `lib/app/` | 앱 테마와 진입 화면 |
| `lib/features/home/` | 촬영 모드 선택 |
| `lib/features/reference/` | 갤러리 레퍼런스 선택과 미리보기 |
| `lib/features/capture/` | 카메라 미리보기와 수동 촬영 |
| `lib/core/` | 기기 기능과 파일 저장 |
| `android/` | Android 앱 설정과 Flutter 연결 |
| `test/` | 앱 동작 검증 |
| `docs/` | 제품 요구사항, 설계, 개발 단계, 검증 기록 |
| `.tooling/` | Git에 포함하지 않는 SDK와 개발 캐시 |
| `tooling-env.sh` | 현재 터미널에 앱 개발 도구 경로 연결 |
| `ai_photo.code-workspace` | 이 컴퓨터의 VS Code Flutter 환경 |

시작 안내와 모든 설치·빌드·실행 명령은 루트 [RUNBOOK.md](RUNBOOK.md)의
AI Photographer 절에 있다. 현재 환경과 검증 결과는
[ENVIRONMENT.md](docs/ENVIRONMENT.md)에 기록한다.

## 문서

- [제품 전체 명세](docs/PRODUCT_SPEC.md)
- [첫 MVP와 현재 구현 범위](docs/MVP.md)
- [구조와 처리 흐름](docs/ARCHITECTURE.md)
- [데이터 모델](docs/DATA_MODELS.md)
- [개발 순서](docs/ROADMAP.md)
- [테스트 계획](docs/TEST_PLAN.md)
- [기술 결정](docs/DECISIONS.md)
