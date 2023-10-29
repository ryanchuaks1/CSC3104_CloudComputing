import 'package:grpc/grpc.dart';
import 'package:logging/logging.dart';

import '../constants/app_constants.dart';
import '../models/response_model.dart';
import '../models/device_list_model.dart';
import '../models/device_model.dart';
import '../your_generated_grpc_file.dart'; // Import your generated gRPC file

final log = Logger('ApiLogger');

class ApiService {
  static final ApiService _apiService = ApiService._init();

  factory ApiService() {
    return _apiService;
  }

  ApiService._init();

  //add new device
  Future<Response> addNewDevice(Device device) async {
    try {
      final channel = ClientChannel(AppConstants.GRPC_URL,
          port: AppConstants.GRPC_PORT,
          options: const ChannelOptions(credentials: ChannelCredentials.insecure()));

      final client = YourGeneratedGrpcClient(channel);

      final response = await client.addNewDevice(YourGeneratedRequest()
        ..userId = device.userId
        ..deviceId = device.deviceId
        ..deviceName = device.deviceName
        ..latitude = device.latitude
        ..longitude = device.longitude);

      await channel.shutdown();

      return Response()..result = response.result;
    } catch (e) {
      log.warning(e.toString());
      return Response();
    }
  }

  //delete device
  Future<Response> deleteDevice(String id) async {
    try {
      final channel = ClientChannel(AppConstants.GRPC_URL,
          port: AppConstants.GRPC_PORT,
          options: const ChannelOptions(credentials: ChannelCredentials.insecure()));

      final client = YourGeneratedGrpcClient(channel);

      final response = await client.deleteDevice(YourDeleteRequest()..id = id);

      await channel.shutdown();

      return Response()..result = response.result;
    } catch (e) {
      log.warning(e.toString());
      return Response();
    }
  }

  //get all data
  Future<List<DeviceList>> getAllDevices() async {
    try {
      final channel = ClientChannel(AppConstants.GRPC_URL,
          port: AppConstants.GRPC_PORT,
          options: const ChannelOptions(credentials: ChannelCredentials.insecure()));

      final client = YourGeneratedGrpcClient(channel);

      final response = await client.getAllDevices(YourGetAllRequest());

      await channel.shutdown();

      return response.items.map((item) => DeviceList.fromJson(item.toJson())).toList();
    } catch (e) {
      log.warning(e.toString());
      return [];
    }
  }
}
