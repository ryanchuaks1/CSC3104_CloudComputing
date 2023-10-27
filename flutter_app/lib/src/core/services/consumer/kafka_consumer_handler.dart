// import 'dart:convert';

// import 'package:flutter/material.dart';
import 'package:flutter_app/src/core/services/consumer/kafka_consumer.pbgrpc.dart';
// import 'package:http/http.dart' as http;
// import 'package:logging/logging.dart';

// import '../../constants/app_constants.dart';
// import '../../constants/device_method_constants.dart';
// import '../../models/response_model.dart';
// import '../../models/device_list_model.dart';
// import '../../models/device_model.dart';

import 'package:grpc/grpc.dart';

void main() async {
  
  print("Print Hello...\n");
  try {
    KafkaConsumerHandler handler = KafkaConsumerHandler();
    if (handler.startConsumerService('127.0.0.1', 50051)) {
      await handler.initSubscription("f1740855-6716-11ee-9b42-107b44");
      handler.closeConnection();
      
    }
  } catch (error) {
    print("Error Executing");
  }

}

class KafkaConsumerHandler
{
  late Kafka_Consumer_gRPCClient _stub;
  late ClientChannel channel;

  bool startConsumerService(String KafkaServerIp, int portNumber) 
  {
    try {
      channel = ClientChannel(KafkaServerIp,
        port: portNumber,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure()));

      _stub = Kafka_Consumer_gRPCClient(channel);
      return true;

    } catch (error) {
      print("Error Connecting, Please try Again");
      return false;
    }
 
  }

  Future<void> initSubscription(String deviceId) async
  {
    final params = Subscribe_Data()..udid=deviceId;

    final stream = await _stub.subscribe(params);

    print('Greeter client received: ${stream.udid}, ${stream.timestamp}, ${stream.location}');

    // await for (var message1 in stream) {
    //   // Process the received message as needed
    //   print('Received message: ${message1.udid} , ${message1.timestamp}, ${message1.location}');
    //   // You can assign the message to a variable or use it for other services here.
    // }
  }

  Future<void> closeConnection() async
  {
    await channel.shutdown();
  }
}


