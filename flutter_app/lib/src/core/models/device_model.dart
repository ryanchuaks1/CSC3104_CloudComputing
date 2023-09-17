class Device {
  late String deviceId;
  late String deviceName;
  late double latitude; // Device location latitude
  late double longitude; // Device location longitude

  Device({
    required this.deviceId,
    required this.deviceName,
    required this.latitude,
    required this.longitude,
  });

  Device.fromJson(Map<String, dynamic> json) {
    deviceId = json['deviceId'];
    deviceName = json['deviceName'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deviceId'] = deviceId;
    data['deviceName'] = deviceName;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
