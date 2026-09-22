import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

import 'photo_store.dart';

/// Serializes camera initialization and disposal across lifecycle changes.
class CameraService extends ChangeNotifier {
  CameraController? _controller;
  CameraController? get controller => _controller;
  String? error;
  bool takingPicture = false;
  bool _active = false;
  bool _disposed = false;
  Future<void> _pending = Future<void>.value();

  Future<void> setActive(bool active) {
    if (_disposed) return Future<void>.value();
    _active = active;
    _pending = _pending.then((_) => _synchronize());
    return _pending;
  }

  Future<void> retry() {
    error = null;
    return setActive(true);
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  Future<void> _close() async {
    final old = _controller;
    _controller = null;
    _notify();
    await old?.dispose();
  }

  Future<void> _synchronize() async {
    CameraController? candidate;
    try {
      if (_disposed || !_active) {
        await _close();
        return;
      }
      // A permission dialog also pauses/resumes the app. Do not turn a denial
      // into another permission request when that queued resume is processed.
      if (_controller != null || error != null) return;
      error = null;
      _notify();
      final cameras = await availableCameras();
      if (_disposed || !_active) return;
      final rear = cameras.where(
        (c) => c.lensDirection == CameraLensDirection.back,
      );
      if (rear.isEmpty) {
        error = '후면 카메라를 찾을 수 없습니다.';
        _notify();
        return;
      }
      candidate = CameraController(
        rear.first,
        ResolutionPreset.high,
        enableAudio: false,
      );
      await candidate.initialize();
      if (_disposed || !_active) {
        await candidate.dispose();
        return;
      }
      _controller = candidate;
      _notify();
    } on CameraException catch (exception) {
      await candidate?.dispose();
      error =
          exception.code.startsWith('CameraAccessDenied') ||
              exception.code == 'CameraAccessRestricted'
          ? '카메라 권한이 필요합니다. 휴대폰 설정에서 권한을 허용한 뒤 다시 시도해 주세요.'
          : '카메라를 열 수 없습니다. 다른 카메라 앱을 닫고 다시 시도해 주세요.';
      _notify();
    } catch (_) {
      await candidate?.dispose();
      error = '카메라를 준비하지 못했습니다. 다시 시도해 주세요.';
      _notify();
    }
  }

  Future<String> capture() async {
    final current = _controller;
    if (!_active ||
        current == null ||
        !current.value.isInitialized ||
        takingPicture) {
      throw StateError('Camera is not ready.');
    }
    takingPicture = true;
    _notify();
    try {
      final image = await current.takePicture();
      return await PhotoStore().save(image);
    } finally {
      takingPicture = false;
      _notify();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _active = false;
    unawaited(_pending.then((_) => _close()));
    super.dispose();
  }
}
