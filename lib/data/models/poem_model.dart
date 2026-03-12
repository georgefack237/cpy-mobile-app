class PoemModel {
  int? id;
  int poemCategoryId;
  int hymnBookId;
  String title;
  String paroles;

  PoemModel({
    this.id,
    required this.poemCategoryId,
    required this.paroles,
    required this.hymnBookId,
    required this.title,
  });

  factory PoemModel.fromJson(Map<String, dynamic> json){
    return PoemModel(
      id: json['id'],
      poemCategoryId: json["category_id"],
      hymnBookId: json["hymn_book_id"],
      paroles: json["lyrics"],
      title: json["title"]
    );
  }

  factory PoemModel.fromDb(Map<String, dynamic> json){
    return PoemModel(
        id: json['id'],
        poemCategoryId: json["category_id"],
        hymnBookId: json["hymn_book_id"],
        paroles: json["lyrics"],
        title: json["title"]
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_id": poemCategoryId,
    "hymn_book_id": hymnBookId,
    "lyrics" : paroles,
    "title": title,
  };

  Map<String, dynamic> toDb() => {
    "id": id,
    "category_id": poemCategoryId,
    "hymn_book_id": hymnBookId,
    "lyrics" : paroles,
    "title": title,
  };

}


class PoemCategory {
  int id;
  String nameEn;
  String nameFr;
  String type;

  PoemCategory({
    required this.id,
    required this.nameEn,
    required this.nameFr,
    required this.type,
  });

  PoemCategory copyWith({
    int? id,
    String? nameEn,
    String? nameFr,
    String? type,
  }) =>
      PoemCategory(
        id: id ?? this.id,
        nameEn: nameEn ?? this.nameEn,
        nameFr: nameFr ?? this.nameFr,
        type: type ?? this.type,
      );
}



class PoemListResponse {
  String? error;
  List<PoemModel>? data;

  PoemListResponse({this.data, this.error});

  factory PoemListResponse.fromJson(Map<String, dynamic> json) {
    return PoemListResponse(data: json['data'], error: json['error']);
  }
}

class PoemResponse {
  String? error;
  PoemModel? data;

  PoemResponse({this.data, this.error});

  factory PoemResponse.fromJson(Map<String, dynamic> json) {
    return PoemResponse(data: json['data'], error: json['error']);
  }
}







List<PoemCategory>  poemCategories = [
  PoemCategory(id: 1, nameEn: "Celebration", nameFr: 'Célébration', type: "celebration"),
  PoemCategory(id: 2, nameEn: "Repentance", nameFr: 'Repentance', type: "repentance"),
  PoemCategory(id: 3, nameEn: "Warnings", nameFr: 'Interpellations', type: "warnings"),
  PoemCategory(id: 4, nameEn: "Soupirs", nameFr: 'Soupirs', type: "soupirs"),
  PoemCategory(id: 5, nameEn: "Assurance and Hope", nameFr: 'Assurance et Espérance', type: "assurance_hope")
];

