// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

Future<List<BTDeviceStruct>> getConnectedDevices() async {
  final connectedDevices = await FlutterBluePlus.connectedDevices;
  List<BTDeviceStruct> devices = [];
  for (int i = 0; i < connectedDevices.length; i++) {
    final deviceResult = connectedDevices[i];
    final deviceState = await deviceResult.connectionState;
    deviceResult.connectionState.listen((BluetoothConnectionState state) async {
      if (state == BluetoothConnectionState.connected) {
        final deviceRssi = await deviceResult.readRssi();
        devices.add(BTDeviceStruct(
            name: deviceResult.platformName,
            id: deviceResult.remoteId.toString(),
            rssi: deviceRssi));
      }
    });
  }
  return devices;
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!