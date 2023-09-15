import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

import '../constants/app_constants.dart';
import '../constants/device_method_constants.dart';
import '../models/response_model.dart';
import '../models/device_list_model.dart';
import '../models/device_model.dart';

final log = Logger('ApiLogger');

class ApiService {
  static final ApiService _apiService = ApiService._init();

  factory ApiService() {
    return _apiService;
  }

  ApiService._init();

  //add new device
  Future<Response> addNewDevice(Device device) async {
    final url = Uri.parse(
      AppConstants.API_URL + DeviceMethodConstants.ADD_NEW_DEVICE,
    );
    final request = await http.post(
      url,
      body: jsonEncode(device.toJson()),
      headers: AppConstants.HEADERS,
    );
    Response response = Response();
    try {
      if (request.statusCode == 201) {
        response = responseFromJson(request.body);
      } else {
        log.warning(request.statusCode);
      }
    } catch (e) {
      return Response();
    }
    return response;
  }

  //update device
  Future<Response> updateDevice(
      String deviceId, String id) async {
    final json =
        '{"deviceId" : "$deviceId","_id" : "$id"}';
    final url =
        Uri.parse(AppConstants.API_URL + DeviceMethodConstants.UPDATE_DEVICE);
    final request =
        await http.post(url, body: json, headers: AppConstants.HEADERS);
    Response response = Response();
    try {
      if (request.statusCode == 201) {
        response = responseFromJson(request.body);
      } else {
        log.warning(request.statusCode);
      }
    } catch (e) {
      return Response();
    }
    return response;
  }

  //update device
  Future<Response> deleteDevice(String id) async {
    String json = '{"_id" : "$id"}';
    final url =
        Uri.parse(AppConstants.API_URL + DeviceMethodConstants.DELETE_DEVICE);
    final request =
        await http.post(url, body: json, headers: AppConstants.HEADERS);
    Response response = Response();
    try {
      if (request.statusCode == 201) {
        response = responseFromJson(request.body);
      } else {
        log.warning(request.statusCode);
      }
    } catch (e) {
      return Response();
    }
    return response;
  }

  //get all data
  Future<List<DeviceList>> getAllDevices() async {
    final url = Uri.parse(
      AppConstants.API_URL + DeviceMethodConstants.LIST_ALL_DEVICES,
    );
    final request = await http.get(
      url,
      headers: AppConstants.HEADERS,
    );
    List<DeviceList> devicelist = [];
    try {
      if (request.statusCode == 200) {
        devicelist = deviceListFromJson(request.body);
      } else {
        log.warning(request.statusCode);
        return const [];
      }
    } catch (e) {
      return const [];
    }
    return devicelist;
  }
}
