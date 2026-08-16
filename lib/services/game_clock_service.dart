import 'dart:async';
import 'package:flutter/widgets.dart';

typedef GameTickCallback = void Function(Duration delta);

/// Manages logical game time ticks independent from UI widget rebuilds.
class GameClockService with WidgetsBindingObserver {
  final Duration tickInterval;
  Timer? _timer;
  DateTime? _lastTickTime;
  bool _isPaused = false;
  final List<GameTickCallback> _listeners = [];

  GameClockService({this.tickInterval = const Duration(milliseconds: 500)});

  bool get isRunning => _timer != null && _timer!.isActive && !_isPaused;
  bool get isPaused => _isPaused;

  /// Registers a callback to be invoked on every game tick with elapsed delta.
  void addListener(GameTickCallback callback) {
    if (!_listeners.contains(callback)) {
      _listeners.add(callback);
    }
  }

  /// Removes a registered tick callback.
  void removeListener(GameTickCallback callback) {
    _listeners.remove(callback);
  }

  /// Starts the game clock loop.
  void start() {
    if (_timer != null) return; // Prevent duplicate ticker loops

    WidgetsBinding.instance.addObserver(this);
    _lastTickTime = DateTime.now();
    _isPaused = false;

    _timer = Timer.periodic(tickInterval, (_) {
      _onTick();
    });
  }

  void _onTick() {
    if (_isPaused || _lastTickTime == null) return;

    final now = DateTime.now();
    final delta = now.difference(_lastTickTime!);
    _lastTickTime = now;

    _notifyListeners(delta);
  }

  void _notifyListeners(Duration delta) {
    for (final listener in List.of(_listeners)) {
      listener(delta);
    }
  }

  /// Pauses game ticks (e.g. when app enters background).
  void pause() {
    _isPaused = true;
  }

  /// Resumes game ticks (e.g. when app returns to foreground).
  void resume() {
    if (_isPaused) {
      _lastTickTime = DateTime.now();
      _isPaused = false;
    }
  }

  /// Completely stops and cleans up the game clock.
  void stop() {
    _timer?.cancel();
    _timer = null;
    _lastTickTime = null;
    _isPaused = false;
    try {
      WidgetsBinding.instance.removeObserver(this);
    } catch (_) {}
  }

  /// Deterministic test helper: simulates a tick of duration [delta] manually.
  void tickManually(Duration delta) {
    _notifyListeners(delta);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        pause();
        break;
      case AppLifecycleState.resumed:
        resume();
        break;
      default:
        break;
    }
  }
}
