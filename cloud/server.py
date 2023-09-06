import pymongo

# Define the MongoDB connection string
mongo_uri = "mongodb://root:password@mongodb:27017/mongo_db?authSource=admin&readPreference=primary&appname=MongoDB%20Compass&retryWrites=true&ssl=false"

try:
    # Connect to MongoDB
    client = pymongo.MongoClient(mongo_uri)

    # Access the database
    db = client.get_database()

    # Perform database operations here...
    # For example, you can access collections like this:
    # collection = db.my_collection
    # documents = collection.find()

    # Close the connection when done
    client.close()
    print("Connected to MongoDB successfully!")

except pymongo.errors.ConnectionFailure as e:
    print("Could not connect to MongoDB:", e)

except Exception as e:
    print("An error occurred:", e)
