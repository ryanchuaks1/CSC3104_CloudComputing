from flask import Flask, request, jsonify
from pymongo import MongoClient

# Define the MongoDB connection string
MONGO_URI = "mongodb://root:password@mongodb:27017/mongo_db?authSource=admin&readPreference=primary&appname=MongoDB%20Compass&retryWrites=true&ssl=false"

# Create the Flask app
app = Flask(__name__)
db = None


def connect_db() -> MongoClient:
    global MONGO_URI
    try:
        # Connect to MongoDB
        client = MongoClient(MONGO_URI)
        print("Connected to MongoDB successfully!")
    except errors.ConnectionFailure as e:
        print("Could not connect to MongoDB:", e)
    except Exception as e:
        print("An error occurred:", e)
    
    return client


def close_db(client: MongoClient) -> None:
    if client:
        # Close the connection when done
        client.close()


@app.route("/api/addNewDevice", methods=["POST"])
def add_new_device():
    global db
    device_data = request.get_json()
    devices_collection = db.devices

    # Add the new device to the collection
    new_device = {"deviceId": device_data["deviceId"]}
    devices_collection.insert_one(new_device)

    return {"result": True, "message": "Device added successfully!"}, 201


@app.route("/api/updateDevice", methods=["POST"])
def update_device():
    global db
    device_data = request.get_json()
    devices_collection = db.devices

    # Update the existing device in the collection
    update_query = {"_id": device_data["id"]}
    update_data = {"deviceId": device_data["deviceId"]}
    devices_collection.update_one(update_query, update_data)

    return {"result": True, "message": "Device updated successfully!"}, 201


@app.route("/api/deleteDevice", methods=["POST"])
def delete_device():
    global db
    device_data = request.get_json()
    devices_collection = db.devices

    # Delete the device from the collection
    delete_query = {"_id": device_data["id"]}
    devices_collection.delete_one(delete_query)

    return {"result": True, "message": "Device deleted successfully!"}, 201


@app.route("/api/getAllDevices")
def get_all_devices():
    global db
    devices_collection = db.devices

    # Get all devices from the collection
    all_devices = devices_collection.find()

    return jsonify(all_devices), 201


def main() -> None:
    global db
    # Connect to the MongoDB database
    client = connect_db()
    # Get the database
    db = client.get_database()
    while True:
        try:
            app.run(host="0.0.0.0", port=5000, debug=True)
        except KeyboardInterrupt:
            break
    close_db(client)


if __name__ == '__main__':
    main()
