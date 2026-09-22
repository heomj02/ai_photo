# 개발 순서

각 단계는 코드 확인 → 목표 설명 → 필요한 변경 → 포맷 → 정적 분석 →
테스트/빌드 → 오류 해결 → 검증 결과 기록 순으로 진행한다.
명령은 루트 [RUNBOOK.md](../RUNBOOK.md)에만 둔다.

| Phase | 범위 | 다음 단계 진입 조건 |
| --- | --- | --- |
| 0 | Ubuntu, Flutter/Dart, Java, Android SDK/adb, Git, VS Code, 기기 확인 | SDK와 분석·빌드 도구 정상, 기기 제한 기록 |
| 1 | Android Flutter 앱 생성 | 기존 ROS와 분리, 기본 빌드 |
| 2 | 제품·MVP·구조·모델·계획·검증·결정 문서 | 장기 요구 보존, 현재 범위 구분 |
| 3 | Home와 세 모드 | 둘이 찍기 이동, 나머지 준비 중 |
| 4 | 갤러리 Reference 한 장과 preview | 선택/취소/재선택/복구 확인 |
| 5 | Camera preview, permission, 수동 촬영/저장/결과 | 실기기 기본 흐름 안정화 |
| 6 | Reference와 live person/pose, debug skeleton | 회전·미러링·검출 신뢰도 검증 |
| 7 | 중심·박스·신장 비율의 composition | 좌우/앞뒤 지시 의미 실기기 검증 |
| 8 | 정규화 pose와 관절각, 점수와 단일 지시 | 팔·다리 등 자세 차이를 올바르게 안내 |
| 9 | pitch/roll, 기울기·수평 | 센서 축과 camera 좌표 일치 |
| 10 | Readiness와 auto capture | 조건 유지, 미검출 방지, 중복 촬영 방지 |
| 11 | Solo tripod + 짧은 TTS + 시스템 이어폰 | 화면 없이 안내·촬영 가능 |
| 12 | Model Phone 연결, live view, 모델 코칭, 결과/retake | 지연·끊김·시선 전환 검증 |
| 13 | 배경 스캔·embedding·Top N·재현 가능성 | 실제 장소에서 재현하기 좋은 결과 평가 |
| 14 | Creator upload/metadata/packs/backend/account/payment/revenue | 시장 검증 후 단계 승인 |

Selfie는 얼굴·표정·휴대폰 방향·배경·조명으로 확장한다.
Group/Couple Tripod는 Solo 이후 다인 검출과 readiness를 다룬다.
색감 보정은 촬영 후 brightness/contrast/saturation/temperature/highlights/shadows/tone과
reference style을 적용한다. 얼굴/눈/시선/흐림/초점/노출 판단은 지원 가능한 요소부터 추가한다.
지원 기기별 절대 거리/높이 추정과 iOS는 확장 항목이며 현재 일정의 필수 조건이 아니다.

현재 단계의 실제 검증 결과는 [ENVIRONMENT.md](ENVIRONMENT.md)를 참조한다.
