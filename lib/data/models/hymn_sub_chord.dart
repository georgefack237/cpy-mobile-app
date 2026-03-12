
class HymnSubChord {
  int note;
  int duration;

  HymnSubChord({
    required this.note,
    required this.duration,
  });



  factory HymnSubChord.fromJson(Map<String, dynamic> json){
    return HymnSubChord(
        note: json["note"],
        duration: json["duration"]
    );
  }

  Map<String, dynamic> toJson() => {
    "note": note,
    "duration": duration
  };

}