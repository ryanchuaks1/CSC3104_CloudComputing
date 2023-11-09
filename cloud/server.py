import uuid
import json
import mysql.connector
from concurrent import futures
import grpc
from device_pb2 import Item, Reply, UserInstance
from device_pb2_grpc import DeviceServicer, add_DeviceServicer_to_server

import kafkaProducer as kp

#Testing Variables:
temp_lat = "10.000000"
temp_long = "20.00000"

class Device(DeviceServicer):
    def __init__(self) -> None:
        # Define the MySQL connection parameters
        self.MYSQL_HOST = "mariadb"
        self.MYSQL_USER = "root"
        self.MYSQL_PASSWORD = "secret"
        self.MYSQL_DATABASE = "mysql_db"
        self.KAFKA_ADDRESS = "producer-service:50052"

        # Creating a new instance of Kafka_producer
        self._producer = kp.KafkaProducer(self.KAFKA_ADDRESS)
        print(f"Connected to Kafka Producer successfully at {self.KAFKA_ADDRESS}!")

        # Connect to the MySQL database
        try:
            self.connection = mysql.connector.connect(
                host=self.MYSQL_HOST,
                user=self.MYSQL_USER,
                password=self.MYSQL_PASSWORD,
                database=self.MYSQL_DATABASE
            )
            self.cursor = self.connection.cursor()
            print("Connected to MySQL successfully!")
        except Exception as e:
            print("An error occurred:", e)

#Publish Location of current device
#  - Get the Location of the current request
#  - Serialize it into Json
#  - Publish it onto kafka
    def publish_current_location(self, request, context):
        try:
            location_data = {
                'latitude' : request.latitude ,
                'longitude' : request.longitude
            }

            # Add a new topic for this device
            added_topic = self._producer.addNewTopic(request.deviceId)
            print(f"Added New Topic: {added_topic}")

            serialize_location_data = json.dumps(location_data)
            published = self._producer.publishLocationToKafka(deviceID=request.deviceId, location=serialize_location_data)
            print(f"Location Published: {published}")
            return Reply(result="True", message="Location successfully Published")

        except Exception as e:
            return Reply(result="False", message=f"Error: {str(e)}")

# Use to add a new device to a User
    def add_new_device(self, request, context):
        query = "SELECT * FROM users WHERE user_id = %s"
        values = (request.userId,)
        self.cursor.execute(query, values)
        result = self.cursor.fetchall()

        if not result:
            # Insert the new user into the users table
            insert_query = "INSERT INTO users (user_id, user_name, user_password_hash) VALUES (%s, %s, %s)"
            insert_values = (request.userId, "user_name_example", "user_password_hash_example")
            self.cursor.execute(insert_query, insert_values)
            self.connection.commit()

        # Add a new topic for this device
            added_topic = self._producer.addNewTopic(request.deviceId)
            print(f"Added New Topic: {added_topic}")

        # Insert the new device into the devices table
        device_query = "INSERT INTO devices (device_id, user_id) VALUES (%s, %s)"
        device_values = (request.deviceId, request.userId)

        try:
            self.cursor.execute(device_query, device_values)
            self.connection.commit()

            return Reply(result="True", message="Device added successfully!")
        except Exception as e:
            return Reply(result="False", message=f"Error: {str(e)}")

# Use to delete a device from the sql table
    def delete_device(self, request, context):
        query = "DELETE FROM devices WHERE device_id = %s"
        values = (request.deviceId,)

        try:
            self.cursor.execute(query, values)
            self.connection.commit()
            return Reply(result="True", message="Device deleted successfully!")
        except Exception as e:
            return Reply(result="False", message=f"Error: {str(e)}")

# Get All Devices from the User
    def get_all_devices(self, request, context):
        query = "SELECT * FROM devices WHERE user_id = %s"
        values = (request.userId,)
        self.cursor.execute(query, values)
        result = self.cursor.fetchall()
        print(request.userId)

        items = [Item(deviceId=row[0], userId=row[1]) for row in result]
        print(items)
        return Reply(result="True", message="Devices retrieved successfully", items=items)

    def create_account(self, request, context):
        unique_user_id = uuid.uuid4()
        unique_user_id = unique_user_id.hex
        print(request.userName)
        insert_query = "INSERT INTO users (user_id, user_name, user_password_hash) VALUES (%s, %s, %s)"
        insert_values = (unique_user_id, request.userName, request.userPasswordHash)

        try:
            self.cursor.execute(insert_query, insert_values)
            self.connection.commit()
            return Reply(result="True", message="User account created successfully!")
        except Exception as e:
            return Reply(result="False", message=f"Error: {str(e)}")

    def login(self, request, context):
        print(request.userName)
        select_query = "SELECT * FROM users WHERE user_name = %s"
        select_values = (request.userName,)
        self.cursor.execute(select_query, select_values)
        result = self.cursor.fetchall()

        print(result)

        result = result[0] if len(result) else None

        if result == None:
            return UserInstance(result="False")

        ## Validate user here
        if (result[2] == request.userPasswordHash):
            return UserInstance(result="True", userId=result[0], userName=result[1])

        return UserInstance(result="False, Invalid Username or Password")



def main() -> None:
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    add_DeviceServicer_to_server(Device(), server)
    server.add_insecure_port('[::]:5001')
    server.start()
    server.wait_for_termination()

if __name__ == '__main__':
    main()
