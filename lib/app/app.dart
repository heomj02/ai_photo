import 'package:flutter/material.dart';

import '../core/reference_service.dart';
import '../features/home/home_screen.dart';

class AiPhotographerApp extends StatelessWidget {
  const AiPhotographerApp({super.key, this.referenceService});

  final ReferenceService? referenceService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Photographer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF365C54)),
        useMaterial3: true,
      ),
      home: HomeScreen(
        referenceService: referenceService ?? ReferenceService(),
      ),
    );
  }
}
