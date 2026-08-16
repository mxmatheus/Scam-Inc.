import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/game_constants.dart';
import '../data/providers/repository_providers.dart';
import '../features/dashboard/screens/main_dashboard_screen.dart';
import 'theme.dart';

class ScamIncApp extends ConsumerWidget {
  const ScamIncApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsStateProvider);

    return MaterialApp(
      title: GameConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const MainDashboardScreen(),
    );
  }
}
