class ChordTranspose {


  static final Map<String, List<String>> _majorScalesEN = {
    "C": ["C", "D", "E", "F", "G", "A", "B"],
    "C#": ["C#", "D#", "E#", "F#", "G#", "A#", "C#"],
    "D": ["D", "E",   "F#", "G", "A", "B", "C#"],
    "D#": ["D#", "F", "G", "G#", "A#", "C", "D"],
    "E": ["E", "F#", "G#", "A", "B", "C#", "D#"],
    "F": ["F", "G", "A", "A#", "C", "D", "E"],
    "F#": ["F#", "G#", "A#", "B", "C#", "D#", "F"],
    "G": ["G", "A", "B", "C", "D", "E", "F#"],
    "G#": ["G#", "A#", "C", "C#", "D#", "F", "G"],
    "A": ["A", "B", "C#", "D", "E", "F#", "G#"],
    "A#": ["A#", "C", "D", "D#", "F", "G", "A"],
    "B": ["B", "C#", "D#", "E", "F#", "G#", "A#"]
  };

  static final Map<String, List<String>> _minorScalesEN = {
    "Am": ["A", "B", "C", "D", "E", "F", "G"],
    "A#m": ["A#", "C", "C#", "D#", "F", "F#", "G#"],
    "Bm": ["B", "C#", "D", "E", "F#", "G", "A"],
    "Cm": ["C", "D", "Eb", "F", "G", "Ab", "Bb"],
    "C#m": ["C#", "D#", "E", "F#", "G#", "A", "B"],
    "Dm": ["D", "E", "F", "G", "A", "Bb", "C"],
    "D#m": ["D#", "E#", "F#", "G#", "A#", "B", "C#"],
    "Em": ["E", "F#", "G", "A", "B", "C", "D"],
    "Fm": ["F", "G", "Ab", "Bb", "C", "Db", "Eb"],
    "F#m": ["F#", "G#", "A", "B", "C#", "D", "E"],
    "Gm": ["G", "A", "Bb", "C", "D", "Eb", "F"],
    "G#m": ["G#", "A#", "B", "C#", "D#", "E", "F#"]
  };

  // English to French notation mapping
  static final Map<String, String> _enToFr = {
    "C": "Do",
    "C#": "Do#",
    "D": "Ré",
    "D#": "Ré#",
    "E": "Mi",
    "F": "Fa",
    "F#": "Fa#",
    "G": "Sol",
    "G#": "Sol#",
    "A": "La",
    "A#": "La#",
    "B": "Si",
    "Db": "Réb",
    "Eb": "Mib",
    "Gb": "Solb",
    "Ab": "Lab",
    "Bb": "Sib",
    "E#": "Mi#",
    "B#": "Si#"
  };

  static final Map<String, String> _frToEn = {
    "Do": "C",
    "Do#": "C#",
    "Ré": "D",
    "Ré#": "D#",
    "Mi": "E",
    "Fa": "F",
    "Fa#": "F#",
    "Sol": "G",
    "Sol#": "G#",
    "La": "A",
    "La#": "A#",
    "Si": "B",
    "Réb": "Db",
    "Mib": "Eb",
    "Solb": "Gb",
    "Lab": "Ab",
    "Sib": "Bb",
    "Mi#": "E#",
    "Si#": "B#"
  };

  /// Get the scale for a given key (major or minor)
  static List<String>? _getScale(String key, bool isMinor) {
    return isMinor ? _minorScalesEN[key] : _majorScalesEN[key];
  }

  /// Converts a chord progression using scale degrees (1-4-5-6) into actual chords
  static List<String> getChordProgression(
      String key, List<int> positions, bool isMinor, bool useFrench) {
    List<String>? scale = _getScale(key, isMinor);
    if (scale == null) return [];

    return positions.map((pos) {
      int index = (pos - 1) % 7; // Convert position to index (1-based to 0-based)
      String chord = (pos == 6 || pos == 2 || pos == 3) ? "${scale[index]}m" : scale[index];
      return useFrench ? _enToFr[chord.replaceAll("m", "")]! + (chord.contains("m") ? "m" : "") : chord;
    }).toList();
  }

  /// Transpose a chord progression from one key to another
  static List<String> transposeProgression(
      String fromKey, String toKey, List<int> positions, bool isMinor, bool useFrench) {
    return getChordProgression(toKey, positions, isMinor, useFrench);
  }
}
