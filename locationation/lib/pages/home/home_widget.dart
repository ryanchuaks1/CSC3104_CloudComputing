import 'dart:async';
import 'dart:ffi';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:locationation/backend/schema/util/extra.dart';
import 'package:locationation/core/models/device_list_model.dart';
import 'package:locationation/core/models/device_model.dart';
import 'package:locationation/core/models/device_new_model.dart';
import 'package:locationation/core/services/api_service.dart';
import 'package:locationation/core/services/consumer/kafka_consumer_handler.dart';

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
import 'package:uuid/uuid.dart';
import 'home_model.dart';
export 'home_model.dart';

import 'package:geolocator/geolocator.dart';
import 'dart:convert'; // JSON Convert

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

  List<FlutterFlowMarker> markers = [
    FlutterFlowMarker(
      'marker1',
      'marker1',
      LatLng(1.38,
          103.8), // Use the LatLng class from the FlutterFlowMarker package
      () async {
        // Optional onTap function
        // You can define what happens when the marker is tapped here
      },
    ),
    FlutterFlowMarker(
      'marker2',
      'marker2',
      LatLng(1.48,
          103.8), // Use the LatLng class from the FlutterFlowMarker package
      () async {
        // Optional onTap function
        // You can define what happens when the marker is tapped here
      },
    ),
    // Add more markers as needed
  ];

  //Timer
  Timer? timer;
  Timer? publishing_timer;
  Timer? timer_2;
  Timer? get_location_timer;

  //Device ID
  String? _thisDeviceID;
  Device? current_device_object;

  List<DeviceNew> _devices = [];
  Map<String, KafkaConsumerHandler> _deviceSubcribers = {};

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
    timer_2 =
        Timer.periodic(Duration(seconds: 10), (Timer t) => scanBLEDevices());

    ApiService().getDeviceId().then((value) {
      setState(() {
        _thisDeviceID = value;
        print('########################DEVICE ID: $value');

        String curr_device_id = value ?? "";
        if (curr_device_id != "") {
          Device newdevice = Device(
              userId: widget.current_user,
              deviceId: curr_device_id,
              deviceName: widget.current_user + "'s Device",
              latitude: double.parse("0.0"),
              longitude: double.parse("0.0"));

          ApiService().addNewDevice(newdevice);
          current_device_object = newdevice;
        } else {
          print("Fail to add current Device");
        }
      });
    });

    publishing_timer = Timer.periodic(
        Duration(seconds: 15), (Timer t) => publishDeviceLocation());

    get_location_timer = Timer.periodic(
        Duration(seconds: 5), (Timer t) => getUpdatedDeviceLocations());

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

  static int curr_list_length_all_devices = 0;

  Future<List<DeviceNew>> getAllDevices() async {
    print("Test");

    List<DeviceNew> curr_device_data_list =
        await ApiService().getAllDevices(widget.current_user);
    print(curr_device_data_list.length);

    // gRPC can be unreliable at time result in an empty list from the buffer
    //Check if there are new subscribers by comparing old and new length
    if (curr_device_data_list.length > curr_list_length_all_devices) {
      //If there is a difference, resubscribe
      _devices = curr_device_data_list;
      subscribeToAllDevices();
      curr_list_length_all_devices = _devices.length;
    }

    setState(() {});
    return _devices;
  }

  Future<Position?> getCurrentDeviceLocation() async {
    try {
      // Request permission to access the device's location
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return null;
      }

      // Get the current location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return position;
    } catch (e) {
      print("Error getting location: $e");
      return null;
    }
  }

  //Publishing Location Working
  Future<void> publishDeviceLocation() async {
    print("DEV MSG: Publishing Device Location");

    //TODO: Device ID will be replaces with a getThisDevice Function
    Position? curr_location = await getCurrentDeviceLocation();

    print('########################DEVICE ID: ${_thisDeviceID}');
    print('########################DEVICE ID: ${_thisDeviceID}');
    print('########################DEVICE ID: ${_thisDeviceID}');

    if (curr_location == null)
      return; //return since there is no location to publish

    current_device_object!.latitude = curr_location.latitude;
    current_device_object!.longitude = curr_location.longitude;

    print(
        "Publishing to ${current_device_object!.deviceId} : Latitude(${curr_location.latitude}), Longitude(${curr_location.longitude})");

    if (current_device_object!.deviceId == "") {
      print("ERROR GETTING DEVICE ID");
    }

    print("DEVICE TO PUBLISH: ${current_device_object!.deviceId}");
    final _respond =
        await ApiService().publishCurrentLocation(current_device_object!);
    print("Success: ${_respond}");
  }

  //Subscribe to all the devices in the _devices list
  Future<void> subscribeToAllDevices() async {
    try {
      for (DeviceNew curr_device in _devices) {
        KafkaConsumerHandler? curr_handler =
            _deviceSubcribers[curr_device.deviceId];

        if (curr_handler == null) {
          curr_handler = KafkaConsumerHandler();
          //Add a list to reference each device later
          _deviceSubcribers[curr_device.deviceId] = curr_handler;
        }

        final uuid = Uuid();
        curr_handler.subscribeToDevice(uuid.v4(), curr_device.deviceId);
        print("Subscribed to ${curr_device.deviceId}");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //Get all teh Updated Device Locations
  Future<void> getUpdatedDeviceLocations() async {
    for (String curr_device_id in _deviceSubcribers.keys) {
      KafkaConsumerHandler? curr_handler = _deviceSubcribers[curr_device_id];

      if (curr_handler == null) {
        //If there is a null handler, resubscribe
        subscribeToAllDevices();
        return;
      } else {
        //TODO: Currently only print, need to pass the location

        //Refresh marker buffer

        String location_data_string = await curr_handler.getCurrentLocation();
        if (location_data_string != "") {
          print("LOCATION DATA: " + location_data_string);

          //Getting the String into a Json
          Map<String, dynamic> location_data =
              json.decode(location_data_string);

          double latitude_location_data =
              double.parse(location_data["latitude"]);
          double longitude_location_data =
              double.parse(location_data["longitude"]);

          FlutterFlowMarker curr_marker = FlutterFlowMarker(
            curr_device_id,
            curr_device_id,
            LatLng(latitude_location_data,
                longitude_location_data), // Use the LatLng class from the FlutterFlowMarker package
            () async {
              // Optional onTap function
              // You can define what happens when the marker is tapped here
            },
          );

          markers.add(curr_marker);
          print(
              "LOCATION DATA IN JSON: ${location_data["latitude"]}, ${location_data["longitude"]}");
        }
      }
    }

    setState(() {});
  }

  Future scanBLEDevices() async {
    Position? curr_location =
        await getCurrentDeviceLocation(); //getCurrentLocation
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

            if (_value.isNotEmpty && curr_location != null) {
              Device curr_pico_device = await Device(
                  userId:
                      "NULL", //Dont need to mention the userid of this pico in when publishing
                  deviceId: _value,
                  deviceName: _value,
                  latitude: curr_location.latitude,
                  longitude: curr_location.longitude);

              final _respond =
                  await ApiService().publishCurrentLocation(curr_pico_device);
              print("Current Pico Device: ${_respond}");
            }
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

    get_location_timer!.cancel();
    get_location_timer = null;

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
                      markers: markers,
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
                                            (_thisDeviceID ==
                                                    devicesItem.deviceId)
                                                ? "Current Device"
                                                : "Another Device",
                                            style: FlutterFlowTheme.of(context)
                                                .headlineSmall
                                                .override(
                                                  fontFamily: 'Work Sans',
                                                  fontSize: 18.0,
                                                ),
                                          ),
                                          Text(
                                            'Device ID: ' +
                                                devicesItem.deviceId,
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
