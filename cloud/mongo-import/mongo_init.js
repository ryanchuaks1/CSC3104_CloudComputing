sh.enableSharding("mongo_db");
sh.shardCollection("mongo_db.devices", {"_id": 1});

use mongo_db;
db.devices.createIndex( { post_id: -1 } );