# The Python implementation of the GRPC helloworld.Greeter client.

from __future__ import print_function

import logging, time

import grpc
import kafka_producer_pb2, kafka_producer_pb2_grpc

class KafkaProducer():

    def __init__(self, kafka_address) -> None:
        self._kafka_address = kafka_address

    def getKafkaAddress(self) -> str:
        return self._kafka_address
    
    def addNewTopic(self, deviceID : str) -> bool:
        with grpc.insecure_channel(self._kafka_address) as channel:
            _stub = kafka_producer_pb2_grpc.Kafka_Producer_gRPCStub(channel)

            response = _stub.Add_New_Location(kafka_producer_pb2.Topic(udid=deviceID))

            return response.success
        
    def publishLocationToKafka(self, deviceID : str, location : str) -> bool:

        with grpc.insecure_channel(self._kafka_address) as channel:
            _stub = kafka_producer_pb2_grpc.Kafka_Producer_gRPCStub(channel)

            response = response = _stub.Add_New_Location(kafka_producer_pb2.Location(udid=deviceID, location=location))

            return response.success