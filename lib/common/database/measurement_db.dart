import 'package:device_shift/common/database/repositories/measurement_repository.dart';
import 'package:device_shift/feature/measurement_results/data/models/measurement.dart';
import 'package:sqflite/sqflite.dart';

class MeasurementDB implements MeasurementRepository{
  final tableName = 'measurement';
  final Database _database;

  MeasurementDB(this._database);

  Future<void> createTable() async {
    String createTableString = '''
    CREATE TABLE IF NOT EXISTS $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        timeOfMeasurement INTEGER NOT NULL,
        favorite INTEGER NOT NULL
        )''';
    await _database.execute(createTableString);
  }

  @override
  Future<int> deleteMeasurement(int id) async {
    return await _database.delete(
        tableName,
        where: 'id = ?',
        whereArgs: [id],);
  }

  @override
  Future<List<Measurement>> getAllMeasurements() async {
    final result = await _database.query(tableName);
    return result.map((row) => Measurement.fromExternalModel(row)).toList();
  }

  @override
  Future<int> insertMeasurement(Measurement measurement) async {
    return await _database.insert(
        tableName, {
      'title': measurement.title,
      'description': measurement.description,
      'timeOfMeasurement': measurement.timeOfMeasurement,
      'favorite': measurement.favorite ? 1 : 0
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}