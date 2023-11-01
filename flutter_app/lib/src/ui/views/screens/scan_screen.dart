import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/src/core/models/device_model.dart';
import 'package:flutter_app/src/core/services/api_service.dart';
import 'package:flutter_app/src/ui/common/show_toast_message.dart';
import 'package:flutter_app/src/ui/views/home_page.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'device_screen.dart';
import '../utils/snackbar.dart';
import '../widgets/connected_device_tile.dart';
import '../widgets/scan_result_tile.dart';
import '../utils/extra.dart';
import '../widgets/characteristic_tile.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  List<BluetoothDevice> _connectedDevices = [];
  List<ScanResult> _scanResults = [];
  bool _isScanning = false;
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;
  String _value = "";
  late StreamSubscription<List<int>> _lastValueSubscription;
  late String userId;

  @override
  void initState() {
    super.initState();

    FlutterBluePlus.systemDevices.then((devices) {
      _connectedDevices = devices;
      setState(() {});
    });

    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      _scanResults = results;
      setState(() {});
    });

    _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
      _isScanning = state;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _scanResultsSubscription.cancel();
    _isScanningSubscription.cancel();
    super.dispose();
  }

  Future onScanPressed() async {
    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    } catch (e) {
      Snackbar.show(ABC.b, prettyException("Start Scan Error:", e),
          success: false);
    }
    setState(() {}); // force refresh of systemDevices
  }

  Future onStopPressed() async {
    try {
      FlutterBluePlus.stopScan();
    } catch (e) {
      Snackbar.show(ABC.b, prettyException("Stop Scan Error:", e),
          success: false);
    }
  }

  Future<void> onConnectPressed(BluetoothDevice device) async {
    device.connectAndUpdateStream().catchError((e) {
      Snackbar.show(ABC.c, prettyException("Connect Error:", e),
          success: false);
    });
    await receiveData(device);
    print(_value);

    await ApiService()
        .addNewDevice(Device(
            userId: "testing",
            deviceId: _value,
            deviceName: "Pico W",
            latitude: 0,
            longitude: 0))
        .then((data) {
      if (data.result == "True") {
        print("test");
        ShowToastMessage.showCenterShortToast("SUCCESS");
      } else {
        print(data.result);
        ShowToastMessage.showCenterShortToast(data.result);
      }
    });
    // MaterialPageRoute route = MaterialPageRoute(
    //     builder: (context) => DeviceScreen(device: device),
    //     settings: RouteSettings(name: '/DeviceScreen'));
    // Navigator.of(context).push(route);
  }

  Future<String?> receiveData(BluetoothDevice device) async {
    final services = await device.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        print(characteristic);
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
          _value = String.fromCharCodes(value);
          return String.fromCharCodes(value);
        }
      }
    }
    return null;
  }

  Future onRefresh() {
    if (_isScanning == false) {
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    }
    setState(() {});
    return Future.delayed(Duration(milliseconds: 500));
  }

  Widget buildScanButton(BuildContext context) {
    if (FlutterBluePlus.isScanningNow) {
      return FloatingActionButton(
        child: const Icon(Icons.stop),
        onPressed: onStopPressed,
        backgroundColor: Colors.red,
      );
    } else {
      return FloatingActionButton(
          child: const Text("SCAN"), onPressed: onScanPressed);
    }
  }

  List<Widget> _buildConnectedDeviceTiles(BuildContext context) {
    return _connectedDevices
        .map(
          (d) => ConnectedDeviceTile(
            device: d,
            onOpen: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DeviceScreen(device: d),
                settings: RouteSettings(name: '/DeviceScreen'),
              ),
            ),
            onConnect: () => onConnectPressed(d),
          ),
        )
        .toList();
  }

  List<Widget> _buildScanResultTiles(BuildContext context) {
    return _scanResults
        .map(
          (r) => ScanResultTile(
            result: r,
            onTap: () => onConnectPressed(r.device),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: Snackbar.snackBarKeyB,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Find Devices'),
        ),
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView(
            children: <Widget>[
              ..._buildConnectedDeviceTiles(context),
              ..._buildScanResultTiles(context),
            ],
          ),
        ),
        floatingActionButton: buildScanButton(context),
      ),
    );
  }
}
