import 'package:device_shift/common/database/repositories/measurement_repository.dart';
import 'package:device_shift/common/database/repositories/offset_repository.dart';
import 'package:device_shift/feature/vibration_measurement/data/models/offset.dart';
import 'package:flutter/foundation.dart';

import '../../measurement_results/data/models/measurement.dart';

class MeasuringViewModel extends ChangeNotifier{
  final MeasurementRepository _measurementRepository;
  final OffsetRepository _offsetRepository;

  List<MeasuredOffset> _allMeasuredResults = [];

  MeasuringViewModel(this._measurementRepository, this._offsetRepository);

  Future<bool> saveMeasurementAndResultsToDB({required String title, String? description}) async {
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    int measurementId = await _measurementRepository.insertMeasurement(Measurement(id: 0, title: title, description: description, timeOfMeasurement: currentTime, favorite: false));
    if (measurementId > 0) {
      int numberOfInsertedOffsetRecords = await _offsetRepository
          .insertAllMeasuredOffsets(_allMeasuredResults, measurementId);
      if (numberOfInsertedOffsetRecords == _allMeasuredResults.length) {
        return true;
      } else {
        await _measurementRepository.deleteMeasurement(measurementId);
        return false;
      }
    } else {
      return false;
    }
  }

  void setMeasuredResults(List<MeasuredOffset> measuredOffsets) {
    _allMeasuredResults = measuredOffsets;
  }

  List<MeasuredOffset> getAllMeasuredOffsets() {
    return _allMeasuredResults;
  }

  void clearResults() {
    _allMeasuredResults.clear();
  }
}