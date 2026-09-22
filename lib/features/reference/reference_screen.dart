import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/local_photo.dart';
import '../../core/reference_service.dart';
import '../capture/capture_screen.dart';

class ReferenceScreen extends StatefulWidget {
  const ReferenceScreen({super.key, required this.service, this.initialPhoto});

  final ReferenceService service;
  final XFile? initialPhoto;

  @override
  State<ReferenceScreen> createState() => _ReferenceScreenState();
}

class _ReferenceScreenState extends State<ReferenceScreen> {
  XFile? _photo;
  bool _picking = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _photo = widget.initialPhoto;
  }

  Future<void> _pick() async {
    if (_picking) return;
    setState(() {
      _picking = true;
      _error = null;
    });
    try {
      final photo = await widget.service.pick();
      if (mounted && photo != null) setState(() => _photo = photo);
    } catch (_) {
      if (mounted) setState(() => _error = '사진을 가져오지 못했습니다. 다시 선택해 주세요.');
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('레퍼런스 선택')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('어떤 사진을 찍고 싶나요?'),
              const SizedBox(height: 16),
              Expanded(
                child: _photo == null
                    ? const Center(
                        child: Text('갤러리에서 따라 찍고 싶은 사진 한 장을 골라 주세요.'),
                      )
                    : LocalPhoto(path: _photo!.path),
              ),
              if (_error != null)
                Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _picking ? null : _pick,
                icon: const Icon(Icons.photo_library_outlined),
                label: Text(_picking ? '사진 불러오는 중…' : '갤러리에서 사진 선택'),
              ),
              if (_photo != null)
                FilledButton(
                  onPressed: _picking
                      ? null
                      : () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) =>
                                  CaptureScreen(referencePath: _photo!.path),
                            ),
                          );
                        },
                  child: const Text('이 사진처럼 찍기'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
