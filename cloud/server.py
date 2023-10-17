from concurrent import futures
from pymongo import MongoClient
from bson import json_util
from bson.objectid import ObjectId
import json

import grpc
import device_pb2, device_pb2_grpc


class Device(device_pb2_grpc.DeviceServicer):
    def __init__(self) -> None:
        # Define the MongoDB connection string
        self.MONGO_URI = "mongodb://root:password@mongodb:27017/mongo_db?authSource=admin&readPreference=primary&appname=MongoDB%20Compass&retryWrites=true&ssl=false"


    def connect_db(self) -> None:
        # Connect to the MongoDB database
        try:
            # Connect to MongoDB
            self.client = MongoClient(self.MONGO_URI)
            print("Connected to MongoDB successfully!")
        except Exception as e:
            print("An error occurred:", e)

        # Get the database
        self.db = self.client.get_database()


    def close_db(self) -> None:
        if self.client:
            # Close the connection when done
            self.client.close()


    def add_new_device(self, request, context):
        devices_collection = self.db.devices

        # Add the new device to the collection
        new_device = {"deviceId": request.deviceId, "deviceName": request.deviceName, "latitude": request.latitude, "longitude": request.longitude}
        devices_collection.insert_one(new_device)

        return device_pb2.Reply(result = "True", message = "Device added successfully!")


    def update_device(self, request, context):
        device_data = request.get_json()
        devices_collection = self.db.devices

        # Update the existing device in the collection
        update_query = {"_id": ObjectId(request._id)}
        update_data = {"$set": {"deviceId": request.deviceId}}
        devices_collection.update_one(update_query, update_data)

        return device_pb2.Reply(result = "True", message = "Device updated successfully!")


    def delete_device(self, request, context):
        device_data = request.get_json()
        devices_collection = self.db.devices

        # Delete the device from the collection
        delete_query = {"_id": ObjectId(request._id)}
        devices_collection.delete_one(delete_query)

        return device_pb2.Reply(result = "True", message = "Device deleted successfully!")


    def get_all_devices(self, request, context):
        devices_collection = self.db.devices

        # Get all devices from the collection
        all_devices = [json.loads(json_util.dumps(device)) for device in devices_collection.find()]

        return device_pb2.Reply(result = "True", message = "Devices retrieved successfully", items = all_devices)


def main() -> None:
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    device_pb2_grpc.add_DeviceServicer_to_server(Device(), server)
    server.add_insecure_port('[::]:5000')
    server.start()
    server.wait_for_termination()


if __name__ == '__main__':
    main()

