
class PictureVerse {
  int? id;
  String verse;
  String? image;
  String description;
  String? type;
  String? start;
  String? stop;
  String? location;
  int? isActive;

  PictureVerse({
    this.id,
    required this.verse,
    required this.image,
    this.type,
    this.start,
    this.stop,
    this.location,
    this.isActive,
    required this.description
  });

  factory PictureVerse.fromJson(Map<String, dynamic> json){
    return PictureVerse(
        id: json['id'],
        verse: json["verse"],
        image: json["image"],
        type: json["type"],
        start: json["start"],
        stop: json["stop"],
        location: json["location"],
        isActive: json["is_active"],
        description: json["description"]
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "verse": verse,
    "image": image,
    "start": start,
    "stop": stop,
    "location": location,
    "is_active": isActive,
    "type": type,
    "description":description
  };



  Map<String, dynamic> toDb() => {
    "id": id,
    "verse": verse,
    "image": image,
    "is_active": isActive,
    "type": type,
    "description":description
  };

}


class PictureVerseListResponse {
  String? error;
  List<PictureVerse>? data;

  PictureVerseListResponse({this.data, this.error});

  factory PictureVerseListResponse.fromJson(Map<String, dynamic> json) {
    return PictureVerseListResponse(data: json['data'], error: json['error']);
  }
}

class PictureVerseResponse {
  String? error;
  PictureVerse? data;

  PictureVerseResponse({this.data, this.error});

  factory PictureVerseResponse.fromJson(Map<String, dynamic> json) {
    return PictureVerseResponse(data: json['data'], error: json['error']);
  }
}



