import 'package:grpc/grpc.dart';
import 'package:logging/logging.dart';
import 'dart:async';

import 'constants/app_constants.dart';
import '../models/response_model.dart';
import '../models/device_list_model.dart';
import '../models/device_model.dart';
import '../models/user_model.dart';
import 'package:locationation/core/services/device.pbgrpc.dart'; // Import your generated gRPC file

final log = Logger('ApiLogger');

class ApiService {
  static final ApiService _apiService = ApiService._init();

  factory ApiService() {
    return _apiService;
  }

  ApiService._init();

   Future<Reply> publishCurrentLocation(Device device) async {

    try {
      final channel = ClientChannel(AppConstants.GRPC_URL,
          port: AppConstants.GRPC_PORT,
          options:
              const ChannelOptions(credentials: ChannelCredentials.insecure()));

      final client = DeviceClient(channel);

      final response = await client.publish_current_location(Item()
        ..userId = device.userId
        ..deviceId = device.deviceId
        ..deviceName = device.deviceName
        ..latitude = device.latitude.toString()
        ..longitude = device.longitude.toString());

      await channel.shutdown();
      
      return Reply()..result = response.result;
    } catch (e) {
      log.warning(e.toString());
      return Reply()..result = e.toString();
    }
  }


  //add new device
  Future<Reply> addNewDevice(Device device) async {
    try {
      final channel = ClientChannel(AppConstants.GRPC_URL,
          port: AppConstants.GRPC_PORT,
          options:
              const ChannelOptions(credentials: ChannelCredentials.insecure()));

      final client = DeviceClient(channel);

      final response = await client.add_new_device(Item()
        ..userId = device.userId
        ..deviceId = device.deviceId
        ..deviceName = device.deviceName
        ..latitude = device.latitude.toString()
        ..longitude = device.longitude.toString());

      await channel.shutdown();

      return Reply()..result = response.result;
    } catch (e) {
      log.warning(e.toString());
      return Reply()..result = e.toString();
    }
  }

  //delete device
  Future<Reply> deleteDevice(String id) async {
    try {
      final channel = ClientChannel(AppConstants.GRPC_URL,
          port: AppConstants.GRPC_PORT,
          options:
              const ChannelOptions(credentials: ChannelCredentials.insecure()));

      final client = DeviceClient(channel);

      final response = await client.delete_device(Item()..id = id);

      await channel.shutdown();

      return Reply()..result = response.result;
    } catch (e) {
      log.warning(e.toString());
      return Reply();
    }
  }

  //get all data
  Future<List<DeviceList>> getAllDevices() async {
    try {
      final channel = ClientChannel(AppConstants.GRPC_URL,
          port: AppConstants.GRPC_PORT,
          options:
              const ChannelOptions(credentials: ChannelCredentials.insecure()));

      final client = DeviceClient(channel);

      final response = await client.get_all_devices(Item());

      await channel.shutdown();

      return response.items
          .map((item) => DeviceList.fromJson({
                "_id": item.id,
                "userId": item.userId,
                "deviceId": item.deviceId,
              }))
          .toList();
    } catch (e) {
      log.warning(e.toString());
      return [];
    }
  }

  Future<Reply> createAccount(User_Account user) async {
    try {
      final channel = ClientChannel(AppConstants.GRPC_URL,
          port: AppConstants.GRPC_PORT,
          options:
              const ChannelOptions(credentials: ChannelCredentials.insecure()));

      final client = DeviceClient(channel);

      print(user.userName);
      print(user.userPasswordHash);
      final response = await client.create_account(UserAccount()
        ..userName = user.userName
        ..userPasswordHash = user.userPasswordHash);

      await channel.shutdown();

      return Reply()..result = response.result;
    } catch (e) {
      log.warning(e.toString());
      return Reply()..result = e.toString();
    }
  }

  Future<UserInstance> login(User_Account user) async {
    try {
      final channel = ClientChannel(AppConstants.GRPC_URL,
          port: AppConstants.GRPC_PORT,
          options:
              const ChannelOptions(credentials: ChannelCredentials.insecure()));
      final client = DeviceClient(channel);

      final response = await client.login(UserAccount()
        ..userName = user.userName
        ..userPasswordHash = user.userPasswordHash);

      await channel.shutdown();

      print(response);
      print(user.userName);

      return UserInstance()
        ..result = response.result
        ..userId = response.userId
        ..userName = response.userName;
    } catch (e) {
      log.warning(e.toString());
      return UserInstance()..result = e.toString();
    }
  }
}

// For Testing Purposes
void main() async {
  
  print("Start Program...\n");

  ApiService apiService = ApiService(); 

  Device curr_device = Device(
    userId: "test_user", 
    deviceId: "f1740855-6716-11ee-9b42-107b44", 
    deviceName: "Testing_device", 
    latitude: double.parse("10.0"), 
    longitude: double.parse("20.0"));

  // Timer.periodic(Duration(seconds: 1), (timer) {
  //   print("Publishing\n");
  //   final reply = await apiService.publishCurrentLocation(curr_device);

  //   print(reply.message);
  // });

  void publishLocation(Timer timer) async {
    print("Publishing\n");
    final reply = await apiService.publishCurrentLocation(curr_device);

    print(reply.message);
  }

  Timer.periodic(Duration(seconds: 1), publishLocation);

}
