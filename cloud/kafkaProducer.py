# Copyright WJ
"""The Python implementation of the GRPC helloworld.Greeter client."""

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


# def run():
#     # NOTE(gRPC Python Team): .close() is possible on a channel and should be
#     # used in circumstances in which the with statement does not fit the needs
#     # of the code.
#     udid = "f1740855-6716-11ee-9b42-107b44"
#     location = "1.377476301551542, 103.84873335110395"

#     kafka_producer = KafkaProducer('localhost:50052')

#     added_topic = kafka_producer.addNewTopic(udid)
#     print(f"Added New Topic: {added_topic}")

#     if added_topic:
#         for i in range(10):
#             published = kafka_producer.publishLocationToKafka(udid, location)
#             print(f"Location Published: {published}")

#             time.sleep(5)
#     else:
#         print("Failed to add a topic to Kafka Server. Topic ID: " + added_topic.udid)

#     # with grpc.insecure_channel('localhost:50052') as channel:
#     #     #TODO: initiate the stub
#     #     stub = kafka_producer_pb2_grpc.Kafka_Producer_gRPCStub(channel)
#     #     # pass

#     #     response = stub.Add_New_Topic(kafka_producer_pb2.Topic(udid=udid))
#     #     #res = stub.Add_New_Topic(kafka_producer_pb2.Topic(udid="a1740855-6716-11ee-9b42-107b44"))

#     #     if response.success is True:
#     #         print("Successfully added a topic to Kafka Server. Topic ID: " + response.udid)

#     #         for i in range(5):
#     #             response = stub.Add_New_Location(kafka_producer_pb2.Location(udid=udid, location=location))
#     #             print("The result of adding a new location for device " + response.udid + " is: " + str(response.success))
#     #             time.sleep(2)
#     #             # res = stub.Add_New_Topic(kafka_producer_pb2.Topic(udid="a11231231231231231232211"))
#     #             # print("Topic exist: " + str(res.success))
#     #             # time.sleep(5)
#     #     else:
#     #         print("Failed to add a topic to Kafka Server. Topic ID: " + response.udid)

# if __name__ == '__main__':
#     logging.basicConfig()
#     run()