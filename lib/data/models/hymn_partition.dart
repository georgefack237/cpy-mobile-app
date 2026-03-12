import 'dart:convert';

import 'hymn_chord.dart';

class HymnPartition {
  int id;
  String hymnId;
  bool hasSubChords;
  String lyrics;
  List<HymnChord>? chordProgression;
  int? noOfTimes;

  HymnPartition({
    required this.id,
    required this.hymnId,
    required this.lyrics,
    required this.hasSubChords,
    this.chordProgression,
    this.noOfTimes,
  });

  factory HymnPartition.fromJson(Map<String, dynamic> json){
    return HymnPartition(
      id: json["id"],
      hymnId: json["hymn_id"],
      lyrics: json["lyrics"],
      hasSubChords: json["has_sub_chords"],
      chordProgression:json["progression"] == null ? []:List<HymnChord>.from(json["progression"]!.map((x) => HymnChord.fromJson(x))),
      noOfTimes: json["no_of_times"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "hymn_id": hymnId,
    "lyrics": lyrics,
    "has_sub_chords" : hasSubChords,
    "progression": chordProgression,
    "no_of_times": noOfTimes
  };


  Map<String, dynamic> toDbJson() => {
    "id": id,
    "hymn_id": hymnId,
    "lyrics": lyrics,
    "has_sub_chords" : hasSubChords,
    "progression": "${chordProgression!.map((e) => e.toJson())}".replaceAll('(', '').replaceAll(')', ''),
    "no_of_times": noOfTimes
  };



  String toJsonString() => json.encode(toJson());


}