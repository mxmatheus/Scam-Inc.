import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';
import 'data/storage/local_storage_adapter.dart';
import 'data/providers/repository_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Force portrait orientation lock as defined in GDD
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style for clean corporate aesthetic
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize storage adapter
  final storageAdapter = await SharedPreferencesStorageAdapter.create();

  runApp(
    ProviderScope(
      overrides: [
        localStorageAdapterProvider.overrideWithValue(storageAdapter),
      ],
      child: const ScamIncApp(),
    ),
  );
}
