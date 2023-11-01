import 'dart:convert';
import 'dart:typed_data';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

/// Start DeviceAPI Group Code

class DeviceAPIGroup {
  static String baseUrl = '10.0.2.2:5001';
  static Map<String, String> headers = {};
  static AddANewDeviceCall addANewDeviceCall = AddANewDeviceCall();
  static DeleteADeviceByIDCall deleteADeviceByIDCall = DeleteADeviceByIDCall();
  static GetAllDevicesCall getAllDevicesCall = GetAllDevicesCall();
  static CreateANewUserAccountCall createANewUserAccountCall =
      CreateANewUserAccountCall();
  static UserLoginCall userLoginCall = UserLoginCall();
}

class AddANewDeviceCall {
  Future<ApiCallResponse> call() async {
    final ffApiRequestBody = '''
{
  "userId": "",
  "deviceId": "",
  "deviceName": "",
  "latitude": "",
  "longitude": ""
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Add a new device',
      apiUrl: '${DeviceAPIGroup.baseUrl}/addNewDevice',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}

class DeleteADeviceByIDCall {
  Future<ApiCallResponse> call({
    String? id = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'Delete a device by ID',
      apiUrl: '${DeviceAPIGroup.baseUrl}/deleteDevice',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}

class GetAllDevicesCall {
  Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'Get all devices',
      apiUrl: '${DeviceAPIGroup.baseUrl}/getAllDevices',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}

class CreateANewUserAccountCall {
  Future<ApiCallResponse> call() async {
    final ffApiRequestBody = '''
{
  "userName": "",
  "userPasswordHash": ""
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Create a new user account',
      apiUrl: '${DeviceAPIGroup.baseUrl}/createAccount',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}

class UserLoginCall {
  Future<ApiCallResponse> call() async {
    final ffApiRequestBody = '''
{
  "userName": "",
  "userPasswordHash": ""
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'User login',
      apiUrl: '${DeviceAPIGroup.baseUrl}/login',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}

/// End DeviceAPI Group Code

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list);
  } catch (_) {
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar);
  } catch (_) {
    return isList ? '[]' : '{}';
  }
}
