import 'package:flutter/material.dart';

/// Background/text presets for the lyrics reader — similar to the
/// reading-theme switchers found in most ebook/lyrics apps.
enum ReadingTheme { light, sepia, dark }

extension ReadingThemeColors on ReadingTheme {
  Color get background {
    switch (this) {
      case ReadingTheme.light:
        return Colors.white;
      case ReadingTheme.sepia:
        return const Color(0xFFFBF3E3);
      case ReadingTheme.dark:
        return const Color(0xFF171717);
    }
  }

  Color get textColor {
    switch (this) {
      case ReadingTheme.light:
        return Colors.black;
      case ReadingTheme.sepia:
        return const Color(0xFF4A3B2A);
      case ReadingTheme.dark:
        return Colors.white;
    }
  }

  String get label {
    switch (this) {
      case ReadingTheme.light:
        return 'Clair';
      case ReadingTheme.sepia:
        return 'Sépia';
      case ReadingTheme.dark:
        return 'Sombre';
    }
  }
}

/// Everything that controls how lyrics/chords are rendered on the reading
/// screen. Immutable on purpose — the service below is the only thing that
/// mutates state, widgets just read the current snapshot.
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
    'Courier New',
    'Georgia',
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