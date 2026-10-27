import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';
import '../utils/motion_route.dart';
import '../widgets/morph_bottom_nav.dart';
import 'depth_screen.dart';
import 'home_screen.dart';
import 'motion_screen.dart';
import 'palette_screen.dart';
import 'pulse_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  static const _items = <NavItem>[
    NavItem(Icons.auto_awesome_outlined, 'Home'),
    NavItem(Icons.gesture_rounded, 'Motion'),
    NavItem(Icons.circle_outlined, 'Pulse'),
    NavItem(Icons.layers_outlined, 'Depth'),
  ];

  int _index = 0;
  int _direction = 1;

  void _setTab(int index) {
    if (index == _index) return;
    setState(() {
      _direction = index > _index ? 1 : -1;
      _index = index;
    });
  }

  void _openPalette() {
    Navigator.of(context).push(motionRoute(const PaletteScreen()));
  }

  Widget _screenFor(int index) {
    switch (index) {
      case 1:
        return const MotionScreen();
      case 2:
        return const PulseScreen();
      case 3:
        return const DepthScreen();
      default:
        return HomeScreen(onOpenTab: _setTab, onOpenPalette: _openPalette);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.background,
      ),
      child: Scaffold(
        extendBody: true,
        body: Stack(
          children: [
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 480),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(0.05 * _direction, 0.015),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: KeyedSubtree(
                  key: ValueKey(_index),
                  child: _screenFor(_index),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: MorphBottomNav(
                items: _items,
                index: _index,
                onChanged: _setTab,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
