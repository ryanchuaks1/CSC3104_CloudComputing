Progress Report:

- Initialise Client and Server (Kafka Consumer) Using GRPC
- Print the reply from the server

TODO:

- After Reply, Client initialise a port to listen for any message published onto the topic from the Kafka Consumer

RUN: 

- Run Container steps: 
    - docker-compose up -d
    - wait for all containers to be initialised

- Run Kafka Client (To be integrated with application):
    - goto this Directory
    - Run "dart kafka_consumer_handler.dart"