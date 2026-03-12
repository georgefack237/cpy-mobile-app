
class HymnBookCollection{
  int id;
  int authorId;
  String nameEn;
  String nameFr;
  int? hymnSongsCount;
  int? hymnPoemsCount;


  HymnBookCollection({
    required this.id,
    required this.authorId,
    required this.nameEn,
    required this.nameFr,
    this.hymnPoemsCount,
    this.hymnSongsCount
  });

  HymnBookCollection copyWith({
    int? id,
    int? authorId,
    int? hymnPoemsCount,
    int? hymnSongsCount,
    String? nameEn,
    String? nameFr,
  }) => HymnBookCollection(
    id: id ?? this.id,
    authorId: authorId ?? this.authorId,
    hymnPoemsCount: hymnPoemsCount ?? this.hymnPoemsCount,
    hymnSongsCount: hymnSongsCount ?? this.hymnSongsCount,
    nameEn: nameEn ?? this.nameEn,
    nameFr: nameFr ?? this.nameFr,
  );


  factory HymnBookCollection.fromJson(Map<String, dynamic> json){
    return HymnBookCollection(
      id: json["id"],
      authorId: json["hymn_book_author_id"],
      nameEn: json["name_en"],
      nameFr: json["name_fr"],
      hymnSongsCount: json["hymn_songs_count"],
      hymnPoemsCount: json["hymn_poems_count"],
    );
  }


  factory HymnBookCollection.fromDb(Map<String, dynamic> json){
    return HymnBookCollection(
        id: json["id"],
        authorId: json["hymn_book_author_id"],
        nameEn: json["name_en"],
        nameFr: json["name_fr"],
        hymnSongsCount: json["hymn_songs_count"],
        hymnPoemsCount: json["hymn_poems_count"]
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "hymn_book_author_id": authorId,
    "name_en": nameEn,
    "name_fr" : nameFr,
    "hymn_songs_count": hymnSongsCount,
    "hymn_poems_count": hymnPoemsCount
  };


  Map<String, dynamic> toDb() => {
    "id": id,
    "hymn_book_author_id": authorId,
    "name_en": nameEn,
    "name_fr" : nameFr,
    "hymn_songs_count": hymnSongsCount,
    "hymn_poems_count": hymnPoemsCount
  };
}






class DataResponse {
  int? songCount;
  int? poemCount;
  String? error;

  DataResponse({this.songCount, this.poemCount, this.error});

  factory DataResponse.fromJson(Map<String, dynamic> json) {
    return DataResponse(songCount: json['songs'], poemCount: json['poems'], error: json['error']);
  }
}



class HymnBookCollectionListResponse {
  String? error;
  List<HymnBookCollection>? data;

  HymnBookCollectionListResponse({this.data, this.error});

  factory HymnBookCollectionListResponse.fromJson(Map<String, dynamic> json) {
    return HymnBookCollectionListResponse(data: json['data'], error: json['error']);
  }
}


class HymnBookCollectionResponse {
  String? error;
  HymnBookCollection? data;

  HymnBookCollectionResponse({this.data, this.error});

  factory HymnBookCollectionResponse.fromJson(Map<String, dynamic> json) {
    return HymnBookCollectionResponse(data: json['data'], error: json['error']);
  }
}