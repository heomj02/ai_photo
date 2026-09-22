# AI Photo 변경 기록

## 2026-09-22 홈의 독립 ai_photo 작업 공간으로 이동

- 변경내용: 앱·Flutter/Android SDK·캐시·AVD를 홈의 `~/ai_photo`로 이동하고 VS Code 작업 영역을 `ai_photo.code-workspace`로 변경함. 경로 설정과 문서 링크를 갱신하고 실행 안내·개발 지침·Git 저장소·변경 로그를 독립시킴. 새 위치에서 정적 분석, 테스트 12개, APK 빌드와 에뮬레이터 Home 실행을 확인함
- 이유: 로봇 작업 공간 밖에 홈 폴더를 기준으로 별도 앱 작업 공간을 만들어 달라는 사용자 요청을 반영하기 위해
- 수정파일: `ai_photo.code-workspace`, `android/local.properties` 및 로컬 AVD 설정, `README.md`, `RUNBOOK.md`, `AGENTS.md`, `docs/`, `PROJECT_LOG.md`
- 일시: 2026-09-22 21:26 KST
