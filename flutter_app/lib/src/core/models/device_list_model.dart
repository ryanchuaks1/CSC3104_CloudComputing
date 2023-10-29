import 'dart:convert';

List<DeviceList> deviceListFromJson(String str) =>
    List<DeviceList>.from(json.decode(str).map((x) => DeviceList.fromJson(x)));

String deviceListToJson(List<DeviceList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DeviceList {
  DeviceList({
    required this.id,
    required this.userId,
    required this.deviceId,
    required this.deviceName,
    required this.latitude,
    required this.longitude,
  });

  String id;
  String userId;
  String deviceId;
  String deviceName;
  double latitude;
  double longitude;

  factory DeviceList.fromJson(Map<String, dynamic> json) => DeviceList(
        id: json["_id"]["\$oid"],
        userId: json["userId"],
        deviceId: json["deviceId"],
        deviceName: json["deviceName"],
        latitude: json["latitude"],
        longitude: json["longitude"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "deviceId": deviceId,
        "deviceName": deviceName,
        "latitude": latitude,
        "longitude": longitude,
      };
}
