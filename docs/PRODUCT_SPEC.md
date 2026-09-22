# AI Photographer 제품 전체 명세

사용자 제공 원안의 제품 요구사항과 예시를 아래에 보존한다. 전체 제품의 목표이며
현재 구현 완료 목록이 아니다. 현재 범위는 [MVP.md](MVP.md), 실제 검증은
[ENVIRONMENT.md](ENVIRONMENT.md)를 따른다.

사진 초보자가 “이 사진처럼 찍고 싶다” 또는 “여기서 무엇을 찍을까”만 결정하면,
앱이 촬영 위치·구도·모델 포즈·촬영 순간을 안내한다. Flutter/Dart, Ubuntu/VS Code,
Android 우선이며 향후 같은 코드베이스의 iOS를 고려한다.

## 문서 분담

원안 1–21절은 전체 기능·단계·모델·테스트 요구를 보존한다.
22절 개발 절차는 ROADMAP, 23절 패키지 기준은 DECISIONS,
24절 초보자 안내와 25절 최초 작업 순서는 RUNBOOK 및 MVP에 반영한다.
26–28절의 금지사항·핵심 원칙·최종 목표도 아래에 보존한다.
설치와 실행 명령은 루트 RUNBOOK에서만 관리한다.

## 1. 앱의 핵심 제품 정의

이 앱은 단순한 카메라 앱이나 포즈 추천 앱이 아니다.

핵심 컨셉은:

"현재 장소에서 어떤 사진을 찍으면 좋을지 찾아주고, 원하는 레퍼런스 사진을 실제로 재현할 수 있도록 촬영자와 모델을 각각 AI가 안내하며, 가장 좋은 순간을 자동으로 촬영하는 AI Photographer"

이다.

사용자가 원하는 최종 경험은 다음과 같다.

현재 주변 환경 확인
→ 어울리는 레퍼런스 사진 발견
→ 사진 선택
→ 촬영자 위치/카메라 방향 가이드
→ 모델 위치/포즈 가이드
→ 구도/포즈/얼굴/눈/흔들림/초점/노출 판단
→ 가장 좋은 순간 자동촬영
→ 촬영 결과 확인
→ 필요하면 재촬영
→ 촬영 후 레퍼런스와 유사한 색감 보정

중요:

"정확히 83cm 뒤로 이동하세요" 같은 절대 거리 측정은 핵심 기능이 아니다.

MVP에서는 정확한 실제 거리 측정을 포기한다.

대신 현재 카메라 화면과 목표 레퍼런스의 차이를 지속적으로 비교해서 다음처럼 상대적인 지시를 한다.

* 왼쪽으로 이동
* 오른쪽으로 이동
* 조금 앞으로
* 조금 뒤로
* 카메라를 높이기
* 카메라를 낮추기
* 휴대폰을 위로 기울이기
* 휴대폰을 아래로 기울이기
* 1x 사용
* 2x 사용
* 조금 더
* 좋습니다
* 그대로

즉 실제 세계의 정확한 cm보다 최종 이미지의 일치도를 높이는 것이 목표다.

향후 지원 기기나 센서를 이용해 절대 거리 추정 기능을 추가할 수 있도록 확장 포인트만 남겨둔다.

## 2. 주요 촬영 모드

장기적으로 다음 촬영 모드를 지원한다.

A. 둘이 찍기 / Photographer + Model Mode

한 사람이 사진을 찍고 한 사람이 모델이 되는 상황이다.

촬영자에게는 Photographer AI가 안내한다.

예:

* 왼쪽으로 이동
* 오른쪽으로 이동
* 조금 뒤로
* 조금 앞으로
* 카메라를 낮추기
* 카메라를 높이기
* 휴대폰 기울기 수정
* 1x / 2x 렌즈 추천
* 인물이 너무 큼
* 인물이 너무 작음
* 인물을 화면 왼쪽/오른쪽으로 배치
* 배경을 조금 더 포함
* 수평 조정

촬영자 화면에는 가능하면 다음 정보를 표시한다.

* Reference image
* 현재 Camera Preview
* Composition Match Score
* Pose Match Score
* 촬영 준비 상태
* 간단한 방향 화살표
* 현재 가장 중요한 하나의 지시사항

한 번에 여러 문장을 띄워 사용자를 혼란스럽게 하지 마라.

가장 중요한 수정사항 하나를 우선 안내한다.

---

B. Model Phone Mode

