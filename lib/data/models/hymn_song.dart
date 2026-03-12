import 'dart:convert';
import 'package:logger/logger.dart';

import 'hymn_chord.dart';
import 'hymn_partition.dart';

class HymnSong {
  final int? id;
  final int? hymnBookId;
  final int? categoryId;
  final int? languageId;
  final String? title;
  final String? audioUrl;
  final int? fileSize;
  final int? scaleId;
  final int? hasOneProgression;
  final int? hasChordOverLyrics;
  final List<HymnPartition>? partitions;
  final String? partitionText;
  final String? singleChordProgressionText;
  final List<HymnChord>? singleChordProgression;

  HymnSong({
    this.singleChordProgression,
    this.singleChordProgressionText,
    this.id,
    required this.hymnBookId,
    required this.title,
    this.categoryId,
    this.fileSize,
    this.languageId,
    required this.hasOneProgression,
    required this.hasChordOverLyrics,
    required this.audioUrl,
    required this.scaleId,
    this.partitions,
    this.partitionText
  });

  HymnSong copyWith(
      {int? id,
      int? hymnBookId,
      int? categoryId,
      int? fileSize,
      String? title,
      String? audioUrl,
      int? scaleId,
      int? languageId,
      required int hasOneProgression,
      required int hasChordOverLyrics,
      List<HymnChord>? progression,
      List<HymnPartition>? partitions}) {
    return HymnSong(
        id: id ?? this.id,
        languageId: languageId ?? this.languageId,
        hymnBookId: hymnBookId ?? this.hymnBookId,
        title: title ?? this.title,
        fileSize: fileSize ?? this.fileSize,
        audioUrl: audioUrl ?? this.audioUrl,
        scaleId: scaleId ?? this.scaleId,
        partitions: partitions ?? this.partitions,
        hasOneProgression: hasOneProgression,
        singleChordProgression: singleChordProgression,
        hasChordOverLyrics: hasChordOverLyrics);
  }

  factory HymnSong.fromJson(Map<String, dynamic> data) {
    List<HymnChord> progression = [];

    if (data["unique_progression"] != null) {
      final fixedJson = data["unique_progression"].replaceAllMapped(RegExp(r'(\w+):'), (match) => '"${match[1]}":');
      final decoded = jsonDecode(fixedJson);
      progression = List<HymnChord>.from(decoded.map((x) => HymnChord.fromJson(x)));
    }

    return HymnSong(
      id: data["id"],
      languageId: data["language_id"],
      hymnBookId: data["hymn_book_id"],
      categoryId: data["category_id"],
      title: data["title"],
      audioUrl: data["audio_url"],
      fileSize: data["file_size"],
      scaleId: data["scale_id"],
      hasChordOverLyrics: data['has_chord_over_lyrics'],
      partitionText: data['partitions'],
      singleChordProgressionText: data['unique_progression'],
      singleChordProgression: progression,
      partitions: data["partitions"] == null ? [] : List<HymnPartition>.from(jsonDecode(data["partitions"]).map((x) => HymnPartition.fromJson(x))),
      hasOneProgression: data['has_one_progression'],
    );
  }


  factory HymnSong.fromDb(Map<String, dynamic> data) {
    List<HymnChord> progression = [];

    if (data["unique_progression"] != null) {

      final fixedJson = data["unique_progression"].replaceAllMapped(RegExp(r'(\w+):'), (match) => '"${match[1]}":');
      final decoded = jsonDecode(fixedJson);
      progression = List<HymnChord>.from(decoded.map((x) => HymnChord.fromJson(x)));
    }

    return HymnSong(
      id: data["id"],
      languageId: data["language_id"],
      hymnBookId: data["hymn_book_id"],
      categoryId: data["category_id"],
      title: data["title"],
      audioUrl: data["audio_url"],
      fileSize: data["file_size"],
      scaleId: data["scale_id"],
      hasChordOverLyrics: data['has_chord_over_lyrics'],
      partitionText: data['partitions'],
      singleChordProgression: progression,
      partitions: data["partitions"] == null ? [] : List<HymnPartition>.from(jsonDecode(data["partitions"]).map((x) => HymnPartition.fromJson(x))),
      hasOneProgression: data['has_one_progression'],
    );
  }



  Map<String, dynamic> toJson() => {
        "id": id,
        "hymn_book_id": hymnBookId,
        "title": title,
        "language_id": languageId,
        "category_id": categoryId,
        "file_size": fileSize,
        "audio_url": audioUrl,
        "scale_id": scaleId,
        "unique_progression": singleChordProgression,
        'has_one_progression': hasOneProgression,
        'has_chord_over_lyrics': hasChordOverLyrics,
        "partitions": partitionText,
      };



  Map<String, dynamic> toDb() => {
        "id": id,
        "hymn_book_id": hymnBookId,
        "language_id": languageId,
        "title": title,
        "category_id": categoryId,
        "audio_url": audioUrl,
        "scale_id": scaleId,
        "file_size": fileSize,
        "unique_progression": singleChordProgressionText,
        'has_one_progression': hasOneProgression,
        'has_chord_over_lyrics': hasChordOverLyrics,
        "partitions": partitionText,
      };
}


class HymnSongListResponse {
  String? error;
  List<HymnSong>? data;

  HymnSongListResponse({this.data, this.error});

  factory HymnSongListResponse.fromJson(Map<String, dynamic> json) {
    return HymnSongListResponse(data: json['data'], error: json['error']);
  }
}

class HymnSongResponse {
  String? error;
  HymnSong? data;

  HymnSongResponse({this.data, this.error});

  factory HymnSongResponse.fromJson(Map<String, dynamic> json) {
    return HymnSongResponse(data: json['data'], error: json['error']);
  }
}
