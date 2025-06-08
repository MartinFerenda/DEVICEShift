import 'package:device_shift/feature/vibration_measurement/data/models/offset.dart';

abstract class OffsetRepository{
  Future<int> insertAllMeasuredOffsets(List<Offset> measuredOffsets, int measurementId);
  Future<List<Offset>> getOffsetsForMeasurement(int measurementId);
  Future<int> deleteOffsets(int measurementId);
}