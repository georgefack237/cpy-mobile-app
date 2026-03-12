class HymnCategory {
  int id;
  String nameEn;
  String nameFr;
  String type;

  HymnCategory({
    required this.id,
    required this.nameEn,
    required this.nameFr,
    required this.type,
  });

  HymnCategory copyWith({
    int? id,
    String? nameEn,
    String? nameFr,
    String? type,
  }) => HymnCategory(
        id: id ?? this.id,
        nameEn: nameEn ?? this.nameEn,
        nameFr: nameFr ?? this.nameFr,
        type: type ?? this.type,
      );
}
