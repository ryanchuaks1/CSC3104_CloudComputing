import 'package:flutter/material.dart';
import 'package:flutter_app/src/core/constants/message_constants.dart';
import 'package:flutter_app/src/ui/common/show_toast_message.dart';

import '../../core/models/device_list_model.dart';
import '../../core/models/device_model.dart';
import '../../core/services/api_service.dart';
import '../common/ui_color_helper.dart';
import '../widgets/custom_card.dart';
import '../widgets/default_custom_button.dart';
import '../widgets/text_form_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final _deviceIdController;
  List<DeviceList> _deviceList = [];
  String _id = "";

  @override
  void initState() {
    super.initState();
    _deviceIdController = TextEditingController();
  }

  @override
  void dispose() {
    _deviceIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appbar,
      body: FutureBuilder(
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return ErrorOccurred();
            case ConnectionState.active:
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.done:
              _deviceList = snapshot.data != null
                  ? snapshot.data as List<DeviceList>
                  : const [];
              return showData;
            default:
              return const ErrorOccurred();
          }
        },
        future: ApiService().getAllDevices(),
      ),
    );
  }

  PreferredSize get appbar => PreferredSize(
        preferredSize: Size(double.infinity, 50),
        child: AppBar(
          title: const Text("Device Manager"),
          centerTitle: true,
          backgroundColor: UIColorHelper.DEFAULT_COLOR,
        ),
      );

  Widget get showData => Column(
        children: <Widget>[
          newDevicePanel,
          crudPanel,
        ],
      );

  Widget get newDevicePanel => DevicePanel(
        widget: Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: <Widget>[
                MyTextFormField(
                  label: 'Device Id',
                  controller: _deviceIdController,
                  nextButton: TextInputAction.next,
                ),
                const SizedBox(height: 10),
                _deviceList.length > 0
                    ? Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return showCard(
                              index,
                              _deviceList[index].deviceId,
                              _deviceList[index].id,
                            );
                          },
                          itemCount: _deviceList.length,
                        ),
                      )
                    : const NoSavedData(),
              ],
            ),
          ),
        ),
      );

  Widget get crudPanel => Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(child: addDeviceButton),
            Expanded(child: updateDeviceButton)
          ],
        ),
      );

  Widget showCard(int index, String deviceId, String id) =>
      GestureDetector(
        onTap: () {
          _deviceIdController.text = deviceId;
          _id = id;
        },
        child: CustomCard(
          index: index + 1,
          deviceId: deviceId,
          function: () async {
            _id = id;
            await ApiService().deleteDevice(_id).then((data) {
              if (data.result == true) {
                setState(() {
                  _deviceIdController.clear();
                  ShowToastMessage.showCenterShortToast(
                      MessageConstants.BASARILI);
                });
              } else {
                ShowToastMessage.showCenterShortToast(MessageConstants.HATA);
              }
            });
          },
        ),
      );

  Widget get addDeviceButton => DefaultRaisedButton(
        height: 55,
        color: UIColorHelper.DEFAULT_COLOR,
        label: 'Add',
        onPressed: () async {
          await ApiService()
              .addNewDevice(Device(
                  deviceId: _deviceIdController.text))
              .then((data) {
            if (data.result == true) {
              setState(() {
                _deviceIdController.clear();
                ShowToastMessage.showCenterShortToast(
                    MessageConstants.BASARILI);
              });
            } else {
              ShowToastMessage.showCenterShortToast(MessageConstants.HATA);
            }
          });
        },
      );

  Widget get updateDeviceButton => DefaultRaisedButton(
        height: 55,
        label: 'Update',
        color: Colors.cyanAccent,
        onPressed: () async {
          await ApiService()
              .updateDevice(
                  _deviceIdController.text, _id)
              .then((data) {
            if (data.result == true) {
              setState(() {
                _deviceIdController.clear();
                ShowToastMessage.showCenterShortToast(
                    MessageConstants.BASARILI);
              });
            } else {
              ShowToastMessage.showCenterShortToast(MessageConstants.HATA);
            }
          });
        },
      );
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
      child: const Text(MessageConstants.ERROR_OCCURED),
    );
  }
}

class NoSavedData extends StatelessWidget {
  const NoSavedData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Icon(
          Icons.airline_seat_individual_suite,
          size: 55,
        ),
        const SizedBox(height: 15),
        Text(
          MessageConstants.NO_SAVED_DATA,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}