모델도 자신의 스마트폰으로 앱에 접속할 수 있다.

촬영자 스마트폰과 모델 스마트폰을 연결한다.

모델 스마트폰에서는 촬영자의 실제 Camera Live View를 볼 수 있어야 한다.

모델에게는 Photographer용 가이드가 아니라 Model AI 가이드를 제공한다.

예:

* 왼발 앞으로
* 오른발 뒤로
* 오른팔 조금 내리기
* 왼팔 올리기
* 몸을 왼쪽으로 회전
* 몸을 오른쪽으로 회전
* 어깨 조금 내리기
* 턱 조금 아래
* 고개 오른쪽
* 시선 카메라
* 자세 유지

모델 화면에는 가능하면:

* 레퍼런스 사진
* 촬영자의 Live View
* 자신의 Pose Match
* 필요한 포즈 수정사항

을 보여준다.

포즈가 충분히 맞아지면:

"포즈가 맞았습니다. 휴대폰을 내려놓고 카메라를 보세요."

같은 안내를 한다.

모델이 계속 자신의 휴대폰 화면을 쳐다보다 사진의 시선이 이상해지는 문제를 피해야 한다.

향후 Bluetooth 이어폰이 연결되어 있다면 최종 미세 조정은 음성으로 제공할 수 있다.

촬영이 끝난 뒤 촬영 결과 preview를 모델 폰으로 보내는 기능도 장기적으로 지원한다.

모델은:

* 만족
* 다시 촬영

을 선택할 수 있다.

"다시 촬영"을 선택하면 촬영자에게 재촬영 요청이 전달된다.

이 기능은 중요한 장기 기능이지만 첫 번째 MVP에서 네트워크 연결까지 반드시 구현할 필요는 없다.

아키텍처에는 반드시 고려하되 단계적으로 추가한다.

---

C. 혼자 찍기 / Tripod Solo Mode

사용자가 스마트폰을 삼각대에 두고 후면카메라로 혼자 사진을 찍는 경우다.

이 모드는 매우 중요한 기능이다.

사용자는 Bluetooth 이어폰/AirPods 같은 이어폰을 착용할 수 있다.

스마트폰은 사용자를 카메라로 분석하고 이어폰으로 짧은 음성 명령을 전달한다.

예:

"왼쪽."

"조금 더."

"뒤로."

"좋아요."

"오른발 앞으로."

"턱 조금 아래."

"그대로."

"카메라 보세요."

명령은 짧고 즉각적이어야 한다.

장황한 AI 설명을 음성으로 읽지 마라.

사용자가 화면을 볼 수 없기 때문에 Voice Coaching UX가 핵심이다.

사용자가 적절한 위치와 포즈에 도달하면 자동촬영한다.

기존 타이머 촬영처럼:

셔터 누름
→ 뛰어감
→ 포즈
→ 촬영
→ 다시 뛰어옴
→ 확인

과정을 반복하지 않게 하는 것이 목적이다.

---

D. Selfie Mode

전면카메라를 이용한 셀카 모드다.

이 모드에서는 촬영자가 따로 없으므로 다음 요소를 안내한다.

* 휴대폰 높이
* 휴대폰 방향
* 얼굴 위치
* 얼굴 각도
* 턱 각도
* 시선
* 표정
* 얼굴과 카메라 사이 상대적 거리
* 배경 위치
* 조명
* 노출
* 구도

셀카 모드는 장기 기능이며 첫 번째 MVP의 우선순위는 아니다.

---

E. Group / Couple Tripod Mode

향후 여러 명이 삼각대 앞에서 촬영할 수 있도록 Solo Mode를 확장할 수 있게 설계한다.

하지만 지금 구현 우선순위는 낮다.

## 3. 레퍼런스 사진 시스템

앱의 중심에는 Reference Photo가 있다.

사용자는 다음 방식으로 레퍼런스를 얻을 수 있다.

## 1. 자신의 Gallery에서 원하는 사진 가져오기
## 2. 앱 내부 Creator Reference 탐색
## 3. 주변 환경을 카메라로 스캔해서 현재 장소와 어울리는 레퍼런스 추천

MVP에서는 우선 1번부터 구현한다.

즉 사용자가 자신의 Gallery에서 레퍼런스 사진 한 장을 선택하고 그 사진을 재현하는 기능부터 만든다.

## 4. Background Discovery / 주변 배경 기반 사진 추천

