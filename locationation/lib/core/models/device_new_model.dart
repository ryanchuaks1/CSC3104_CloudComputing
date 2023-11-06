import 'dart:convert';

List<DeviceNew> deviceListFromJson(String str) =>
    List<DeviceNew>.from(json.decode(str).map((x) => DeviceNew.fromJson(x)));

String deviceListToJson(List<DeviceNew> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DeviceNew {
  DeviceNew({
    required this.userId,
    required this.deviceId,
  });

  String userId;
  String deviceId;

  factory DeviceNew.fromJson(Map<String, dynamic> json) => DeviceNew(
        userId: json["userId"],
        deviceId: json["deviceId"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "deviceId": deviceId,
      };
}
