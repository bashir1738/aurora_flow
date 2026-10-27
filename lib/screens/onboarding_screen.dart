import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';
import '../utils/motion_route.dart';
import '../widgets/primary_button.dart';
import 'app_shell.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _pages = <_OnboardingPage>[
    _OnboardingPage(
      title: 'A small\nFlutter study',
      body: 'Motion, rhythm and depth — built by hand with CustomPainter '
          'instead of animation packages.',
    ),
    _OnboardingPage(
      title: 'Quiet\nby default',
      body: 'Flat surfaces, solid colour and a single accent. Nothing '
          'decorative competes with the content.',
    ),
    _OnboardingPage(
      title: 'Four\nsmall worlds',
      body: 'A field of lines, a breathing circle, a tilting stack and a '
          'solid palette. All of them are yours to explore.',
    ),
  ];

  late final PageController _controller;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_index == _pages.length - 1) {
      _finish();
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
    );
  }

  void _finish() {
    Navigator.of(context).pushReplacement(
      motionRoute(const AppShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLast = _index == _pages.length - 1;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.background,
      ),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'AURORA FLOW',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.textPrimary,
                        letterSpacing: 2.6,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: _finish,
                      child: Text(
                        'Skip',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      final page = _controller.hasClients
                          ? (_controller.page ?? _index.toDouble())
                          : _index.toDouble();
                      return PageView.builder(
                        controller: _controller,
                        itemCount: _pages.length,
                        onPageChanged: (value) {
                          if (value != _index) setState(() => _index = value);
                        },
                        itemBuilder: (context, index) {
                          final delta =
                              (index - page).clamp(-1.0, 1.0).toDouble();
                          final distance = delta.abs();
                          return Opacity(
                            opacity: (1 - distance * 0.7).clamp(0.0, 1.0),
                            child: Transform.translate(
                              offset: Offset(delta * 24, 0),
                              child: _PageView(
                                page: _pages[index],
                                index: index,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    for (var i = 0; i < _pages.length; i++) ...[
                      Expanded(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 2,
                          color: i == _index
                              ? AppColors.ink
                              : AppColors.border,
                        ),
                      ),
                      if (i != _pages.length - 1) const SizedBox(width: 8),
                    ],
                  ],
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  label: isLast ? 'Enter Aurora Flow' : 'Continue',
                  icon: isLast ? Icons.arrow_forward_rounded : null,
                  expand: true,
                  onTap: _next,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage {
  const _OnboardingPage({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;
}

class _PageView extends StatelessWidget {
  const _PageView({required this.page, required this.index});

  final _OnboardingPage page;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '0${index + 1}',
          style: theme.textTheme.labelSmall?.copyWith(
            color: AppColors.textMuted,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          page.title,
          style: theme.textTheme.displayLarge?.copyWith(fontSize: 42),
        ),
        const SizedBox(height: 20),
        Text(
          page.body,
          style: theme.textTheme.bodyMedium?.copyWith(fontSize: 15),
        ),
      ],
    );
  }
}
