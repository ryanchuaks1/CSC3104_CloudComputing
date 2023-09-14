sh.enableSharding("mongo_db");
sh.shardCollection("mongo_db.devices", {"_id": 1});