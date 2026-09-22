import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ai_photographer/app/app.dart';
import 'package:ai_photographer/core/reference_service.dart';
import 'package:ai_photographer/features/reference/reference_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

class FakeReferenceService extends ReferenceService {
  XFile? selected;
  XFile? recovered;
  bool fail = false;
  Completer<XFile?>? pending;
  int picks = 0;

  @override
  Future<XFile?> pick() async {
    picks++;
    if (fail) throw StateError('Picker unavailable');
    return pending == null ? selected : pending!.future;
  }

  @override
  Future<XFile?> recover() async => recovered;
}

void main() {
  late Directory fixtureDirectory;
  late XFile fixture;

  setUpAll(() async {
    fixtureDirectory = await Directory.systemTemp.createTemp('photo-test-');
    final file = File('${fixtureDirectory.path}/reference.png');
    await file.writeAsBytes(
      base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+jRZkAAAAASUVORK5CYII=',
      ),
    );
    fixture = XFile(file.path);
  });

  tearDownAll(() => fixtureDirectory.delete(recursive: true));

  testWidgets('Home opens reference and future modes are disabled', (
    tester,
  ) async {
    await tester.pumpWidget(
      AiPhotographerApp(referenceService: FakeReferenceService()),
    );
    await tester.pumpAndSettle();
    expect(find.text('AI Photographer'), findsOneWidget);
    for (final mode in ['혼자 찍기', '셀카']) {
      final tile = tester.widget<ListTile>(find.widgetWithText(ListTile, mode));
      expect(tile.enabled, isFalse);
      expect(tile.onTap, isNull);
    }
    await tester.tap(find.text('둘이 찍기'));
    await tester.pumpAndSettle();
    expect(find.text('레퍼런스 선택'), findsOneWidget);
    expect(find.text('이 사진처럼 찍기'), findsNothing);
  });

  testWidgets('Cancel leaves the empty selection unchanged', (tester) async {
    final service = FakeReferenceService();
    await tester.pumpWidget(
      MaterialApp(home: ReferenceScreen(service: service)),
    );
    await tester.tap(find.text('갤러리에서 사진 선택'));
    await tester.pumpAndSettle();
    expect(service.picks, 1);
    expect(find.text('이 사진처럼 찍기'), findsNothing);
    expect(find.textContaining('가져오지 못했습니다'), findsNothing);
  });

  testWidgets(
    'Selected photo enables capture and survives a cancelled replacement',
    (tester) async {
      final service = FakeReferenceService()..selected = fixture;
      await tester.pumpWidget(
        MaterialApp(home: ReferenceScreen(service: service)),
      );
      await tester.tap(find.text('갤러리에서 사진 선택'));
      await tester.pumpAndSettle();
      expect(find.text('이 사진처럼 찍기'), findsOneWidget);
      service.selected = null;
      await tester.tap(find.text('갤러리에서 사진 선택'));
      await tester.pumpAndSettle();
      expect(find.text('이 사진처럼 찍기'), findsOneWidget);
    },
  );

  testWidgets('Picker failure offers retry without capture', (tester) async {
    final service = FakeReferenceService()..fail = true;
    await tester.pumpWidget(
      MaterialApp(home: ReferenceScreen(service: service)),
    );
    await tester.tap(find.text('갤러리에서 사진 선택'));
    await tester.pumpAndSettle();
    expect(find.textContaining('가져오지 못했습니다'), findsOneWidget);
    expect(find.text('이 사진처럼 찍기'), findsNothing);
    service.fail = false;
    await tester.tap(find.text('갤러리에서 사진 선택'));
    await tester.pumpAndSettle();
    expect(find.textContaining('가져오지 못했습니다'), findsNothing);
  });

  testWidgets(
    'Pending picker is disabled and completion after disposal is safe',
    (tester) async {
      final service = FakeReferenceService()..pending = Completer<XFile?>();
      await tester.pumpWidget(
        MaterialApp(home: ReferenceScreen(service: service)),
      );
      await tester.tap(find.text('갤러리에서 사진 선택'));
      await tester.pump();
      final button = tester.widget<OutlinedButton>(find.byType(OutlinedButton));
      expect(button.onPressed, isNull);
      await tester.pumpWidget(const SizedBox());
      service.pending!.complete(fixture);
      await tester.pump();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Lost picker result opens reference preview on app startup', (
    tester,
  ) async {
    final service = FakeReferenceService()..recovered = fixture;
    await tester.pumpWidget(AiPhotographerApp(referenceService: service));
    await tester.pumpAndSettle();
    expect(find.text('레퍼런스 선택'), findsOneWidget);
    expect(find.text('이 사진처럼 찍기'), findsOneWidget);
  });
}
