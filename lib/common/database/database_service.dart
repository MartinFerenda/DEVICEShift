import 'package:device_shift/common/database/measurement_db.dart';
import 'package:device_shift/common/database/offset_db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService{
  Database? _database;

  Future<Database> get database async{
    if(_database != null){
      return _database!;
    }
    _database = await _initializeDatabase();
    return _database!;
  }

  Future<String> get fullPath async{
    const name = 'device_shift.db';
    final path = await getDatabasesPath();
    return join(path, name);
  }

  Future<Database> _initializeDatabase() async{
    final path = await fullPath;
    var database = await openDatabase(
      path,
      version: 1,
      onCreate: create,
      singleInstance: true,
    );
    return database;
  }

  Future<void> create(Database database, int version) async {
    await MeasurementDB(database).createTable();
    await OffsetDB(database).createTable();
  }
}