import pymongo

# Define the MongoDB connection string
MONGO_URI = "mongodb://root:password@mongodb:27017/mongo_db?authSource=admin&readPreference=primary&appname=MongoDB%20Compass&retryWrites=true&ssl=false"


def connect_db() -> pymongo.MongoClient:
    global MONGO_URI
    try:
        # Connect to MongoDB
        client = pymongo.MongoClient(MONGO_URI)
        print("Connected to MongoDB successfully!")
    except pymongo.errors.ConnectionFailure as e:
        print("Could not connect to MongoDB:", e)
    except Exception as e:
        print("An error occurred:", e)


def perform_db(client: pymongo.MongoClient) -> None:
    # Access the database
    db = client.get_database()

    # Perform database operations here...
    # For example, you can access collections like this:
    # collection = db.my_collection
    # documents = collection.find()


def close_db(client: pymongo.MongoClient) -> None:
    if client:
        # Close the connection when done
        client.close()


def main() -> None:
    client = connect_db()
    perform_db(client)
    close_db(client)


if __name__ == '__main__':
    main()