장기적으로 앱을 켰을 때 장소 이름을 먼저 선택하는 구조보다 다음 UX를 목표로 한다.

사용자가:

"여기서 뭐 찍지?"

라고 생각할 때 앱을 켠다.

사용자가 현재 주변을 카메라로 보여준다.

가능하면 한 장의 사진만 찍는 것보다 2~3초 동안 주변을 천천히 훑을 수 있는 방식도 고려한다.

AI가 현재 환경에서 다음 특징을 추출한다.

예:

* 카페
* 유리창
* 흰 벽
* 콘크리트
* 계단
* 바다
* 나무
* 잔디
* 건물
* 골목
* 난간
* 의자
* 자연광
* 역광
* 야간
* 실내
* 실외
* 배경 색상
* 수평선
* 주요 구조물
* 인물이 설 수 있는 공간

그리고 Creator Reference Database에서 현재 공간과 잘 어울리는 레퍼런스를 추천한다.

단순한 "이미지 유사도"만 사용하면 안 된다.

장기적으로 추천 Score는 다음 개념을 고려한다.

* Background Similarity
* Lighting Similarity
* Composition Compatibility
* Pose Compatibility
* Reproducibility
* 현재 공간에서 실제 촬영 가능한지
* 사용자 취향
* 선택적으로 Location

즉:

"가장 비슷한 사진"

보다

"현재 이 장소에서 실제로 재현하기 좋으면서 결과가 예쁠 가능성이 높은 사진"

을 추천하는 것이 목표다.

Location/GPS는 메인 검색 조건이 아니라 보조 신호로 사용한다.

현재 단계에서는 이 기능을 MVP 2 이후로 미룬다.

## 5. Creator Reference 시스템

장기적으로 사진 잘 찍는 크리에이터들이 자신의 사진을 앱에 Reference로 등록할 수 있게 한다.

Creator가 Reference를 생성할 때 단순 JPEG만 저장하지 않는다.

가능한 범위에서 촬영 당시 데이터를 함께 저장한다.

예:

* 이미지
* device 정보
* lens
* zoom ratio
* image orientation
* camera pitch
* camera roll
* camera yaw 가능 여부
* person bounding box
* person position in frame
* person size ratio
* pose keypoints
* face direction
* gaze 정보 가능 여부
* lighting/exposure 정보
* focus point
* scene tags
* background embedding
* optional approximate distance
* optional approximate camera height
* creator가 직접 추가한 설명
* 촬영 장소 optional

정확한 실제 거리/높이는 필수가 아니다.

실제 거리보다 이미지상의 목표 상태를 저장하는 것이 더 중요하다.

예:

person_center_x
person_center_y
person_height_ratio
person_width_ratio
pose_keypoints
camera_pitch
camera_roll
zoom

이 데이터만으로도 사용자의 현재 화면과 비교할 수 있도록 설계한다.

장기적으로 Creator Marketplace를 만들 수 있다.

예:

* Creator Pack
* 장소별 Pack
* 포즈 Pack
* 구독
* 유료 Reference
* Creator 수익 배분

하지만 결제/정산/Marketplace는 MVP에서는 구현하지 않는다.

다만 데이터 모델과 문서에는 장기 확장 방향으로 남긴다.

## 6. 실시간 AI Guide Engine

가장 중요한 공통 엔진이다.

Reference 상태와 Current Camera 상태의 차이를 계산해서 사용자에게 가장 중요한 수정사항을 알려준다.

초기 비교 대상:

## 1. Person position
## 2. Person size
## 3. Pose
## 4. Camera tilt
## 5. Zoom
## 6. Face direction 가능하면
## 7. Eye state 가능하면
## 8. Motion / Blur
## 9. Exposure
## 10. Focus

예:

Reference:
person center x = 0.40

Current:
person center x = 0.55

그러면 사용자에게 적절한 좌우 이동 안내를 한다.

Reference:
person height ratio = 0.65

Current:
person height ratio = 0.82

그러면:

"조금 뒤로"

를 안내한다.

실제 meter 단위 거리를 몰라도 된다.

사용자가 이동하면서:

0.82
→ 0.75
→ 0.69
→ 0.66

으로 변하면 목표에 가까워졌다고 판단한다.

이것이 MVP에서 절대거리보다 중요한 방식이다.

## 7. Pose Detection / Pose Matching

Reference Photo에서 사람의 pose keypoints를 추출한다.

