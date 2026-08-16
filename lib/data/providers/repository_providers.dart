import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/local_storage_adapter.dart';
import '../repositories/save_repository.dart';
import '../repositories/settings_repository.dart';

/// Provider for the abstract [LocalStorageAdapter].
/// Overridden in `main.dart` or during tests.
final localStorageAdapterProvider = Provider<LocalStorageAdapter>((ref) {
  throw UnimplementedError('localStorageAdapterProvider must be overridden');
});

/// Provider for [SaveRepository].
final saveRepositoryProvider = Provider<SaveRepository>((ref) {
  final storage = ref.watch(localStorageAdapterProvider);
  return SaveRepository(storage);
});

/// Provider for [SettingsRepository].
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final storage = ref.watch(localStorageAdapterProvider);
  return SettingsRepository(storage);
});
