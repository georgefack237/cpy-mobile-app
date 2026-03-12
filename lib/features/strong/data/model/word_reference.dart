class WordReference {
  int? id;
  String word;
  String? etymology;
  String definition;

  WordReference({
    this.id,
    required this.word,
    required this.definition,
    this.etymology
  });

  factory WordReference.fromJson(Map<String, dynamic> json){
    return WordReference(
        id: json['id'],
        word: json["word"],
        definition: json["definition"],
        etymology: json["etymology"]
    );
  }


  factory WordReference.fromDb(Map<String, dynamic> json){
    return WordReference(
        id: json['id'],
        word: json["word"],
        definition: json["definition"],
        etymology: json["etymology"]
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "word": word,
    "definition": definition,
    "etymology":etymology
  };


  Map<String, dynamic> toDB() => {
    "id": id,
    "word": word,
    "definition": definition,
    "etymology":etymology
  };

}


class WordReferenceListResponse {
  String? error;
  List<WordReference>? data;

  WordReferenceListResponse({this.data, this.error});

  factory WordReferenceListResponse.fromJson(Map<String, dynamic> json) {
    return WordReferenceListResponse(data: json['data'], error: json['error']);
  }
}

class WordReferenceResponse {
  String? error;
  WordReference? data;

  WordReferenceResponse({this.data, this.error});

  factory WordReferenceResponse.fromJson(Map<String, dynamic> json) {
    return WordReferenceResponse(data: json['data'], error: json['error']);
  }
}



