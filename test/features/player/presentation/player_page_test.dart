import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:one_shelf/src/features/player/presentation/player_page.dart';

void main() {
  testWidgets('player page exposes variable horizontal seek gesture', (
    tester,
  ) async {
    Duration? capturedSeek;

    await tester.pumpWidget(
      MaterialApp(
        home: PlayerPage(
          title: 'Test Movie',
          total: const Duration(minutes: 100),
          onSeekRelative: (value) => capturedSeek = value,
        ),
      ),
    );

    await tester.drag(
      find.byKey(const Key('player-gesture-layer')),
      const Offset(220, 0),
      warnIfMissed: false,
    );
    await tester.pump();

    expect(capturedSeek, isNotNull);
    expect(capturedSeek!.inSeconds, greaterThan(0));
  });

  testWidgets('player page explains swipe seek gesture', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: PlayerPage(title: 'Test Movie')),
    );

    expect(
      find.textContaining('Swipe left or right for variable seek'),
      findsOneWidget,
    );
  });
}
