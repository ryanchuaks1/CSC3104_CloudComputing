Progress Report:

- Initialise Client and Server (Kafka Consumer) Using GRPC
- Print the reply from the server

TODO: 
- Comcbine all the functions (Start, Subscribe, Close) into 1 function since there is not much need for modularity at the moment

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

