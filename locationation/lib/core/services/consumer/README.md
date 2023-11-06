Progress Report:

- Initialise Client and Server (Kafka Consumer) Using GRPC
- Print the reply from the server

TODO:

- Integration to api_service.dart
- Link to SQL server to subscribe to all the devices by the user

RUN: 

- Run Container steps: 
    - docker-compose up -d
    - wait for all containers to be initialised

- Run Kafka Producer (Create topic and Publish)
    - goto this Directory
    - Run "dart kafka_producer_handler.dart"

- Run Kafka Consumer (Listening To Topic):
    - goto this Directory
    - Run "dart kafka_consumer_handler.dart"

- Expected Output:
    - Every Publish in the Producer will return true
    - Every Consumer will prin the "udid, timestamp, location"