Current Camera frame에서도 사람의 pose keypoints를 실시간 추출한다.

가능하면 다음 관절을 사용한다.

* head / nose
* shoulders
* elbows
* wrists
* hips
* knees
* ankles

단순 pixel 좌표 비교만 하지 말고 사람 크기/위치에 영향을 덜 받도록 normalized coordinates와 joint angles를 함께 검토한다.

예:

shoulder angle
elbow angle
hip angle
knee angle
body orientation

등을 이용할 수 있다.

Pose Match Score를 계산한다.

예:

Pose Match 72%
→ 83%
→ 91%

단, 사용자가 숫자를 반드시 볼 필요는 없다.

점수는 내부 판단 및 개발 디버깅용으로 먼저 사용하고 UI에서는 간단한 상태로 표현할 수도 있다.

Pose 가이드는 한 번에 가장 중요한 수정 하나를 우선한다.

예:

"왼팔을 조금 올리세요."

## 8. Composition Matching

Reference와 Current Camera에서 다음을 비교한다.

* person center
* head position
* foot position
* bounding box
* person size ratio
* margin around person
* horizontal composition
* vertical composition
* horizon / major line 가능하면
* camera orientation

Composition Score를 정의한다.

첫 번째 MVP에서는 복잡한 미학 평가보다 Reference와의 일치도를 중심으로 한다.

## 9. Camera Motion / Orientation

스마트폰 센서 데이터를 이용해:

* pitch
* roll
* device orientation
* 움직임
* 흔들림

을 판단한다.

필요하면 Flutter sensor package 또는 native Android sensor API를 사용한다.

Reference와 비교해서:

"카메라를 조금 낮추세요."

"휴대폰을 위로 기울이세요."

"수평을 맞추세요."

같은 가이드를 제공한다.

## 10. Auto Capture

단순 타이머 촬영이 아니다.

AI가 Shot Readiness를 계산하고 가장 좋은 순간에 자동촬영한다.

개념적으로:

Shot Readiness Score =
Composition

* Pose
* Face
* Eyes
* Exposure
* Motion/Blur
* Focus

각 요소에 가중치를 둔다.

첫 MVP에서는 구현 가능한 요소부터 사용한다.

예:

Composition >= threshold
Pose >= threshold
Motion stable
Person detected

조건이 일정 시간 이상 유지되면 촬영한다.

예:

300~700ms 정도 안정적으로 조건 충족

구체적인 값은 실험하면서 조정 가능하게 constant/config로 분리한다.

향후:

* 눈 뜸
* 시선
* 표정
* 얼굴 가림
* motion blur
* focus
* exposure

등을 추가한다.

자동촬영 직전 필요하면:

"좋아요. 그대로."

같은 음성 또는 UI 피드백을 줄 수 있다.

## 11. Focus / Exposure

촬영 후 보정보다 촬영 당시 품질이 더 중요한 항목은 실시간으로 처리한다.

촬영 전에:

* face/person focus
* exposure
* focus point
* underexposure
* overexposure

등을 판단한다.

MVP에서는 Android Camera/Flutter camera plugin이 제공하는 기능 범위에서 구현한다.

가능하면 사람 얼굴 또는 주요 피사체에 초점을 둔다.

## 12. 촬영 후 보정

다음 요소는 대부분 촬영 후 처리한다.

* brightness
* contrast
* saturation
* color temperature
* highlights
* shadows
* tone
* reference color style

즉:

Capture Correctly
→ Match the Look

구조로 설계한다.

MVP 첫 단계에서는 색감 자동 보정을 구현하지 않아도 된다.

추후 Reference와 촬영 결과의 스타일/색감을 비교해 자동 보정한다.

## 13. 기술 전략

Flutter를 메인 UI/Application Layer로 사용한다.

Android 우선이다.

AI/Computer Vision은 먼저 안정적이고 유지되는 라이브러리를 검토한다.

후보:

* Google ML Kit
* MediaPipe
* TensorFlow Lite
* 기타 Flutter에서 안정적으로 사용할 수 있는 maintained package

Pose Detection에는 가능하면 이미 학습된 모델/라이브러리를 활용한다.

처음부터 자체 AI 모델을 학습하지 마라.

Face Detection 역시 기존 모델/라이브러리를 우선 활용한다.

가능하면 온디바이스 처리한다.

이유:

* 낮은 latency
* 카메라 실시간 처리
* 개인정보 보호
* 서버 비용 감소
* 오프라인 사용 가능

