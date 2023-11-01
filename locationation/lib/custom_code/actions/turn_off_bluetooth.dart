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

Future<bool> turnOffBluetooth() async {
  if (isAndroid) {
    return await FlutterBluePlus.instance.turnOff();
  }
  return true;
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!