import 'dart:io';

import 'package:flutter/material.dart';

class LocalPhoto extends StatelessWidget {
  const LocalPhoto({super.key, required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return Image.file(
      File(path),
      fit: BoxFit.contain,
      cacheWidth: 1600,
      errorBuilder: (context, error, stackTrace) =>
          const Center(child: Text('사진을 표시할 수 없습니다. 다른 사진을 선택해 주세요.')),
    );
  }
}
