import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import 'add_device_widget.dart' show AddDeviceWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddDeviceModel extends FlutterFlowModel<AddDeviceWidget> {
  ///  Local state fields for this page.

  bool isBluetoothEnabled = false;

  bool isFetchingDevices = false;

  List<BTDeviceStruct> foundDevices = [];
  void addToFoundDevices(BTDeviceStruct item) => foundDevices.add(item);
  void removeFromFoundDevices(BTDeviceStruct item) => foundDevices.remove(item);
  void removeAtIndexFromFoundDevices(int index) => foundDevices.removeAt(index);
  void insertAtIndexInFoundDevices(int index, BTDeviceStruct item) =>
      foundDevices.insert(index, item);
  void updateFoundDevicesAtIndex(
          int index, Function(BTDeviceStruct) updateFn) =>
      foundDevices[index] = updateFn(foundDevices[index]);

  List<BTDeviceStruct> connectedDevices = [];
  void addToConnectedDevices(BTDeviceStruct item) => connectedDevices.add(item);
  void removeFromConnectedDevices(BTDeviceStruct item) =>
      connectedDevices.remove(item);
  void removeAtIndexFromConnectedDevices(int index) =>
      connectedDevices.removeAt(index);
  void insertAtIndexInConnectedDevices(int index, BTDeviceStruct item) =>
      connectedDevices.insert(index, item);
  void updateConnectedDevicesAtIndex(
          int index, Function(BTDeviceStruct) updateFn) =>
      connectedDevices[index] = updateFn(connectedDevices[index]);

  bool isFetchingConnectedDevices = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - getConnectedDevices] action in AddDevice widget.
  List<BTDeviceStruct>? fetchedConnectedDevices;
  // Stores action output result for [Custom Action - findDevices] action in AddDevice widget.
  List<BTDeviceStruct>? devices;
  // State field(s) for yourName widget.
  FocusNode? yourNameFocusNode;
  TextEditingController? yourNameController;
  String? Function(BuildContext, String?)? yourNameControllerValidator;
  // State field(s) for Switch widget.
  bool? switchValue;
  // Stores action output result for [Custom Action - turnOnBluetooth] action in Switch widget.
  bool? isTurningOn;
  // Stores action output result for [Custom Action - getConnectedDevices] action in Switch widget.
  List<BTDeviceStruct>? fetchedConnectedDevices2;
  // Stores action output result for [Custom Action - findDevices] action in Switch widget.
  List<BTDeviceStruct>? devices2;
  // Stores action output result for [Custom Action - turnOffBluetooth] action in Switch widget.
  bool? isTurningOff;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    yourNameFocusNode?.dispose();
    yourNameController?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