단, 나중의 Background Reference Search나 Creator Database는 서버가 필요할 수 있으므로 architecture상 repository/service abstraction을 둔다.

## 14. 성능 원칙

카메라 30fps의 모든 프레임에서 무거운 AI 추론을 돌리지 마라.

예:

카메라 preview는 정상 frame rate 유지

AI inference:
5~15fps 또는 adaptive sampling

으로 분리하는 방법을 고려한다.

추론 중 다음 frame이 계속 queue에 쌓이지 않게 한다.

"현재 inference 중이면 중간 frame drop"

같은 전략을 검토한다.

UI는 항상 반응성이 있어야 한다.

## 15. Privacy

Camera 영상과 사람의 얼굴/몸 데이터를 다루므로 privacy를 중요하게 설계한다.

가능한 경우 분석은 on-device.

카메라 프레임을 서버에 자동 업로드하지 않는다.

향후 서버 업로드가 필요할 경우 명확한 사용자 동의를 전제로 한다.

## 16. MVP 개발 우선순위

절대로 모든 기능을 한 번에 구현하지 마라.

다음 순서로 진행한다.

---

## PHASE 0 — 개발 환경 확인

현재 Ubuntu 환경을 확인한다.

다음을 점검한다.

* Flutter 설치 여부
* Flutter 버전 확인 (실행 명령은 루트 RUNBOOK 참조)
* Dart
* Java/JDK
* Android SDK
* adb
* Android device 연결 여부
* Android emulator 가능 여부
* Git
* VS Code Flutter/Dart extension 필요 여부

설치되어 있지 않은 것이 있다면 정확한 설치 방법을 안내한다.

위험하거나 큰 시스템 변경을 임의로 하지 마라.

무엇을 설치하는지 초보자가 이해할 수 있게 설명한다.

---

## PHASE 1 — Flutter 프로젝트 생성

현재 작업 폴더가 비어 있다면 적절한 Flutter 프로젝트를 생성한다.

임시 프로젝트명:

ai_photographer

를 사용해도 된다.

이미 파일이 존재한다면 덮어쓰지 말고 먼저 확인한다.

Git repository도 초기화할 수 있다.

---

## PHASE 2 — 제품 문서 작성

코드 전에 반드시 docs 폴더를 만들고 다음 문서를 작성한다.

README.md

docs/PRODUCT_SPEC.md

* 전체 제품 설명
* 사용자 문제
* 핵심 가치
* 전체 촬영 모드
* 장기 기능

docs/MVP.md

* 최초 MVP 범위
* 넣는 기능
* 일부러 제외하는 기능

docs/ARCHITECTURE.md

* Flutter architecture
* AI pipeline
* camera pipeline
* guide engine
* future two-phone communication

docs/DATA_MODELS.md

* ReferencePhoto
* PoseData
* CameraState
* GuideInstruction
* ShotReadiness
* CreatorReference
  등

docs/ROADMAP.md

* Phase 0부터 장기 기능까지

docs/TEST_PLAN.md

* 기능별 테스트 방법
* 실제 사진 테스트 계획

docs/DECISIONS.md

* 중요한 기술/제품 의사결정 기록

중요:

지금 이 프롬프트에 적힌 제품 아이디어를 요약하다가 기능을 누락하지 마라.

전체 아이디어는 PRODUCT_SPEC에 보존한다.

---

## PHASE 3 — 가장 작은 실행 가능한 앱

먼저 다음만 구현한다.

앱 실행

→ Home Screen

Home에는 최소한 다음을 보여준다.

"AI Photographer"

그리고 촬영 모드:

* 둘이 찍기
* 혼자 찍기
* 셀카

단 첫 MVP에서는 "둘이 찍기"만 실제 구현되어 있어도 된다.

나머지는 Coming Soon이어도 된다.

---

## PHASE 4 — Reference 선택

Gallery에서 Reference Photo 한 장을 선택할 수 있게 한다.

Reference Preview 화면을 만든다.

"이 사진처럼 찍기"

버튼으로 Camera 화면으로 이동한다.

---

## PHASE 5 — Camera Preview

Android Camera를 정상적으로 실행한다.

실시간 camera preview.

필요한 permission 처리.

사진 촬영.

Gallery 또는 앱 저장 영역에 결과 저장.

여기까지 먼저 안정적으로 동작시키고 build/test한다.

---

## PHASE 6 — Person / Pose Detection

