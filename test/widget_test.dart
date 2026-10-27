import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aurora_flow/app.dart';
import 'package:aurora_flow/screens/depth_screen.dart';
import 'package:aurora_flow/screens/home_screen.dart';
import 'package:aurora_flow/screens/motion_screen.dart';
import 'package:aurora_flow/screens/palette_screen.dart';
import 'package:aurora_flow/screens/pulse_screen.dart';
import 'package:aurora_flow/theme/app_theme.dart';

Future<void> openHome(WidgetTester tester) async {
  await tester.pumpWidget(const AuroraFlowApp());
  await tester.pump(const Duration(milliseconds: 400));
  await tester.tap(find.text('Skip'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 700));
}

void main() {
  testWidgets('onboarding leads into the aurora shell', (tester) async {
    await tester.pumpWidget(const AuroraFlowApp());
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('A small\nFlutter study'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);

    await tester.tap(find.text('Skip'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('Aurora Flow'), findsOneWidget);
    expect(find.text('Worlds'), findsOneWidget);
    expect(find.text('Design in\nmotion'), findsOneWidget);
  });

  testWidgets('bottom navigation switches to the pulse screen', (tester) async {
    await openHome(tester);

    await tester.tap(find.byKey(const ValueKey('nav-Pulse')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('BREATHING'), findsOneWidget);
  });

  testWidgets('all screens lay out on a compact phone', (tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final screens = <Widget>[
      HomeScreen(onOpenTab: (_) {}, onOpenPalette: () {}),
      const MotionScreen(),
      const PulseScreen(),
      const DepthScreen(),
      const PaletteScreen(),
    ];

    for (final screen in screens) {
      await tester.pumpWidget(MaterialApp(theme: buildTheme(), home: screen));
      await tester.pump(const Duration(milliseconds: 500));
      expect(
        tester.takeException(),
        isNull,
        reason: 'first frame of ${screen.runtimeType} overflowed',
      );

      await tester.drag(find.byType(ListView).first, const Offset(0, -2200));
      await tester.pump(const Duration(milliseconds: 300));
      expect(
        tester.takeException(),
        isNull,
        reason: 'scrolled ${screen.runtimeType} overflowed',
      );
    }
  });
}
