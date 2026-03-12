class MediaFile {
  int? id;
  int mediaTypeId;
  String name;
  int? size;
  String? path;
  String? link;
  String? placeHolderImage;


  MediaFile({
    this.id,
    required this.mediaTypeId,
    required this.name,
    this.size,
    this.path,
    this.link,
    this.placeHolderImage
  });

  factory MediaFile.fromJson(Map<String, dynamic> json){
    return MediaFile(
        id: json['id'],
        mediaTypeId: json["media_type_id"],
        name: json["name"],
        size: json["size"],
        path: json["path"],
        link: json["link"],
        placeHolderImage: json["place_holder_image"]
    );
  }

  factory MediaFile.fromDb(Map<String, dynamic> json){
    return MediaFile(
        id: json['id'],
        mediaTypeId: json["media_type_id"],
        name: json["name"],
        size: json["size"],
        path: json["path"],
        link: json["link"],
        placeHolderImage: json["place_holder_image"]
    );
  }



  Map<String, dynamic> toDb() => {
    "id": id,
    "media_type_id": mediaTypeId,
    "name": name,
    "size" : size,
    "path": path,
    "link" : link,
    "place_holder_image": placeHolderImage,
  };

  Map<String, dynamic> toJson() => {
    "id": id,
    "media_type_id": mediaTypeId,
    "name": name,
    "size" : size,
    "path": path,
    "link" : link,
    "place_holder_image": placeHolderImage,
  };

}


class MediaFileListResponse {
  String? error;
  List<MediaFile>? data;

  MediaFileListResponse({this.data, this.error});

  factory MediaFileListResponse.fromJson(Map<String, dynamic> json) {
    return MediaFileListResponse(data: json['data'], error: json['error']);
  }
}

class MediaFileResponse {
  String? error;
  MediaFile? data;

  MediaFileResponse({this.data, this.error});

  factory MediaFileResponse.fromJson(Map<String, dynamic> json) {
    return MediaFileResponse(data: json['data'], error: json['error']);
  }
}



