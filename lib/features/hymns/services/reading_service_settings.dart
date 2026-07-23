import 'package:flutter/material.dart';

/// Background/text/surface presets for the lyrics reader.
enum ReadingTheme { light, sepia, dark }

extension ReadingThemeX on ReadingTheme {
  Color get background => switch (this) {
    ReadingTheme.light => const Color(0xFFFFFFFF),
    ReadingTheme.sepia => const Color(0xFFF8F1E4),
    ReadingTheme.dark => const Color(0xFF1A1A1A),
  };

  Color get text => switch (this) {
    ReadingTheme.light => const Color(0xFF1A1A1A),
    ReadingTheme.sepia => const Color(0xFF3D2B1F),
    ReadingTheme.dark => const Color(0xFFE0DACE),
  };

  /// Used for slider tracks / chip backgrounds inside the settings sheet
  /// so controls stay legible against light, sepia, or dark chrome.
  Color get surface => switch (this) {
    ReadingTheme.light => const Color(0xFFF5F5F5),
    ReadingTheme.sepia => const Color(0xFFEDE3D0),
    ReadingTheme.dark => const Color(0xFF2C2C2C),
  };

  String get label => switch (this) {
    ReadingTheme.light => 'Clair',
    ReadingTheme.sepia => 'Sépia',
    ReadingTheme.dark => 'Sombre',
  };
}

/// Everything that controls how lyrics/chords are rendered on the reading
/// screen. Immutable — ReadingSettingsService is the only thing that
/// mutates state; widgets just read the current snapshot.
@immutable
class ReadingSettings {
  const ReadingSettings({
    this.fontScale = 1.0,
    this.fontFamily = 'Roboto',
    this.textOpacity = 1.0,
    this.lineHeight = 1.6,
    this.letterSpacing = 1.0,
    this.theme = ReadingTheme.light,
  });

  /// Multiplier applied on top of the base reading font size
  /// (e.g. FontSizes().fontReading(...) * fontScale).
  final double fontScale;
  final String fontFamily;
  final double textOpacity;
  final double lineHeight;
  final double letterSpacing;
  final ReadingTheme theme;

  static const List<String> availableFontFamilies = [
    'Roboto',
    'Poppins',
    'Georgia',
    'Courier New',
    'Times New Roman',
  ];

  ReadingSettings copyWith({
    double? fontScale,
    String? fontFamily,
    double? textOpacity,
    double? lineHeight,
    double? letterSpacing,
    ReadingTheme? theme,
  }) {
    return ReadingSettings(
      fontScale: fontScale ?? this.fontScale,
      fontFamily: fontFamily ?? this.fontFamily,
      textOpacity: textOpacity ?? this.textOpacity,
      lineHeight: lineHeight ?? this.lineHeight,
      letterSpacing: letterSpacing ?? this.letterSpacing,
      theme: theme ?? this.theme,
    );
  }
}