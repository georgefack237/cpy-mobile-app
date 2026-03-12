class MediaType {
  int? id;
  String nameEn;
  String nameFr;
  String value;

  MediaType({
    this.id,
    required this.nameEn,
    required this.nameFr,
    required this.value
  });

  factory MediaType.fromJson(Map<String, dynamic> json){
    return MediaType(
        id: json['id'],
        nameEn: json["name_en"],
        nameFr: json["name_fr"],
        value: json["value"]

    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name_en": nameEn,
    "name_fr": nameFr,
    "value": value
  };

}


List<MediaType> mediaTypes = [
  MediaType(id: 0, nameFr: 'Tout', nameEn: 'All', value: "works"),
  MediaType(id: 1, nameFr: 'Ouvrages', nameEn: 'Works', value: "works"),
  MediaType(id: 2, nameFr: 'Albums', nameEn: 'Albums', value: "albums"),
  MediaType(id: 3, nameFr: 'Formations', nameEn: 'Formations', value: "formations")
];