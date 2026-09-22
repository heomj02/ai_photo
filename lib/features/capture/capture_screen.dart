import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../core/camera_service.dart';
import '../../core/local_photo.dart';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({super.key, required this.referencePath});

  final String referencePath;

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen>
    with WidgetsBindingObserver {
  final CameraService _camera = CameraService();
  String? _result;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_camera.setActive(true));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    unawaited(
      _camera.setActive(state == AppLifecycleState.resumed && _result == null),
    );
  }

  Future<void> _capture() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final path = await _camera.capture();
      if (!mounted) return;
      setState(() => _result = path);
      await _camera.setActive(false);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('촬영하거나 저장하지 못했습니다. 저장 공간과 카메라 상태를 확인해 주세요.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _camera.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_result == null ? '둘이 찍기' : '촬영 결과')),
      body: SafeArea(child: _result != null ? _buildResult() : _buildCamera()),
    );
  }

  Widget _buildResult() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: LocalPhoto(path: _result!)),
          const SizedBox(height: 16),
          const Text('사진을 앱 전용 공간에 저장했습니다.\n갤러리에는 표시되지 않으며 앱을 삭제하면 함께 삭제됩니다.'),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _busy
                ? null
                : () {
                    setState(() => _result = null);
                    unawaited(_camera.setActive(true));
                  },
            child: const Text('다시 촬영'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('레퍼런스로 돌아가기'),
          ),
        ],
      ),
    );
  }

  Widget _buildCamera() {
    return ListenableBuilder(
      listenable: _camera,
      builder: (context, _) {
        final controller = _camera.controller;
        final ready = controller != null && controller.value.isInitialized;
        return Column(
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (ready)
                    Center(child: CameraPreview(controller))
                  else if (_camera.error != null)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(_camera.error!),
                            TextButton(
                              onPressed: _camera.retry,
                              child: const Text('다시 시도'),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    const Center(child: CircularProgressIndicator()),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Card(
                      child: SizedBox(
                        width: 96,
                        height: 132,
                        child: Column(
                          children: [
                            const Text('레퍼런스'),
                            Expanded(
                              child: LocalPhoto(path: widget.referencePath),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: FilledButton.icon(
                onPressed: ready && !_busy && !_camera.takingPicture
                    ? _capture
                    : null,
                icon: const Icon(Icons.camera_alt),
                label: Text(_busy ? '사진 저장 중…' : '사진 촬영'),
              ),
            ),
          ],
        );
      },
    );
  }
}
