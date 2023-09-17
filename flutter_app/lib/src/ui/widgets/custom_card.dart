import 'package:flutter/material.dart';

import '../common/ui_color_helper.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    Key? key,
    required this.index,
    required this.deviceId,
    required this.deviceName,
    required this.latitude,
    required this.longitude,
    required this.function,
  }) : super(key: key);

  final int index;
  final String deviceId;
  final String deviceName;
  final double latitude;
  final double longitude;
  final void Function() function;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: ListTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: UIColorHelper.DEFAULT_COLOR,
            ),
            child: Center(
              child: Text(deviceName.toString()[0].toUpperCase(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
            ),
          ),
          title: Text(
            deviceName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          subtitle: Text(
              'Device ID: $deviceId\nLatitude: $latitude\nLongitude: $longitude',
              style: const TextStyle(fontSize: 16)),
          trailing: IconButton(
            icon: const Icon(
              Icons.delete_forever,
              color: Colors.red,
              size: 40,
            ),
            onPressed: function,
          ),
        ),
      ),
    );
  }
}
