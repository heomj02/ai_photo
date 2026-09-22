# 데이터 모델 설계

이 문서는 단계별 설계 계약이다. 현재 기본 촬영 단계에서 필요하지 않은 모델은
코드로 미리 만들지 않는다. 신뢰도·점수는 0–1, 이미지 좌표는 회전 보정 후
좌상단 (0,0), 우하단 (1,1), 각도는 radians로 통일한다.
알 수 없는 값은 null/unknown으로 남기며, 추후 저장 포맷에 schemaVersion을 둔다.

| 모델 | 주요 필드와 의미 |
| --- | --- |
| ReferencePhoto | id, localImagePath, source(gallery/creator), pixelWidth/Height, orientation, createdAt, optional pose/composition/cameraMetadata |
| PoseData | frameTimestamp, imageSize, landmark 좌표와 confidence, person boundingBox, normalizedKeypoints, jointAngles, detectionConfidence |
| CameraState | timestamp, lensDirection, zoomRatio, previewSize, imageRotation, mirrored, optional pitch/roll/yaw, movement, exposure, focus, currentPose |
| GuideInstruction | type, audience(photographer/model/solo), priority, optional magnitude, confidence, koreanMessage, optional englishMessage, timestamp |
| ShotReadiness | compositionScore, poseScore, motionStable, personDetected, optional face/eyes/exposure/focus/blur, stableSince, readinessScore, blockingReason, state |
| CreatorReference | ReferencePhoto, creatorId, device, lens, zoom, orientation, pitch/roll/optional yaw, personCenter/size, pose, faceDirection, optional gaze, lighting/exposure, focusPoint, sceneTags, backgroundEmbedding, optional approximateDistance/cameraHeight/location, creatorNotes, optional packId/accessType |
| CaptureResult | localImagePath, capturedAt, optional referenceId/matchScores, reviewState |
| DiscoveryCandidate | referenceId, backgroundSimilarity, lightingSimilarity, compositionCompatibility, poseCompatibility, reproducibility, preferenceScore, optional locationSignal |
| ModelSession（후속） | sessionId, host/viewer role, connectionState, referenceId, frameTimestamp, latestGuide, resultPreview, retakeRequest |

Pose landmarks는 nose/head, 좌우 shoulder/elbow/wrist/hip/knee/ankle을 기본으로 한다.
인물이 잘리거나 confidence가 낮은 관절은 비교에서 제외한다. 좌우는 모델의 해부학적
좌우로 정의하고, 화면 이동 지시와 별개로 변환한다. 좌우 정책은 실제 테스트로 검증한다.
갤러리 사진에는 카메라 pitch/roll/zoom 등의 원본 값이 없을 수 있다.

GuideType 후보:

```text
moveLeft, moveRight, moveForward, moveBackward,
cameraUp, cameraDown, tiltUp, tiltDown, rotateLeft, rotateRight,
zoomIn, zoomOut, raiseLeftArm, lowerLeftArm, raiseRightArm, lowerRightArm,
turnHeadLeft, turnHeadRight, chinDown, chinUp, hold, ready
```

UI는 가장 높은 우선순위 한 개를 기본으로 보여주며 필요 시 최대 두 개다.
‘조금 더’, ‘좋습니다’, ‘그대로’, ‘1x/2x’는 지원되는 상황에서만 출력한다.
Readiness는 미검출 → 조정 중 → 안정성 유지 → 촬영 중 → 결과 확인 흐름으로 설계한다.
가중치·점수 임계값·300–700ms 유지시간은 실험용 설정으로 분리한다.
Creator 팩, 구독, 유료 Reference, 수익 배분 모델은 후속 설계이며 지금 결제를 구현하지 않는다.
