
class NotificationId {
  final int? id;
  final String? notificationId;


  NotificationId({
    this.id,
    this.notificationId,
  });

  NotificationId copyWith(
      {int? id,
        String? notificationId,
   }) {
    return NotificationId(
        id: id ?? this.id,
        notificationId: notificationId ?? this.notificationId
    );
  }

  factory NotificationId.fromJson(Map<String, dynamic> data) {

    return NotificationId(
      id: data["id"],
      notificationId: data["notification_id"],

    );
  }

  factory NotificationId.fromDb(Map<String, dynamic> data) {


    return NotificationId(
      id: data["id"],
      notificationId: data["notification_id"],

    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "notification_id": notificationId,
  };

  Map<String, dynamic> toDb() => {
    "id": id,
    "notification_id": notificationId
  };
}


class NotificationIdResponse {
  String? error;
  NotificationId? data;

  NotificationIdResponse({this.data, this.error});

  factory NotificationIdResponse.fromJson(Map<String, dynamic> json) {
    return NotificationIdResponse(data: json['data'], error: json['error']);
  }
}
