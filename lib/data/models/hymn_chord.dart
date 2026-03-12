
import 'hymn_sub_chord.dart';

class HymnChord {
  int note;
  int? repeat;
  List<HymnSubChord>? subChords;
  int? duration;

  HymnChord({
    required this.note,
    this.repeat,
    this.subChords,
    this.duration,
  });

  factory HymnChord.fromJson(Map<String, dynamic> json){
    return HymnChord(
      note: json["note"],
      duration: json["duration"],
      repeat: json["repeat"],
      subChords: json["sub_chords"] == null ? [] : List<HymnSubChord>.from(json["sub_chords"]!.map((x) => HymnSubChord.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "note": note,
    "duration": duration,
    "sub_notes": subChords,
    "repeat": repeat
  };

}