// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:io';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

Future<bool> isBluetoothEnabled() async {
  bool result = false;
  if (await FlutterBluePlus.isSupported == false) {
    print("Bluetooth not suppored by this device.");
    result = false;
    return result;
  }

  FlutterBluePlus.adapterState.listen((state) {
    if (state != BluetoothAdapterState.on) {
      result = false;
    }
  });

  if (Platform.isAndroid) {
    await FlutterBluePlus.turnOn();
    result = true;
  }
  return result;
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
