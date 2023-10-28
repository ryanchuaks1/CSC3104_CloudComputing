// import 'dart:convert';
import 'dart:async';

// import 'package:flutter/material.dart';
import 'package:flutter_app/src/core/services/producer/kafka_producer.pbgrpc.dart';
// import 'package:http/http.dart' as http;
// import 'package:logging/logging.dart';

// import '../../constants/app_constants.dart';
// import '../../constants/device_method_constants.dart';
// import '../../models/response_model.dart';
// import '../../models/device_list_model.dart';
// import '../../models/device_model.dart';

import 'package:grpc/grpc.dart';

//For Testing/Debugging Purposes
// Haven't test and have not created the producer kafka
void main() async {
  
  print("Start Program...\n");

  try {
    KafkaProducerHandler handler = KafkaProducerHandler();
    if (handler.startProducerService('127.0.0.1', 50054)) {
      
      Timer.periodic(Duration(seconds: 1), (timer) {
      // Replace this function with the one you want to run every second.
        handler.publishCurrentLocation("f1740855-6716-11ee-9b42-107b44", "12:00:00", "10.000, 20.000");  
      });

      // Not sure if need to close the connection
    }
    
  } catch (error) {
    
    print("Error Executing");
  }

}

class KafkaProducerHandler
{
  //Class Variables
  late Kafka_Producer_gRPCClient _stub;
  late ClientChannel channel;

  //Initialising gRPC connection with the consumer server
  bool startProducerService(String KafkaServerIp, int portNumber) 
  {
    try {

      //Create the Channel
      channel = ClientChannel(KafkaServerIp,
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
  Future<void> publishCurrentLocation(String deviceID, String currTimeStamp, String currLocation) async
  {
    final params = Location_Data()..udid=deviceID..timestamp=currTimeStamp..location=currLocation;

    final success = await _stub.publish(params);

    print("Success: ${success}");
  }

  //This function is to close the channel
  Future<void> closeConnection() async
  {
    await channel.shutdown();
  }
}


