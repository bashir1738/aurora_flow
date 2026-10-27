import 'package:flutter/material.dart';

import 'screens/onboarding_screen.dart';
import 'theme/app_theme.dart';

class AuroraFlowApp extends StatelessWidget {
  const AuroraFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aurora Flow',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const OnboardingScreen(),
    );
  }
}
