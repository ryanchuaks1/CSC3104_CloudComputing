import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import 'home_widget.dart' show HomeWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeModel extends FlutterFlowModel<HomeWidget> {
  ///  Local state fields for this page.

  List<BTDeviceStruct> scannedDevices = [];
  void addToScannedDevices(BTDeviceStruct item) => scannedDevices.add(item);
  void removeFromScannedDevices(BTDeviceStruct item) =>
      scannedDevices.remove(item);
  void removeAtIndexFromScannedDevices(int index) =>
      scannedDevices.removeAt(index);
  void insertAtIndexInScannedDevices(int index, BTDeviceStruct item) =>
      scannedDevices.insert(index, item);
  void updateScannedDevicesAtIndex(
          int index, Function(BTDeviceStruct) updateFn) =>
      scannedDevices[index] = updateFn(scannedDevices[index]);

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Custom Action - findDevices] action in Home widget.
  List<BTDeviceStruct>? foundDevices;
  // State field(s) for GoogleMap widget.
  LatLng? googleMapsCenter;
  final googleMapsController = Completer<GoogleMapController>();

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
