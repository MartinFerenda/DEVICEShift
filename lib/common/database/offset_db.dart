import 'package:device_shift/common/database/repositories/offset_repository.dart';
import 'package:sqflite/sqflite.dart';

import '../../feature/vibration_measurement/data/models/offset.dart';

class OffsetDB implements OffsetRepository{
  final tableName = 'offset';
  final Database _database;

  OffsetDB(this._database);

  Future<void> createTable() async {
    String createTableString = '''
    CREATE TABLE IF NOT EXISTS $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      xAxisOffset DOUBLE NOT NULL,
      yAxisOffset DOUBLE NOT NULL,
      zAxisOffset DOUBLE NOT NULL,
      measurementId INTEGER NOT NULL,
      FOREIGN KEY (measurementId) REFERENCES measurement(id)
      )''';
    await _database.execute(createTableString);
  }

  @override
  Future<int> insertAllMeasuredOffsets (List<MeasuredOffset> measuredOffsets, int measurementId) async {
    return await _database.transaction((transaction) async {
      for (var offset in measuredOffsets) {
        await transaction.insert(tableName, {
          'xAxisOffset': offset.xAxisOffset,
          'yAxisOffset': offset.yAxisOffset,
          'zAxisOffset': offset.zAxisOffset,
          'measurementId': measurementId,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
      return measuredOffsets.length;
    });
  }

  @override
  Future<int> deleteOffsets(int measurementId) async {
    return await _database.delete(
      tableName,
      where: 'measurementId = ?',
      whereArgs: [measurementId],
    );
  }

  @override
  Future<List<MeasuredOffset>> getOffsetsForMeasurement(int measurementId) async {
    final result = await _database.query(
      tableName,
      where: 'measurementId = ?',
      whereArgs: [measurementId],
    );
    return result.map((row) => MeasuredOffset.fromExternalModel(row)).toList();
  }
}