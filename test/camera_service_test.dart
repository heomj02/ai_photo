import 'dart:async';

import 'package:ai_photographer/core/camera_service.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeCameraPlatform extends CameraPlatform {
  final events = StreamController<CameraInitializedEvent>.broadcast();
  final errors = StreamController<CameraErrorEvent>.broadcast();
  Completer<void>? initialization;
  final initializationStarted = Completer<void>();
  bool denied = false;
  bool noCamera = false;
  int created = 0;
  int permissionChecks = 0;
  final List<int> closed = [];

  @override
  Future<List<CameraDescription>> availableCameras() async {
    permissionChecks++;
    if (denied) throw CameraException('CameraAccessDenied', 'Denied');
    return noCamera
        ? []
        : [
            const CameraDescription(
              name: 'back',
              lensDirection: CameraLensDirection.back,
              sensorOrientation: 90,
            ),
          ];
  }

  @override
  Future<int> createCamera(
    CameraDescription cameraDescription,
    ResolutionPreset? resolutionPreset, {
    bool enableAudio = false,
  }) async => ++created;

  @override
  Stream<DeviceOrientationChangedEvent> onDeviceOrientationChanged() =>
      const Stream.empty();

  @override
  Stream<CameraInitializedEvent> onCameraInitialized(int cameraId) =>
      events.stream.where((event) => event.cameraId == cameraId);

  @override
  Stream<CameraErrorEvent> onCameraError(int cameraId) => errors.stream;

  @override
  Future<void> initializeCamera(
    int cameraId, {
    ImageFormatGroup imageFormatGroup = ImageFormatGroup.unknown,
  }) async {
    if (!initializationStarted.isCompleted) initializationStarted.complete();
    await initialization?.future;
    events.add(
      CameraInitializedEvent(
        cameraId,
        640,
        480,
        ExposureMode.auto,
        true,
        FocusMode.auto,
        true,
      ),
    );
  }

  @override
  Future<void> dispose(int cameraId) async => closed.add(cameraId);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late CameraPlatform original;
  late FakeCameraPlatform platform;
  late CameraService service;

  setUp(() {
    original = CameraPlatform.instance;
    platform = FakeCameraPlatform();
    CameraPlatform.instance = platform;
    service = CameraService();
  });

  tearDown(() async {
    await service.setActive(false);
    service.dispose();
    await Future<void>.delayed(Duration.zero);
    // Error streams stay open, matching the native event bus lifetime.
    CameraPlatform.instance = original;
  });

  test(
    'Pausing releases camera and resuming creates a new controller',
    () async {
      await service.setActive(true);
      expect(service.controller!.value.isInitialized, isTrue);
      await service.setActive(false);
      expect(service.controller, isNull);
      expect(platform.closed, [1]);
      await service.setActive(true);
      expect(platform.created, 2);
      expect(service.controller!.value.isInitialized, isTrue);
    },
  );

  test(
    'Pause during initialization never publishes the stale controller',
    () async {
      platform.initialization = Completer<void>();
      final opening = service.setActive(true);
      await platform.initializationStarted.future;
      final closing = service.setActive(false);
      platform.initialization!.complete();
      await Future.wait([opening, closing]);
      expect(service.controller, isNull);
      expect(platform.closed, [1]);
    },
  );

  test('Rapid initialization requests create only one camera', () async {
    await Future.wait([service.setActive(true), service.setActive(true)]);
    expect(platform.created, 1);
  });

  test(
    'Permission failure can be retried after permission is granted',
    () async {
      platform.denied = true;
      await service.setActive(true);
      expect(service.error, contains('권한'));
      expect(service.controller, isNull);
      platform.denied = false;
      await service.retry();
      expect(service.error, isNull);
      expect(service.controller, isNotNull);
    },
  );

  test('Missing rear camera reports an error and cannot capture', () async {
    platform.noCamera = true;
    await service.setActive(true);
    expect(service.error, contains('후면 카메라'));
    await expectLater(service.capture(), throwsStateError);
  });

  test(
    'Resume after a denied permission dialog does not request again',
    () async {
      platform.denied = true;
      await Future.wait([service.setActive(true), service.setActive(true)]);
      expect(platform.permissionChecks, 1);
      expect(service.error, contains('권한'));
    },
  );
}
