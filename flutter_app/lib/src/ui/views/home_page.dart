import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/src/ui/views/utils/extra.dart';
import 'package:flutter_app/src/ui/views/utils/snackbar.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_app/src/core/constants/app_constants.dart';
import 'package:flutter_app/src/ui/common/show_toast_message.dart';

import '../../core/models/device_list_model.dart';
import '../../core/models/device_model.dart';
import '../../core/services/api_service.dart';
import '../widgets/custom_card.dart';
import '../widgets/default_custom_button.dart';
import '../widgets/google_map_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<BluetoothDevice> _connectedDevices = [];
  List<ScanResult> _scanResults = [];
  bool _isScanning = true;
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;
  String _value = "";
  late StreamSubscription<List<int>> _lastValueSubscription;

  late final _deviceIdController;
  List<DeviceList> _deviceList = [];
  String _id = "";

  Timer? timer;

  @override
  void initState() {
    super.initState();
    _deviceIdController = TextEditingController();

    timer =
        Timer.periodic(Duration(seconds: 30), (Timer t) => scanBLEDevices());
  }

  Future scanBLEDevices() async {
// Setup Listener for scan results.
// device not found? see "Common Problems" in the README
    var subscription = FlutterBluePlus.scanResults.listen(
      (results) async {
        for (ScanResult r in results) {
          if (r.advertisementData.localName == "mpy-uart") {
            ScanResult targetDevice;
            targetDevice = r;
            targetDevice.device.connectionState
                .listen((BluetoothConnectionState state) async {
              if (state == BluetoothConnectionState.disconnected) {
                // 1. typically, start a periodic timer that tries to
                //    periodically reconnect, or just call connect() again right now
                // 2. you must always re-discover services after disconnection!
              }
            });
            await targetDevice.device.connect();

            targetDevice.device.connectAndUpdateStream().catchError((e) {
              Snackbar.show(ABC.c, prettyException("Connect Error:", e),
                  success: false);
            });
            await receiveData(targetDevice.device);
            print(_value);
          }
        }
      },
    );

    // Start scanning
    await FlutterBluePlus.startScan(timeout: Duration(seconds: 5));
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
          final value = await characteristic.read();
          device.disconnect(timeout: 3);
          _value = String.fromCharCodes(value);
          return String.fromCharCodes(value);
        }
      }
    }
    return null;
  }

  @override
  void dispose() {
    _deviceIdController.dispose();
    timer?.cancel();
    _scanResultsSubscription.cancel();
    _isScanningSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: FutureBuilder(
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const ErrorOccurred(); // Cant connect to the API
            case ConnectionState.active:
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(), // Loader animation
              );
            case ConnectionState.done:
              _deviceList = snapshot.data != null
                  ? snapshot.data as List<DeviceList>
                  : const [];
              return showData; // Show the actual body of the page
            default:
              return const ErrorOccurred();
          }
        },
        future: ApiService().getAllDevices(),
      ),
    );
  }

  Widget get showData => Column(
        // This is the actual body of the page
        children: <Widget>[
          const Expanded(child: GoogleMapWidget()),
          newDevicePanel,
          // updateDeviceButton,
        ],
      );

  Widget get newDevicePanel => DevicePanel(
        widget: Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 10),
                _deviceList.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return showCard(
                              index,
                              _deviceList[index].deviceId,
                              _deviceList[index].deviceName,
                              _deviceList[index].latitude,
                              _deviceList[index].longitude,
                              _deviceList[index].id,
                            );
                          },
                          itemCount: _deviceList.length,
                        ),
                      )
                    : const NoSavedData(),
                ElevatedButton(
                  onPressed: () async {
                    await _showAddDeviceDialog(context, () {
                      setState(
                          () {}); // refresh the page after dialog is closed
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Icon(Icons.add),
                )
              ],
            ),
          ),
        ),
      );

  Widget showCard(
    int index,
    String deviceId,
    String deviceName,
    double latitude,
    double longitude,
    String id,
  ) =>
      GestureDetector(
        onTap: () {
          _deviceIdController.text = deviceId;
          _id = id;
        },
        child: CustomCard(
          index: index + 1,
          deviceId: deviceId,
          deviceName: deviceName,
          latitude: latitude,
          longitude: longitude,
          function: () async {
            _id = id;
            await ApiService().deleteDevice(_id).then((data) {
              if (data.result == true) {
                setState(() {
                  _deviceIdController.clear();
                  ShowToastMessage.showCenterShortToast("SUCCESS");
                });
              } else {
                ShowToastMessage.showCenterShortToast("ERROR");
              }
            });
          },
        ),
      );

  // Widget get updateDeviceButton => DefaultRaisedButton(
  //       height: 55,
  //       label: 'Update',
  //       color: Colors.cyanAccent,
  //       onPressed: () async {
  //         await ApiService()
  //             .updateDevice(_deviceIdController.text, _id)
  //             .then((data) {
  //           if (data.result == true) {
  //             setState(() {
  //               _deviceIdController.clear();
  //               ShowToastMessage.showCenterShortToast("SUCCESS");
  //             });
  //           } else {
  //             ShowToastMessage.showCenterShortToast("ERROR");
  //           }
  //         });
  //       },
  //     );
}

class DevicePanel extends StatelessWidget {
  final Widget? widget;

  const DevicePanel({Key? key, this.widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return widget ?? const SizedBox.shrink();
  }
}

class ErrorOccurred extends StatelessWidget {
  const ErrorOccurred({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: const Text("Try to load data again"),
    );
  }
}

class NoSavedData extends StatelessWidget {
  const NoSavedData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.airline_seat_individual_suite,
          size: 55,
        ),
        SizedBox(height: 10),
        Text(
          "NO SAVED DATA",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.red,
          ),
        ),
        Padding(padding: EdgeInsets.all(8)),
      ],
    );
  }
}

Future<void> _showAddDeviceDialog(
    BuildContext context, Function() onDialogDismissed) async {
  final TextEditingController _deviceNameController = TextEditingController();
  const uuid = Uuid();

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Add New Device'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              controller: _deviceNameController,
              decoration: InputDecoration(labelText: 'Device Name'),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Save'),
            onPressed: () async {
              await ApiService()
                  .addNewDevice(Device(
                      userId: "testing",
                      deviceId: uuid.v4(),
                      deviceName: _deviceNameController.text,
                      latitude: 0,
                      longitude: 0))
                  .then((data) {
                if (data.result == "True") {
                  _deviceNameController.clear();
                  ShowToastMessage.showCenterShortToast("SUCCESS");
                  Navigator.of(context).pop(); // DRY?
                  onDialogDismissed(); // DRY?
                } else {
                  print(data.result);
                  ShowToastMessage.showCenterShortToast(data.result);
                  Navigator.of(context).pop(); // DRY?
                  onDialogDismissed(); // DRY?
                }
              });
            },
          ),
        ],
      );
    },
  );
}
