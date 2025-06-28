import 'package:device_shift/feature/measurement_results/data/models/measurement.dart';
import 'package:device_shift/feature/vibration_measurement/data/models/offset.dart';

import '../../../common/database/repositories/measurement_repository.dart';
import '../../../common/database/repositories/offset_repository.dart';

class ResultsViewModel {
  final MeasurementRepository _measurementRepository;
  final OffsetRepository _offsetRepository;

  ResultsViewModel(this._measurementRepository, this._offsetRepository);

  Future<List<Measurement>> getAllMeasurements() async {
    return await _measurementRepository.getAllMeasurements();
  }

  Future<bool> setMeasurementAsFavorite(int measurementId, bool isFavorite) async{
    final result = await _measurementRepository.updateFavoriteStatus(measurementId, !isFavorite);
    if (result > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteMeasurement(int measurementId) async {
    final offsetsDeleted = await _offsetRepository.deleteOffsets(measurementId);
    if (offsetsDeleted > 0) {
      final measurementDeleted = await _measurementRepository.deleteMeasurement(measurementId);
      if (measurementDeleted > 0) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<List<MeasuredOffset>> getOffsetsForMeasurement(int measurementId) async {
    return await _offsetRepository.getOffsetsForMeasurement(measurementId);
  }
}