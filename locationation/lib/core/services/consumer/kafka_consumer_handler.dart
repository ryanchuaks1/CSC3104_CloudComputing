import 'package:grpc/grpc.dart';
import 'package:intl/number_symbols_data.dart';
import 'package:locationation/core/services/consumer/kafka_consumer.pbgrpc.dart';

import 'dart:collection';
import 'package:logging/logging.dart';

final log = Logger('ApiLogger');

//For Testing/Debugging Purposes
void main() async {
  
  print("Start Program...\n");

  try {
    KafkaConsumerHandler handler = KafkaConsumerHandler('127.0.0.1', 50051);
  

    handler.subscribeToDevice("f1740855-6716-11ee-9b42-107b44");
  } catch (error) {
    
    print("Error Executing");
  }

}



class KafkaConsumerHandler
{
  //Class Variables
  late Kafka_Consumer_gRPCClient _stub;
  late ClientChannel _channel;

  late Queue<String> _buffer = Queue<String>();
  late String _kafkaIpAddress;
  late int _portNumber;


  KafkaConsumerHandler(String kafkaIpAddress, int portNumber)
  {
    _kafkaIpAddress = kafkaIpAddress;
    _portNumber = portNumber;
  }

  //Private Function
  bool _enqueue(String location)
  {
    try {
      
      _buffer.add(location);
      return true;

    } catch (e) {
      log.warning(e.toString());
      return false;

    }

  }

  String getCurrentLocation()
  {
    try {
      
      if(_buffer.isNotEmpty)
      {
        //Shorten the Buffer if there are more than 20 data location in the queue
        if(_buffer.length > 20)
        {
          for (var i = 0; i < 15; i++) {
            _buffer.removeFirst();
          }
        }

        return _buffer.removeFirst();
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

      //Create the Channel
      _channel = ClientChannel(_kafkaIpAddress,
        port: _portNumber,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure()));

      //Create the stub
      _stub = Kafka_Consumer_gRPCClient(_channel);

      // Add the paremeters to the message
      final params = Subscribe_Data()..udid=deviceId;

      //Call subscribe and wait for a reply
      final stream = await _stub.subscribe(params);

      //Print the Reply
      // print('Greeter client received: ${stream.udid}, ${stream.timestamp}, ${stream.location}');

      await for (var curr_message in stream) {
        // Process the received message as needed
        // print('Received message: ${curr_message.udid} , ${curr_message.timestamp}, ${curr_message.location}');\

        //print("Getting Location!");

        //Put the Location into the buffer
        if(curr_message != "")
        {
          _enqueue(curr_message.location);

        }

        //Get the location and print it (To be Used Outside)
        String curr_location = getCurrentLocation();

        print('Received message: ${curr_message.udid} , ${curr_message.timestamp}, ${curr_location}');
        print("${_buffer}");
      }

    } catch (error) {
      log.warning(error.toString());
    }
    finally
    {
      await _channel.shutdown();
    } 
  }

}