실시간 camera frame에서 person pose를 검출한다.

처음에는 Debug Mode에서 skeleton/keypoints를 화면에 그린다.

Reference Photo에서도 pose를 추출한다.

Reference와 Current Pose를 저장한다.

---

## PHASE 7 — Composition Matching

먼저 아주 간단하게:

* person center
* person bounding box
* person height ratio

를 비교한다.

그리고:

LEFT
RIGHT
FORWARD
BACK

또는 한국어:

왼쪽
오른쪽
앞으로
뒤로

가이드를 제공한다.

정확한 meter는 계산하지 않는다.

---

## PHASE 8 — Pose Matching

Reference Pose와 Current Pose를 비교한다.

Pose Score를 계산한다.

가장 큰 차이가 나는 관절을 찾아 간단한 가이드를 제공한다.

---

## PHASE 9 — Orientation

Device sensor를 이용해:

pitch
roll

등을 읽는다.

카메라 기울기 가이드를 추가한다.

---

## PHASE 10 — Auto Capture

처음에는:

Composition Match
Pose Match
Motion stability

만 이용해 Shot Ready 판단을 한다.

조건이 일정 시간 유지되면 자동촬영한다.

---

## PHASE 11 — Solo Tripod Mode

둘이 찍기 기능이 안정화된 뒤 추가한다.

후면카메라 + pose/composition 분석.

TTS Voice Coaching.

Bluetooth 이어폰이 연결되어 있다면 시스템 오디오 경로를 사용해 이어폰으로 안내가 전달될 수 있도록 한다.

짧은 명령 중심.

자동촬영.

---

## PHASE 12 — Model Phone

두 스마트폰 연결.

가능한 기술 후보를 조사한 후 선택한다.

후보:

* local Wi-Fi
* WebRTC
* WebSocket
* Nearby/Android local connectivity 등

MVP에서는 같은 Wi-Fi 또는 local network 연결부터 고려해도 된다.

촬영자 phone:
Camera Host

모델 phone:
Viewer / Model Coach

모델에게 low-latency preview를 전송한다.

모델 포즈 가이드를 별도로 제공한다.

촬영 직후 preview 공유.

Retake 요청.

---

## PHASE 13 — Background Recommendation

현재 주변을 Camera로 스캔.

Scene features / embeddings 생성.

Reference Database의 embedding과 비교.

Top N Reference 추천.

장기적으로 Reproducibility Score 추가.

---

## PHASE 14 — Creator Platform

Creator upload.

Metadata.

Reference packs.

Backend.

Account.

결제.

Revenue share.

이 기능들은 시장 검증 후 개발한다.

## 17. 첫 번째 MVP에서 반드시 제외할 것

처음부터 다음을 구현하지 마라.

* 정확한 cm/m 거리 측정
* 3D 공간 전체 reconstruction
* LiDAR 의존
* 복잡한 backend
* 회원가입
* 결제
* Creator 정산
* SNS 기능
* 전체 Marketplace
* 모든 Android 기기 최적화
* iOS 빌드
* 완벽한 AI 미학 평가
* 자체 AI 모델 학습
* 복잡한 자동 색감 보정

핵심 검증은:

"레퍼런스 한 장을 선택하고, 앱의 지시를 따라 움직였을 때 일반인이 그 레퍼런스와 더 비슷한 사진을 쉽게 찍을 수 있는가?"

이다.

## 18. 코드 구조 원칙

초보자가 이해할 수 있지만 확장 가능한 구조를 사용한다.

가능하면 feature-first 구조를 검토한다.

예:

lib/
app/
core/
camera/
ml/
sensors/
audio/
utils/
features/
home/
reference/
capture/
pose_guide/
solo_mode/
model_mode/
selfie/
domain/
models/
services/

실제 필요에 따라 더 나은 구조가 있으면 수정해도 된다.

단 변경 이유를 문서화한다.

UI 코드 안에 ML 로직을 직접 넣지 마라.

Camera / Pose / Guide Logic을 분리한다.

예:

CameraService
PoseDetectionService
PoseMatchingService
CompositionMatchingService
GuideEngine
ShotReadinessEngine

같은 역할 분리를 고려한다.

## 19. Guide Engine 설계

GuideInstruction 모델을 만든다.

예:

