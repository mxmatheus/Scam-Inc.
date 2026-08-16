import 'package:flutter/material.dart';
import '../core/constants/game_constants.dart';
import '../features/dashboard/screens/main_dashboard_screen.dart';
import 'theme.dart';

class ScamIncApp extends StatelessWidget {
  const ScamIncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: GameConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainDashboardScreen(),
    );
  }
}
