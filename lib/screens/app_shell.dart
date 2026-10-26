import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';
import '../utils/motion_route.dart';
import '../widgets/aurora_background.dart';
import '../widgets/morph_bottom_nav.dart';
import 'depth_screen.dart';
import 'home_screen.dart';
import 'liquid_screen.dart';
import 'motion_screen.dart';
import 'pulse_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  static const _items = <NavItem>[
    NavItem(Icons.auto_awesome_rounded, 'Home'),
    NavItem(Icons.blur_on_rounded, 'Motion'),
    NavItem(Icons.favorite_rounded, 'Pulse'),
    NavItem(Icons.layers_rounded, 'Depth'),
  ];

  int _index = 0;

  void _setTab(int index) {
    if (index == _index) return;
    setState(() => _index = index);
  }

  void _openLiquid() {
    Navigator.of(context).push(
      motionRoute(const LiquidScreen()),
    );
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
        return HomeScreen(
          onOpenTab: _setTab,
          onOpenLiquid: _openLiquid,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.background,
      ),
      child: Scaffold(
        extendBody: true,
        body: AuroraBackground(
          child: Stack(
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
                          begin: const Offset(0, 0.025),
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
      ),
    );
  }
}
