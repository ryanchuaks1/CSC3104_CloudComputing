class Device {
  late String deviceId;

  Device({
    required this.deviceId,
  });

  Device.fromJson(Map<String, dynamic> json) {
    deviceId = json['deviceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deviceId'] = this.deviceId;
    return data;
  }
}
