import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Owns a single [AudioPlayer] instance and exposes playback state as a
/// ChangeNotifier. Has no knowledge of downloads, widgets, or lyrics —
/// it only knows how to play a file that already exists on disk.
///
/// Lifecycle: create one per HymnSongDetailsPage (it's a page-scoped
/// mini-player, not an app-wide singleton), and call [dispose] when the
/// page is torn down.
class HymnAudioPlayerService extends ChangeNotifier {
  HymnAudioPlayerService() {
    _player.onPositionChanged.listen((p) {
      position = p;
      notifyListeners();
    });

    _player.onDurationChanged.listen((d) {
      duration = d;
      notifyListeners();
    });

    _player.onPlayerStateChanged.listen((s) {
      _state = s;
      notifyListeners();
    });

    _player.onPlayerComplete.listen((_) {
      _state = PlayerState.completed;
      position = Duration.zero;
      notifyListeners();
    });
  }

  final AudioPlayer _player = AudioPlayer();

  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  PlayerState _state = PlayerState.stopped;

  /// The path of the file currently loaded, so we know whether "play"
  /// means resume vs. start a new source.
  String? _loadedPath;

  static const List<double> speedSteps = [0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0];
  double speed = 1.0;

  bool get isPlaying => _state == PlayerState.playing;
  bool get isPaused => _state == PlayerState.paused;

  double get progress =>
      duration.inMilliseconds == 0 ? 0 : (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);

  Future<void> playFile(FileSystemEntity file) async {
    _loadedPath = file.path;
    await _player.play(DeviceFileSource(file.path));
    await _player.setPlaybackRate(speed);
  }

  /// Toggles play/pause. If nothing is loaded yet, starts [file].
  Future<void> togglePlayPause(FileSystemEntity file) async {
    if (isPlaying) {
      await _player.pause();
      return;
    }
    if (isPaused && _loadedPath == file.path) {
      await _player.resume();
      return;
    }
    await playFile(file);
  }

  Future<void> seek(Duration to) => _player.seek(to);

  Future<void> skipForward([Duration by = const Duration(seconds: 15)]) {
    final target = position + by;
    return seek(target > duration ? duration : target);
  }

  Future<void> skipBackward([Duration by = const Duration(seconds: 15)]) {
    final target = position - by;
    return seek(target < Duration.zero ? Duration.zero : target);
  }

  /// Seeks by a fraction (0.0–1.0) of the current [duration]. Handy for
  /// wiring straight to a slider's onChanged.
  Future<void> seekFraction(double fraction) {
    if (duration == Duration.zero) return Future.value();
    final ms = (duration.inMilliseconds * fraction.clamp(0.0, 1.0)).toInt();
    return seek(Duration(milliseconds: ms));
  }

  Future<void> setSpeed(double newSpeed) async {
    speed = newSpeed;
    await _player.setPlaybackRate(newSpeed);
    notifyListeners();
  }

  /// Cycles to the next speed step (wraps back to the start after the max).
  Future<void> cycleSpeed() async {
    final currentIndex = speedSteps.indexWhere((s) => (s - speed).abs() < 0.001);
    final nextIndex = (currentIndex + 1) % speedSteps.length;
    await setSpeed(speedSteps[nextIndex]);
  }

  Future<void> stop() async {
    await _player.stop();
    position = Duration.zero;
    _loadedPath = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}