class NotificationModel {
  int? id;
  String? title;
  String? description;
  String? type;
  int? itemId;
  String? createdAt;


  NotificationModel({
    this.id,
     this.title,
     this.description,
     this.itemId,
    this.type,
    this.createdAt
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json){
    return NotificationModel(
      id: json['id'],
      title: json["title"],
      description: json["description"],
      type: json["type"],
      itemId: json['item_id'],
      createdAt: json['created_at']

    );
  }

  factory NotificationModel.fromDb(Map<String, dynamic> json){
    return NotificationModel(
      id: json['id'],
      title: json["title"],
      description: json["description"],
        type: json["type"],
        itemId: json['item_id']
    );
  }


  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "type": type,
    "description": description,
    "item_id": itemId

  };

  Map<String, dynamic> toDb() => {
    "id": id,
    "title": title,
    "type": type,
    "description": description,
    "item_id": itemId
  };

}

class NotificationResponse {
  String? error;
  List<NotificationModel>? data;

  NotificationResponse({this.data, this.error});

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(data: json['data'], error: json['error']);
  }
}
