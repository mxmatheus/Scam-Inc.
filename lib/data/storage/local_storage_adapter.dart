import 'package:shared_preferences/shared_preferences.dart';

/// Abstract contract for local key-value storage.
abstract class LocalStorageAdapter {
  Future<String?> getString(String key);
  Future<bool> setString(String key, String value);
  Future<bool> remove(String key);
  Future<bool> containsKey(String key);
  Future<bool> clear();
}

/// SharedPreferences implementation of [LocalStorageAdapter].
class SharedPreferencesStorageAdapter implements LocalStorageAdapter {
  final SharedPreferences _prefs;

  const SharedPreferencesStorageAdapter(this._prefs);

  static Future<SharedPreferencesStorageAdapter> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SharedPreferencesStorageAdapter(prefs);
  }

  @override
  Future<String?> getString(String key) async {
    return _prefs.getString(key);
  }

  @override
  Future<bool> setString(String key, String value) async {
    return _prefs.setString(key, value);
  }

  @override
  Future<bool> remove(String key) async {
    return _prefs.remove(key);
  }

  @override
  Future<bool> containsKey(String key) async {
    return _prefs.containsKey(key);
  }

  @override
  Future<bool> clear() async {
    return _prefs.clear();
  }
}

/// In-memory implementation of [LocalStorageAdapter] for tests.
class InMemoryStorageAdapter implements LocalStorageAdapter {
  final Map<String, String> _store = {};

  @override
  Future<String?> getString(String key) async => _store[key];

  @override
  Future<bool> setString(String key, String value) async {
    _store[key] = value;
    return true;
  }

  @override
  Future<bool> remove(String key) async {
    _store.remove(key);
    return true;
  }

  @override
  Future<bool> containsKey(String key) async => _store.containsKey(key);

  @override
  Future<bool> clear() async {
    _store.clear();
    return true;
  }
}
