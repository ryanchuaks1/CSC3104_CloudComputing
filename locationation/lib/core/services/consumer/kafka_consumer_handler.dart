import 'package:grpc/grpc.dart';
import 'package:intl/number_symbols_data.dart';
import 'package:locationation/core/services/consumer/kafka_consumer.pbgrpc.dart';
import 'package:locationation/core/services/constants/app_constants.dart';

import 'dart:collection';
import 'dart:math';
import 'package:logging/logging.dart';

final log = Logger('ApiLogger');

//For Testing/Debugging Purposes
void main() async {
  
  print("Start Program...\n");

  try {
    KafkaConsumerHandler handler = KafkaConsumerHandler();
  

    handler.subscribeToDevice("fd90e1fce28d8691");
  } catch (error) {
    
    print("Error Executing");
  }

}



class KafkaConsumerHandler
{
  //Class Variables
  late Kafka_Consumer_gRPCClient _stub;
  late ClientChannel _channel;

  late Queue<String> buffer = Queue<String>();
  late String _kafkaIpAddress;
  late int _portNumber;

  //Debugging Variables - TO BE DELETED
  late int objectId;
  int message_count = 0;
  String temp_device_id = "";

  KafkaConsumerHandler()
  {
    _kafkaIpAddress = AppConstants.KAFKA_CONSUMER_IPADDRESS;
    _portNumber = AppConstants.KAFKA_CONSUMER_PORT;
    objectId = Random().nextInt(1000000);
  }

  //Private Function
  bool _enqueue(String location)
  {
    try {
      
      buffer.add(location);
      return true;

    } catch (e) {
      log.warning(e.toString());
      return false;
    }
  }

  Future<String> getCurrentLocation() async
  {
    try {
      
      if(buffer.isNotEmpty)
      {
        //Shorten the Buffer if there are more than 20 data location in the queue
        if(buffer.length > 20)
        {
          for (var i = 0; i < 15; i++) {
            buffer.removeFirst();
          }
        }

        return buffer.removeFirst();
      }
      else
      {
        return "";
      }

    } catch (e) {
      log.warning(e.toString());
      return "";
    }
  }

  //Initialising gRPC connection with the consumer server
  Future<void> subscribeToDevice( String deviceId) async
  {
    try {
      message_count += 1;
      //Create the Channel
      _channel = ClientChannel(_kafkaIpAddress,
        port: _portNumber,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure()));

      message_count += 1;
      //Create the stub
      _stub = Kafka_Consumer_gRPCClient(_channel);

      message_count += 1;
      // Add the paremeters to the message
      final params = Subscribe_Data()..udid=deviceId;

      temp_device_id=deviceId;

      message_count += 1;
      //Call subscribe and wait for a reply
      final stream = await _stub.subscribe(params);

      //Print the Reply
      // print('Greeter client received: ${stream.udid}, ${stream.timestamp}, ${stream.location}');
      message_count += 1;
      await for (var curr_message in stream) {
        // Process the received message as needed
        // print('Received message: ${curr_message.udid} , ${curr_message.timestamp}, ${curr_message.location}');

        //print("Getting Location!");
        message_count += 1;
        //Put the Location into the buffer
        if(curr_message != "")
        {
          _enqueue(curr_message.location);


        }

        //Get the location and print it (To be Used Outside)
        //String curr_location = getCurrentLocation();

        //print('Received message: ${curr_message.udid} , ${curr_message.timestamp}, ${curr_location}');
        print("${buffer}");
      }

      message_count += 10;

    } catch (error) {
      log.warning(error.toString());
    }
    finally
    {
      await _channel.shutdown();
    } 
  }

}


