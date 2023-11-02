File Structure a little messy but it contains 2 gRPC proto files

- This SQL server hosts the gRPC for the Application
    - device_pb2_grpc.py
    - device_pb2.py
    - device_pb2.pyi

- This SQL server is a client for the Kafka Producer Container
    - kafka_producer_pb2_grpc.py
    - kafka_producer_pb2.py
    - kafka_producer_pb2.pyi

Testing Instructions for Server to KafkaProducer:
    - Ensure the all containers are under the same network in the Docker-Compose YAML File
    - Ensure that Kafka Ip Address = "kafka-producer:50052"
        - NOT LOCALHOST AS WE RUNNING IN THE CONTAINER
    
    - Run "python kafkaProducer.py