enum GuideType {
moveLeft,
moveRight,
moveForward,
moveBackward,
cameraUp,
cameraDown,
tiltUp,
tiltDown,
rotateLeft,
rotateRight,
zoomIn,
zoomOut,
raiseLeftArm,
lowerLeftArm,
raiseRightArm,
lowerRightArm,
turnHeadLeft,
turnHeadRight,
chinDown,
chinUp,
hold,
ready
}

각 instruction은:

* type
* priority
* magnitude optional
* confidence
* Korean message
* English message optional

을 가질 수 있도록 고려한다.

사용자 화면에는 여러 instruction을 동시에 던지지 말고 priority가 가장 높은 1~2개만 보여준다.

## 20. 디버그 모드

개발 중에는 반드시 Debug Overlay를 만들 수 있게 설계한다.

표시 후보:

* FPS
* inference FPS
* person bounding box
* pose keypoints
* Composition Score
* Pose Score
* Shot Readiness
* pitch
* roll
* current instruction
* inference latency

실제 사용자 Release Mode에서는 숨길 수 있게 한다.

## 21. Test 방법

처음에는 실제 사람 한 명 + Reference 한 장으로 테스트한다.

예:

Reference의 사람 위치:
center

현재 사람:
오른쪽

→ LEFT/RIGHT instruction이 올바른지 확인.

사람이 너무 크게 보임
→ BACK instruction 확인.

Pose:
왼팔이 reference보다 낮음
→ raiseLeftArm 확인.

최종적으로:

일반 기본 카메라

vs

AI Photographer

로 같은 Reference를 따라 찍고 결과 비교가 가능하게 한다.

장기 사용자 테스트:

약 20명 정도에게 사용시켜:

* 찍기 쉬웠는가
* Reference와 비슷해졌는가
* 지시가 이해하기 쉬웠는가
* 지시가 너무 많지 않았는가
* Auto Capture가 자연스러웠는가

등을 확인한다.

## 26. 절대 하지 말아야 할 것

* 제품 요구사항을 임의로 크게 축소하지 마라.
* 전체 아이디어 문서화 과정에서 기능을 누락하지 마라.
* 처음부터 전체 기능을 구현해서 코드베이스를 망가뜨리지 마라.
* 가짜로 "AI가 된다"고 표시만 하지 마라.
* 작동하지 않는 placeholder를 실제 구현처럼 말하지 마라.
* build/test하지 않고 완료됐다고 말하지 마라.
* macOS/Xcode가 있다고 가정하지 마라.
* 정확한 거리 측정이 핵심이라고 가정하지 마라.
* 위치 기반 서비스가 핵심이라고 가정하지 마라.
* 유료 backend/API를 불필요하게 사용하지 마라.
* 처음부터 사용자 계정이나 서버를 만들지 마라.
* 내가 초보라는 이유로 지나치게 단순한 toy project를 만들지 마라.

## 27. 제품에서 가장 중요한 원칙

이 제품의 핵심은:

"정확한 실제 거리 측정"

이 아니다.

핵심은:

"현재 카메라 화면을 지속적으로 분석해서 사용자가 Reference에 가까워지도록 실시간으로 안내하는 것"

이다.

그리고 장기적인 핵심 경험은:

주변을 보여준다
→ 여기에서 찍기 좋은 사진을 추천
→ Reference 선택
→ 촬영자 AI 가이드
→ 모델 AI 가이드
→ Solo라면 이어폰 Voice Coaching
→ 좋은 순간 판단
→ Auto Capture
→ 즉시 결과 확인
→ 필요하면 재촬영
→ 색감 보정

이다.

## 28. 최종 목표

사용자는 사진 기술을 몰라도 된다.

사용자는:

"나는 이 사진처럼 찍고 싶다."

또는:

"여기서 어떻게 찍어야 예쁜지 모르겠다."

만 생각하면 된다.

앱이:

"어디에서 찍을지"
"카메라를 어떻게 둘지"
"사람이 어디에 설지"
"어떤 포즈를 취할지"
"언제 찍어야 할지"

를 대신 판단한다.

이 전체 경험을 AI Photographer라고 정의한다.

지금부터 우선 환경 확인과 프로젝트 초기화부터 시작하고, 첫 번째 실행 가능한 Android Flutter 앱까지 진행해라.

작업 중 중요한 기술적 선택이 필요한 경우 최종 제품 방향을 깨지 않는 선에서 가장 현실적이고 유지보수하기 좋은 방법을 선택하고, 그 이유를 docs/DECISIONS.md에 기록해라.
