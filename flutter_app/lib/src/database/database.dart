import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase {
  static var db;

  static connect() async {
    db = await Db.create("mongodb://root:password@mongodb:27017/mongo_db?authSource=admin&readPreference=primary&appname=MongoDB%20Compass&retryWrites=true&ssl=false");
    await db.open();
  }
}
