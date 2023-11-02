// import 'dart:convert';
import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:logging/logging.dart';

// import '../../constants/app_constants.dart';
// import '../../constants/device_method_constants.dart';
// import '../../models/response_model.dart';
// import '../../models/device_list_model.dart';
// import '../../models/device_model.dart';

import 'package:grpc/grpc.dart';
import 'package:locationation/core/services/producer/kafka_producer.pbgrpc.dart';

//For Testing/Debugging Purposes
// Haven't test and have not created the producer kafka
void main() async {
  print("Start Program...\n");

  try {
    KafkaProducerHandler handler =
        KafkaProducerHandler("f1740855-6716-11ee-9b42-107b44");
    if (handler.startProducerService('127.0.0.1', 50052)) {
      //Create a device topic before publishing onto it
      await handler.createDeviceTopic();

      Timer.periodic(Duration(seconds: 1), (timer) {
        handler.publishCurrentLocation("10.000, 20.000");
      });

      // Not sure if need to close the connection
    }
  } catch (error) {
    print("Error Executing");
  }
}

class KafkaProducerHandler {
  //Class Variables
  late Kafka_Producer_gRPCClient _stub;
  late ClientChannel channel;
  late String _deviceID;

  KafkaProducerHandler(String deviceID) {
    _deviceID = deviceID;
  }

  // Mutator
  String getDeviceId() {
    return _deviceID;
  }

  //Initialising gRPC connection with the consumer server
  bool startProducerService(String kafkaServerIp, int portNumber) {
    try {
      //Create the Channel
      channel = ClientChannel(kafkaServerIp,
          port: portNumber,
          options:
              const ChannelOptions(credentials: ChannelCredentials.insecure()));

      //Create the stub
      _stub = Kafka_Producer_gRPCClient(channel);
      return true;
    } catch (error) {
      print("Error Connecting, Please try Again");
      return false;
    }
  }

  //Ask the Server to publish the location and timestamp to the topic which is the deviceID
  Future<bool> publishCurrentLocation(String currLocation) async {
    final params = Location()
      ..udid = _deviceID
      ..location = currLocation;

    final reply = await _stub.add_New_Location(params);

    print("Success: ${reply.success}");

    return reply.success;
  }

  //Ask the Server to create a topic for the current device
  Future<bool> createDeviceTopic() async {
    final params = Topic()..udid = _deviceID;

    final reply = await _stub.add_New_Topic(params);

    return reply.success;
  }

  //This function is to close the channel
  Future<void> closeConnection() async {
    await channel.shutdown();
  }
}
