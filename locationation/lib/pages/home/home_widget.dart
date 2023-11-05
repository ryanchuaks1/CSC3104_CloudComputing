import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:locationation/backend/schema/util/extra.dart';
import 'package:locationation/core/models/device_list_model.dart';
import 'package:locationation/core/models/device_model.dart';
import 'package:locationation/core/models/device_new_model.dart';
import 'package:locationation/core/services/api_service.dart';

import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home_model.dart';
export 'home_model.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({
    Key? key,
    bool? isScrolling,
    required this.current_user,
  })  : this.isScrolling = isScrolling ?? true,
        super(key: key);

  final bool isScrolling;
  final String current_user;

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> with TickerProviderStateMixin {
  late HomeModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  //Device Currently for Testing
  Device curr_device = Device(
      userId: "test_user",
      deviceId: "f1740855-6716-11ee-9b42-107b44",
      deviceName: "Testing_device",
      latitude: double.parse("10.0"),
      longitude: double.parse("20.0"));

  //Timer
  Timer? timer;
  Timer? publishing_timer;
  Timer? timer_2;

  //Device ID
  String? _thisDeviceID;

  List<DeviceNew> _devices = [];

  String _value = "";

  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;

  final animationsMap = {
    'containerOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
      ],
    ),
  };

  @override
  void initState() {
    super.initState();
    print(widget.current_user);
    _model = createModel(context, () => HomeModel());

    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => getAllDevices());

    publishing_timer = Timer.periodic(
        Duration(seconds: 5), (Timer t) => publishDeviceLocation());
    timer_2 =
        Timer.periodic(Duration(seconds: 10), (Timer t) => scanBLEDevices());

    ApiService().getDeviceId().then((value) {
      setState(() {
        _thisDeviceID = value;
        print('Device ID: $value'); 

        String curr_device_id = value ?? "";
        if (curr_device_id != "") {

          Device newdevice = Device(
          userId: widget.current_user, 
          deviceId: curr_device_id, 
          deviceName: widget.current_user + "'s Device", 
          latitude: 0.0, 
          longitude: 0.0);

          ApiService().addNewDevice(newdevice);


          //Testing Code - To be Deleted
          Device tempdevice = Device(
          userId: widget.current_user, 
          deviceId: "tempdeviceID", 
          deviceName: widget.current_user + "'s Device", 
          latitude: 0.0, 
          longitude: 0.0);

          ApiService().addNewDevice(tempdevice);
          //END OF TESTING CODE


        }
        else
        {
          print("Fail to add current Device");
        }
      });
    });

    // On page load action.
    // SchedulerBinding.instance.addPostFrameCallback((_) async {
    //   _model.foundDevices = await actions.findDevices();
    //   setState(() {
    //     _model.scannedDevices =
    //         _model.foundDevices!.toList().cast<BTDeviceStruct>();
    //   });
    // });

    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
  }

  Future<List<DeviceNew>> getAllDevices() async {
    print("Test");

    List<DeviceNew> curr_device_data_list = await ApiService().getAllDevices(widget.current_user);
    print(curr_device_data_list.length);

    // gRPC can be unreliable at time result in an empty list from the buffer
    // Hence, when there is nothing in the list, dotn update
    if(curr_device_data_list.length != 0){
      _devices = curr_device_data_list;
    }
    
    setState(() {});
    return _devices;
  }

  Future<void> publishDeviceLocation() async {
    print("DEV MSG: Publishing Device Location");

    //TODO: Device ID will be replaces with a getThisDevice Function

    final _respond = await ApiService().publishCurrentLocation(curr_device);
    print("Success: ${_respond}");
  }

  Future scanBLEDevices() async {
    ScanResult targetDevice;
    _scanResultsSubscription =
        FlutterBluePlus.scanResults.listen((results) async {
      for (ScanResult r in results) {
        if (r.advertisementData.localName == "mpy-uart") {
          targetDevice = r;
          targetDevice.device.connectionState
              .listen((BluetoothConnectionState state) {
            if (state == BluetoothConnectionState.disconnected) {}
          });
          try {
            await targetDevice.device.connect();

            await receiveData(targetDevice.device);
            print(_value);
          } catch (e) {}
        }
      }
    });

    // Start scanning
    await FlutterBluePlus.startScan();

    Future.delayed(const Duration(seconds: 5));

    _scanResultsSubscription.cancel();
  }

  Future<String?> receiveData(BluetoothDevice device) async {
    try {
      List<BluetoothService> services = await device.discoverServices();
      for (BluetoothService service in services) {
        for (BluetoothCharacteristic characteristic
            in service.characteristics) {
          final isRead = characteristic.properties.read;
          final isNotify = characteristic.properties.notify;

          if (isRead && isNotify) {
            final subscription =
                characteristic.onValueReceived.listen((value) {});
            device.cancelWhenDisconnected(subscription);
            await characteristic.setNotifyValue(true);
            final value = await characteristic.read();
            await device.disconnect(timeout: 3);
            _value = String.fromCharCodes(value);
            return String.fromCharCodes(value);
          }
        }
      }
    } catch (e) {
      return null;
    }

    return null;
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
    timer!.cancel();
    timer = null;

    timer_2!.cancel();
    timer_2 = null;

    publishing_timer!.cancel();
    publishing_timer = null;

    _scanResultsSubscription.cancel();
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

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: MediaQuery.sizeOf(context).height * 0.65,
              child: Stack(
                children: [
                  Align(
                    alignment: AlignmentDirectional(0.00, 0.00),
                    child: FlutterFlowGoogleMap(
                      controller: _model.googleMapsController,
                      onCameraIdle: (latLng) =>
                          _model.googleMapsCenter = latLng,
                      initialLocation: _model.googleMapsCenter ??=
                          LatLng(1.38, 103.8),
                      markerColor: GoogleMarkerColor.violet,
                      mapType: MapType.normal,
                      style: GoogleMapStyle.standard,
                      initialZoom: 11.0,
                      allowInteraction: true,
                      allowZoom: true,
                      showZoomControls: false,
                      showLocation: true,
                      showCompass: false,
                      showMapToolbar: false,
                      showTraffic: false,
                      centerMapOnMarkerTap: true,
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(-1.00, -1.00),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(20.0, 40.0, 0.0, 0.0),
                      child: FlutterFlowIconButton(
                        borderColor: FlutterFlowTheme.of(context).primary,
                        borderRadius: 20.0,
                        borderWidth: 1.0,
                        buttonSize: 40.0,
                        fillColor: FlutterFlowTheme.of(context).primary,
                        icon: Icon(
                          Icons.logout,
                          color: Colors.white,
                          size: 18.0,
                        ),
                        onPressed: () async {
                          context.pushReplacementNamed(
                            'Login',
                            queryParameters: {
                              'isBTEnabled': serializeParam(
                                false,
                                ParamType.bool,
                              ),
                            }.withoutNulls,
                          );
                        },
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(0.00, 1.00),
                    child: Container(
                      width: MediaQuery.sizeOf(context).width * 1.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(0.0),
                          bottomRight: Radius.circular(0.0),
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(30.0),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(0.00, 0.00),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  20.0, 0.0, 0.0, 0.0),
                              child: Text(
                                'Devices',
                                style:
                                    FlutterFlowTheme.of(context).headlineSmall,
                              ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0.00, 0.00),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 20.0, 0.0),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  context.pushReplacementNamed(
                                    'AddDevice',
                                    queryParameters: {
                                      'isBTEnabled': serializeParam(
                                        false,
                                        ParamType.bool,
                                      ),
                                      'current_user': serializeParam(
                                          widget.current_user,
                                          ParamType.String),
                                    }.withoutNulls,
                                  );
                                },
                                text: 'Add',
                                options: FFButtonOptions(
                                  height: 40.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24.0, 0.0, 24.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: FlutterFlowTheme.of(context).primary,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Manrope',
                                        color: Colors.white,
                                      ),
                                  elevation: 3.0,
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  height: MediaQuery.sizeOf(context).height * 1.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: SingleChildScrollView(
                      child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: List.generate(_devices.length, (index) {
                      final devicesItem = _devices[index];
                      return Align(
                        alignment: AlignmentDirectional(0.00, -1.00),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              12.0, 12.0, 12.0, 12.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).accent1,
                              borderRadius: BorderRadius.circular(20.0),
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                color: Colors.white,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  12.0, 6.0, 12.0, 6.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          12.0, 0.0, 12.0, 0.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            (_thisDeviceID == devicesItem.deviceId) ? "Current Device" : "Another Device",
                                            style: FlutterFlowTheme.of(context)
                                                .headlineSmall
                                                .override(
                                                  fontFamily: 'Work Sans',
                                                  fontSize: 18.0,
                                                ),
                                          ),
                                          Text(
                                            'Device ID: ' + devicesItem.deviceId,
                                            style: FlutterFlowTheme.of(context)
                                                .bodySmall
                                                .override(
                                                  fontFamily:
                                                      'Plus Jakarta Sans',
                                                  color: Color(0xFF4B39EF),
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 4.0, 0.0, 0.0),
                                            child: Text(
                                              'Last Updated',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .labelMedium
                                                  .override(
                                                    fontFamily:
                                                        'Plus Jakarta Sans',
                                                    color: Color(0xFF57636C),
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_right_rounded,
                                    color: Color(0xFF57636C),
                                    size: 24.0,
                                  ),
                                ],
                              ),
                            ),
                          ).animateOnPageLoad(
                              animationsMap['containerOnPageLoadAnimation']!),
                        ),
                      );
                    }),
                  ))),
            )
            // child: Container(
            //   width: MediaQuery.sizeOf(context).width * 1.0,
            //   height: MediaQuery.sizeOf(context).height * 1.0,
            //   decoration: BoxDecoration(
            //     color: FlutterFlowTheme.of(context).secondaryBackground,
            //   ),
            //   child: FutureBuilder(
            //     future: getAllDevices(),
            //     builder: (context, snapshot) {
            //       // Customize what your widget looks like when it's loading.
            //       if (!snapshot.hasData) {
            //         return Center(
            //           child: Padding(
            //             padding: EdgeInsetsDirectional.fromSTEB(
            //                 0.0, 100.0, 0.0, 0.0),
            //             child: SizedBox(
            //               width: 50.0,
            //               height: 50.0,
            //               child: CircularProgressIndicator(
            //                 valueColor: AlwaysStoppedAnimation<Color>(
            //                   FlutterFlowTheme.of(context).primary,
            //                 ),
            //               ),
            //             ),
            //           ),
            //         );
            //       }
            //       return Builder(
            //         builder: (context) {
            //           final devices = snapshot.data != null
            //               ? snapshot.data as List<DeviceList>
            //               : const [];
            //           return SingleChildScrollView(
            //             child: Column(
            //               mainAxisSize: MainAxisSize.max,
            //               children:
            //                   List.generate(devices.length, (devicesIndex) {
            //                 final devicesItem = devices[devicesIndex];
            //                 return Align(
            //                   alignment: AlignmentDirectional(0.00, -1.00),
            //                   child: Padding(
            //                     padding: EdgeInsetsDirectional.fromSTEB(
            //                         12.0, 12.0, 12.0, 12.0),
            //                     child: Container(
            //                       width: double.infinity,
            //                       decoration: BoxDecoration(
            //                         color:
            //                             FlutterFlowTheme.of(context).accent1,
            //                         borderRadius: BorderRadius.circular(20.0),
            //                         shape: BoxShape.rectangle,
            //                         border: Border.all(
            //                           color: Colors.white,
            //                         ),
            //                       ),
            //                       child: Padding(
            //                         padding: EdgeInsetsDirectional.fromSTEB(
            //                             12.0, 6.0, 12.0, 6.0),
            //                         child: Row(
            //                           mainAxisSize: MainAxisSize.max,
            //                           mainAxisAlignment:
            //                               MainAxisAlignment.start,
            //                           crossAxisAlignment:
            //                               CrossAxisAlignment.center,
            //                           children: [
            //                             Expanded(
            //                               child: Padding(
            //                                 padding: EdgeInsetsDirectional
            //                                     .fromSTEB(
            //                                         12.0, 0.0, 12.0, 0.0),
            //                                 child: Column(
            //                                   mainAxisSize: MainAxisSize.min,
            //                                   mainAxisAlignment:
            //                                       MainAxisAlignment.start,
            //                                   crossAxisAlignment:
            //                                       CrossAxisAlignment.start,
            //                                   children: [
            //                                     Text(
            //                                       devicesItem.deviceName,
            //                                       style: FlutterFlowTheme.of(
            //                                               context)
            //                                           .headlineSmall
            //                                           .override(
            //                                             fontFamily:
            //                                                 'Work Sans',
            //                                             fontSize: 18.0,
            //                                           ),
            //                                     ),
            //                                     Text(
            //                                       'User',
            //                                       style: FlutterFlowTheme.of(
            //                                               context)
            //                                           .bodySmall
            //                                           .override(
            //                                             fontFamily:
            //                                                 'Plus Jakarta Sans',
            //                                             color:
            //                                                 Color(0xFF4B39EF),
            //                                             fontSize: 12.0,
            //                                             fontWeight:
            //                                                 FontWeight.w500,
            //                                           ),
            //                                     ),
            //                                     Padding(
            //                                       padding:
            //                                           EdgeInsetsDirectional
            //                                               .fromSTEB(0.0, 4.0,
            //                                                   0.0, 0.0),
            //                                       child: Text(
            //                                         'Last Updated',
            //                                         style: FlutterFlowTheme
            //                                                 .of(context)
            //                                             .labelMedium
            //                                             .override(
            //                                               fontFamily:
            //                                                   'Plus Jakarta Sans',
            //                                               color: Color(
            //                                                   0xFF57636C),
            //                                               fontSize: 12.0,
            //                                               fontWeight:
            //                                                   FontWeight.w500,
            //                                             ),
            //                                       ),
            //                                     ),
            //                                   ],
            //                                 ),
            //                               ),
            //                             ),
            //                             Icon(
            //                               Icons.keyboard_arrow_right_rounded,
            //                               color: Color(0xFF57636C),
            //                               size: 24.0,
            //                             ),
            //                           ],
            //                         ),
            //                       ),
            //                     ).animateOnPageLoad(animationsMap[
            //                         'containerOnPageLoadAnimation']!),
            //                   ),
            //                 );
            //               }),
            //             ),
            //           );
            //         },
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
