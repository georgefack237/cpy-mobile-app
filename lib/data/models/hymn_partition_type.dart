class HymnPartitionType {
  int id;
  String nameEn;
  String nameFr;
  String type;

  HymnPartitionType({
    required this.id,
    required this.nameEn,
    required this.nameFr,
    required this.type,
  });

  HymnPartitionType copyWith({
    int? id,
    String? nameEn,
    String? nameFr,
    String? type,
  }) => HymnPartitionType(
        id: id ?? this.id,
        nameEn: nameEn ?? this.nameEn,
        nameFr: nameFr ?? this.nameFr,
        type: type ?? this.type,
      );
}


enum PartitionEnum {
  refrain,
  couplet,
  coda
}

