
import '../models/hymn_book_collection.dart';
import '../models/hymn_category.dart';
import '../models/hymn_partition_type.dart';

List<HymnBookCollection> hymnBookCollectionList = [
];


List<HymnCategory>  hymnCategories = [
  HymnCategory(id: 1, nameEn: "Celebration", nameFr: 'Célébration', type: "celebration"),
  HymnCategory(id: 2, nameEn: "Thanksgiving", nameFr: 'Reconnaissance', type: "thanksgiving"),
  HymnCategory(id: 3, nameEn: "Warnings", nameFr: 'Interpellations', type: "warnings"),
  HymnCategory(id: 4, nameEn: "Supplications", nameFr: 'Supplications', type: "supplications"),
  HymnCategory(id: 5, nameEn: "Assurance", nameFr: 'Assurance', type: "assurance"),
  HymnCategory(id: 6, nameEn: "Hope", nameFr: 'Espérance', type: "hope")
];


List<HymnPartitionType>  partitionTypes = [
  HymnPartitionType(id: 1, nameEn: "Chorus", nameFr: 'Refrain', type: "refrain"),
  HymnPartitionType(id: 9, nameEn: "Chorus", nameFr: 'Refrain 2', type: "refrain"),
  HymnPartitionType(id: 2, nameEn: "Verse 1", nameFr: 'Couplet 1', type: "couplet"),
  HymnPartitionType(id: 3, nameEn: "Verse 2", nameFr: 'Couplet 2', type: "couplet"),
  HymnPartitionType(id: 4, nameEn: "Verse 3", nameFr: 'Couplet 3', type: "couplet"),
  HymnPartitionType(id: 5, nameEn: "Verse 4", nameFr: 'Couplet 4', type: "couplet"),
  HymnPartitionType(id: 6, nameEn: "Verse 5", nameFr: 'Couplet 5', type: "couplet"),
  HymnPartitionType(id: 7, nameEn: "Verse 6", nameFr: 'Couplet 6', type: "couplet"),
  HymnPartitionType(id: 8, nameEn: "Coda", nameFr: 'Coda', type: "coda"),

];


List<String> noteScales = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"];
List<String> noteScalesFr = ["Do", "Do#", "Re", "Re#", "Mi", "Fa", "Fa#", "Sol", "Sol#", "La", "La#", "Si"];