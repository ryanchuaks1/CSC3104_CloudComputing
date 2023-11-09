import 'dart:io';
import 'package:grpc/grpc.dart';
import 'package:intl/number_symbols_data.dart';
import 'package:locationation/core/services/consumer/kafka_consumer.pbgrpc.dart';
import 'package:locationation/core/services/constants/app_constants.dart';
import 'package:uuid/uuid.dart';

import 'dart:collection';
import 'dart:math';
import 'package:logging/logging.dart';

final log = Logger('ApiLogger');

//For Testing/Debugging Purposes
void main() async {
  
  print("Start Program...\n");

  try {
    KafkaConsumerHandler handler = KafkaConsumerHandler();
    final uuid = Uuid();
    handler.subscribeToDevice(uuid.v4(),"fd90e1fce28d8691");

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
  bool isSubscribed = false;

  KafkaConsumerHandler()
  {
    _kafkaIpAddress = AppConstants.KAFKA_CONSUMER_IPADDRESS;
    _portNumber = AppConstants.KAFKA_CONSUMER_PORT;
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

  String getCurrentLocation()
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

   Future<void> subscribeToDevice(String sessionId, String deviceId) async 
  {
    if (isSubscribed) {
      return;
    }
    else
    {
      _startSubscription(sessionId, deviceId);
    }
  }
  //Initialising gRPC connection with the consumer server
  Future<void> _startSubscription(String sessionId, String deviceId) async
  {
    try {
      //Create the Channel
      _channel = ClientChannel(_kafkaIpAddress,
        port: _portNumber,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure()));

      //Create the stub
      _stub = Kafka_Consumer_gRPCClient(_channel);

      // Add the paremeters to the message
      final params = Subscribe_Data()
        ..sid=sessionId
        ..udid=deviceId;

      //Call subscribe and wait for a reply
      final stream = await _stub.subscribe(params);

      //Print the Reply
      // print('Greeter client received: ${stream.udid}, ${stream.timestamp}, ${stream.location}');
      await for (var curr_message in stream) {

        //Check if the messages are empty, if not, enqueue them
        if(curr_message != "")
        {
          _enqueue(curr_message.location);
        }

        print('Received message: ${curr_message.udid} , ${curr_message.timestamp}, ${curr_message.location}');
      }

    } catch (error) {
      log.warning(error.toString());
    }
    finally
    {
      //End the Subscription
      isSubscribed = false;
      await _channel.shutdown();
    } 
  }

}


