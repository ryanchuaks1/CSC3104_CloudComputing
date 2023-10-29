import grpc
from concurrent import futures
import mysql.connector
from device_pb2 import Item, Reply
from device_pb2_grpc import DeviceServicer, add_DeviceServicer_to_server

class Device(DeviceServicer):
    def __init__(self) -> None:
        # Define the MySQL connection parameters
        self.MYSQL_HOST = "mariadb"
        self.MYSQL_USER = "user"
        self.MYSQL_PASSWORD = "password"
        self.MYSQL_DATABASE = "mysql_db"

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

        # Insert the new device into the devices table
        device_query = "INSERT INTO devices (device_id, user_id) VALUES (%s, %s)"
        device_values = (request.deviceId, request.userId)

        try:
            self.cursor.execute(device_query, device_values)
            self.connection.commit()
            return Reply(result="True", message="Device added successfully!")
        except Exception as e:
            return Reply(result="False", message=f"Error: {str(e)}")

    def delete_device(self, request, context):
        query = "DELETE FROM devices WHERE device_id = %s"
        values = (request.deviceId,)

        try:
            self.cursor.execute(query, values)
            self.connection.commit()
            return Reply(result="True", message="Device deleted successfully!")
        except Exception as e:
            return Reply(result="False", message=f"Error: {str(e)}")

    def get_all_devices(self, request, context):
        query = "SELECT * FROM devices WHERE user_id = %s"
        values = (request.userId,)
        self.cursor.execute(query, values)
        result = self.cursor.fetchall()

        items = [Item(deviceId=row[0], userId=row[1]) for row in result]
        return Reply(result="True", message="Devices retrieved successfully", items=items)

def main() -> None:
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    add_DeviceServicer_to_server(Device(), server)
    server.add_insecure_port('[::]:5001')
    server.start()
    server.wait_for_termination()

if __name__ == '__main__':
    main()