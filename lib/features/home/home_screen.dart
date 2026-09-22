import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/reference_service.dart';
import '../reference/reference_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.referenceService});

  final ReferenceService referenceService;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _recovering = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _recover());
  }

  Future<void> _recover() async {
    if (!mounted) return;
    try {
      final recovered = await widget.referenceService.recover();
      if (!mounted) return;
      if (recovered != null) _openReference(recovered);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('이전 사진 선택을 복구하지 못했습니다. 다시 선택해 주세요.')),
        );
      }
    } finally {
      if (mounted) setState(() => _recovering = false);
    }
  }

  void _openReference([XFile? recovered]) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ReferenceScreen(
          service: widget.referenceService,
          initialPhoto: recovered,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Photographer')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Icon(Icons.photo_camera_outlined, size: 64),
          const SizedBox(height: 24),
          Text(
            '이 사진처럼 찍고 싶어요',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          const Text('마음에 드는 사진을 골라 촬영을 시작하세요.'),
          const SizedBox(height: 32),
          Card(
            child: ListTile(
              leading: const Icon(Icons.people_outline),
              title: const Text('둘이 찍기'),
              subtitle: const Text('레퍼런스 선택하고 촬영하기'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _recovering ? null : () => _openReference(),
            ),
          ),
          const Card(
            child: ListTile(
              enabled: false,
              leading: Icon(Icons.accessibility_new),
              title: Text('혼자 찍기'),
              subtitle: Text('준비 중 · 삼각대와 음성 안내'),
            ),
          ),
          const Card(
            child: ListTile(
              enabled: false,
              leading: Icon(Icons.face_outlined),
              title: Text('셀카'),
              subtitle: Text('준비 중 · 얼굴과 구도 안내'),
            ),
          ),
          const SizedBox(height: 24),
          const Text('현재는 레퍼런스 선택과 수동 촬영을 지원합니다.\nAI 안내와 자동촬영은 추후 제공됩니다.'),
        ],
      ),
    );
  }
}
