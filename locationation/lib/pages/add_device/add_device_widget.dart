import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:locationation/backend/schema/util/snackbar.dart';
import 'package:locationation/core/models/device_model.dart';
import 'package:locationation/core/services/api_service.dart';

import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'add_device_model.dart';
export 'add_device_model.dart';

class AddDeviceWidget extends StatefulWidget {
  const AddDeviceWidget({
    Key? key,
    required this.isBTEnabled,
    required this.current_user,
  }) : super(key: key);

  final bool? isBTEnabled;
  final String current_user;

  @override
  _AddDeviceWidgetState createState() => _AddDeviceWidgetState();
}

class _AddDeviceWidgetState extends State<AddDeviceWidget> {
  late AddDeviceModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  late String selected_bluetooth_device = "";

  late String ble_device_id;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddDeviceModel());
    print("Found Devices");
    print(_model.devices2);

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        _model.isBluetoothEnabled = widget.isBTEnabled!;
      });
      if (_model.isBluetoothEnabled ? true : true) {
        setState(() {
          _model.isFetchingDevices = true;
          _model.isFetchingConnectedDevices = true;
        });
        _model.fetchedConnectedDevices = await actions.getConnectedDevices();
        setState(() {
          _model.isFetchingConnectedDevices = false;
          _model.connectedDevices =
              _model.fetchedConnectedDevices!.toList().cast<BTDeviceStruct>();
        });
        _model.devices = await actions.findDevices();
        setState(() {
          _model.isFetchingDevices = false;
          _model.foundDevices = _model.devices!.toList().cast<BTDeviceStruct>();
        });
      }
    });

    _model.yourNameController ??= TextEditingController();
    _model.yourNameFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          actions: [],
          flexibleSpace: FlexibleSpaceBar(
            title: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 14.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              12.0, 0.0, 0.0, 0.0),
                          child: FlutterFlowIconButton(
                            borderColor: Colors.transparent,
                            borderRadius: 30.0,
                            borderWidth: 1.0,
                            buttonSize: 50.0,
                            icon: Icon(
                              Icons.arrow_back_rounded,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 30.0,
                            ),
                            onPressed: () async {
                              if (Navigator.of(context).canPop()) {
                                context.pop();
                              }
                              context.pushNamed('Home',
                                  queryParameters: {
                                    'isScrolling': serializeParam(
                                      false,
                                      ParamType.bool,
                                    ),
                                    'current_user': serializeParam(
                                        widget.current_user, ParamType.String),
                                  }.withoutNulls,
                                  extra: <String, dynamic>{
                                    kTransitionInfoKey: TransitionInfo(
                                      hasTransition: true,
                                      transitionType: PageTransitionType.fade,
                                      duration: Duration(milliseconds: 200),
                                    ),
                                  });
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              24.0, 0.0, 0.0, 0.0),
                          child: Text(
                            'Add your device',
                            style: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .override(
                                  fontFamily: 'Work Sans',
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 22.0,
                                ),
                          ),
                        ),  
                      ],
                    ),
                  ),
                ],
              ),
            ),
            centerTitle: true,
            expandedTitleScale: 1.0,
          ),
          elevation: 0.0,
        ),
      ),
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 16.0),
              child: TextFormField(
                controller: _model.yourNameController,
                focusNode: _model.yourNameFocusNode,
                textCapitalization: TextCapitalization.words,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Device Name',
                  labelStyle: FlutterFlowTheme.of(context).labelMedium,
                  hintStyle: FlutterFlowTheme.of(context).labelMedium,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).alternate,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).primary,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).error,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).error,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                  contentPadding:
                      EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 0.0, 24.0),
                ),
                style: FlutterFlowTheme.of(context).bodyMedium,
                validator:
                    _model.yourNameControllerValidator.asValidator(context),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: AlignmentDirectional(-1.00, 0.00),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 0.0, 0.0),
                      child: Text(
                        'Bluetooth',
                        style: FlutterFlowTheme.of(context).bodyLarge,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 20.0, 0.0),
                    child: Switch.adaptive(
                      value: _model.switchValue ??= widget.isBTEnabled!,
                      onChanged: (newValue) async {
                        setState(() => _model.switchValue = newValue!);
                        if (newValue!) {
                          _model.isTurningOn = await actions.turnOnBluetooth();
                          await Future.delayed(
                              const Duration(milliseconds: 1000));
                          setState(() {
                            _model.isBluetoothEnabled = true;
                          });

                          // context.pushNamed(
                          //   'AddDevice',
                          //   queryParameters: {
                          //     'isBTEnabled': serializeParam(
                          //       false,
                          //       ParamType.bool,
                          //     ),
                          //     'current_user': serializeParam(
                          //         widget.current_user, ParamType.String),
                          //   }.withoutNulls,
                          // );

                          if (_model.isBluetoothEnabled ? true : true) {
                            setState(() {
                              _model.isFetchingDevices = true;
                              _model.isFetchingConnectedDevices = true;
                            });
                            _model.fetchedConnectedDevices2 =
                                await actions.getConnectedDevices();
                            setState(() {
                              _model.isFetchingConnectedDevices = false;
                              _model.connectedDevices = _model
                                  .fetchedConnectedDevices2!
                                  .toList()
                                  .cast<BTDeviceStruct>();
                            });
                            _model.devices2 = await actions.findDevices();
                            setState(() {
                              _model.isFetchingDevices = false;
                              _model.foundDevices = _model.devices2!
                                  .toList()
                                  .cast<BTDeviceStruct>();
                            });
                          }
                          setState(() {});

                          Future.delayed(const Duration(seconds: 1));
                        } else {
                          _model.isTurningOff =
                              await actions.turnOffBluetooth();
                          _model.devices2 = [];
                          setState(() {
                            _model.isBluetoothEnabled = false;
                          });

                          setState(() {});
                        }
                      },
                      activeColor: FlutterFlowTheme.of(context).primary,
                      activeTrackColor: FlutterFlowTheme.of(context).accent1,
                      inactiveTrackColor:
                          FlutterFlowTheme.of(context).alternate,
                      inactiveThumbColor:
                          FlutterFlowTheme.of(context).secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Builder(
                builder: (context) {
                  final displayConnectedDevices = _model.foundDevices.toList();
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: displayConnectedDevices.length,
                    itemBuilder: (context, displayConnectedDevicesIndex) {
                      final displayConnectedDevicesItem =
                          displayConnectedDevices[displayConnectedDevicesIndex];
                      return Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            10.0, 10.0, 10.0, 10.0),
                        child: new GestureDetector(
                          onTap: () {
                            selected_bluetooth_device =
                                displayConnectedDevicesItem.id;
                            print(selected_bluetooth_device);
                            setState(() {});
                          },
                          child: Container(
                            width: 100.0,
                            height: 70.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).accent1,
                              borderRadius: BorderRadius.circular(15.0),
                              border: selected_bluetooth_device ==
                                      displayConnectedDevicesItem.id
                                  ? Border.all(width: 2, color: Colors.blue)
                                  : null,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  displayConnectedDevicesItem.name,
                                  style:
                                      FlutterFlowTheme.of(context).bodyMedium,
                                ),
                                Text(
                                  displayConnectedDevicesItem.id,
                                  style:
                                      FlutterFlowTheme.of(context).bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0.00, 0.05),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                child: FFButtonWidget(
                  onPressed: () async {
                    final device =
                        BluetoothDevice.fromId(selected_bluetooth_device);
                    print(device);
                    try {
                      await device.connect(timeout: const Duration(seconds: 5));
                      await receiveData(device);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Failed to add device, Please try again.",
                            style: FlutterFlowTheme.of(context).bodyMedium),
                        backgroundColor: Colors.red,
                      ));
                      setState(() {});
                    }

                    if (ble_device_id.isNotEmpty) {
                      await ApiService()
                          .addNewDevice(Device(
                        userId: widget.current_user,
                        deviceId: ble_device_id,
                        deviceName: "Pico W",
                        latitude: 0,
                        longitude: 0,
                      ))
                          .then((data) {
                        if (data.result == "True") {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Successfully added device",
                                style: FlutterFlowTheme.of(context).bodyMedium),
                            backgroundColor: Colors.blue,
                          ));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Failed to add device, Please try again.",
                                style: FlutterFlowTheme.of(context).bodyMedium),
                            backgroundColor: Colors.red,
                          ));
                        }
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Failed to add device, Please try again.",
                            style: FlutterFlowTheme.of(context).bodyMedium),
                        backgroundColor: Colors.red,
                      ));
                    }
                    setState(() {});
                    print(ble_device_id);
                  },
                  text: 'Add Device',
                  options: FFButtonOptions(
                    width: 270.0,
                    height: 50.0,
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle:
                        FlutterFlowTheme.of(context).titleMedium.override(
                              fontFamily: 'Manrope',
                              color: Colors.white,
                            ),
                    elevation: 2.0,
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> receiveData(BluetoothDevice device) async {
    final services = await device.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        final isRead = characteristic.properties.read;
        final isNotify = characteristic.properties.notify;

        if (isRead && isNotify) {
          final subscription =
              characteristic.onValueReceived.listen((value) {});
          device.cancelWhenDisconnected(subscription);
          await characteristic.setNotifyValue(true);
          Future.delayed(const Duration(seconds: 5));
          final value = await characteristic.read();
          device.disconnect(timeout: 10);
          ble_device_id = String.fromCharCodes(value);
          return String.fromCharCodes(value);
        }
      }
    }
  }
}
