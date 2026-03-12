class Profile {
  int? id;
  String? deviceId;
  String? notificationId;


  Profile({
    this.id,
    required this.deviceId,
    required this.notificationId
  });

  factory Profile.fromJson(Map<String, dynamic> json){
    return Profile(
        id: json['id'],
        deviceId: json["device_id"],
        notificationId: json["notification_id"],

    );
  }

  factory Profile.fromDb(Map<String, dynamic> json){
    return Profile(
      id: json['id'],
      deviceId: json["device_id"],
      notificationId: json["notification_id"],
    );
  }


  Map<String, dynamic> toJson() => {
    "id": id,
    "device_id": deviceId,
    "notification_id": notificationId
  };

  Map<String, dynamic> toDb() => {
    "id": id,
    "device_id": deviceId,
    "notification_id": notificationId
  };

}

class ProfileResponse {
  String? error;
  Profile? data;

  ProfileResponse({this.data, this.error});

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(data: json['data'], error: json['error']);
  }
}
