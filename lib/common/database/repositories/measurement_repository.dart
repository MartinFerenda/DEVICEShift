import '../../../feature/measurement_results/data/models/measurement.dart';

abstract class MeasurementRepository {
  Future<int> insertMeasurement(Measurement measurement);
  Future<List<Measurement>> getAllMeasurements();
  Future<int> deleteMeasurement(int id);
  Future<int> updateFavoriteStatus(int measurementId, bool favorite);
}