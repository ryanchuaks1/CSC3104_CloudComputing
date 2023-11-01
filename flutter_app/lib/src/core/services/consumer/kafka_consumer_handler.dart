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

//For Testing/Debugging Purposes
void main() async {
  
  print("Start Program...\n");

  try {
    KafkaConsumerHandler handler = KafkaConsumerHandler();
    if (handler.startConsumerService('127.0.0.1', 50051)) {
      await handler.subscribeToDevice("f1740855-6716-11ee-9b42-107b44");
      handler.closeConnection();
      
    }
  } catch (error) {
    
    print("Error Executing");
  }

}

class KafkaConsumerHandler
{
  //Class Variables
  late Kafka_Consumer_gRPCClient _stub;
  late ClientChannel channel;

  //Initialising gRPC connection with the consumer server
  bool startConsumerService(String KafkaServerIp, int portNumber) 
  {
    try {

      //Create the Channel
      channel = ClientChannel(KafkaServerIp,
        port: portNumber,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure()));

      //Create the stub
      _stub = Kafka_Consumer_gRPCClient(channel);
      return true;

    } catch (error) {
      print("Error Connecting, Please try Again");
      return false;
    }
 
  }

  // This functions allows you to subscribe to a device and wait for a reply
  Future<void> subscribeToDevice(String deviceId) async
  {
    // Add the paremeters to the message
    final params = Subscribe_Data()..udid=deviceId;

    //Call subscribe and wait for a reply
    final stream = await _stub.subscribe(params);

    //Print the Reply
    // print('Greeter client received: ${stream.udid}, ${stream.timestamp}, ${stream.location}');

    await for (var message1 in stream) {
      // Process the received message as needed
      print('Received message: ${message1.udid} , ${message1.timestamp}, ${message1.location}');
      // You can assign the message to a variable or use it for other services here.
    }
  }

  //This function is to close the channel
  Future<void> closeConnection() async
  {
    await channel.shutdown();
  }
}


