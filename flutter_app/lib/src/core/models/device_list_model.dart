import 'dart:convert';

List<DeviceList> deviceListFromJson(String str) => List<DeviceList>.from(json.decode(str).map((x) => DeviceList.fromJson(x)));

String deviceListToJson(List<DeviceList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DeviceList {
    DeviceList({
        required this.id,
        required this.deviceId,
    });

    String id;
    String deviceId;

    factory DeviceList.fromJson(Map<String, dynamic> json) => DeviceList(
        id: json["_id"],
        deviceId: json["deviceId"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "deviceId": deviceId,
    };
}