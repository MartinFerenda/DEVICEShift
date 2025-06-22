import 'package:device_shift/common/database/repositories/measurement_repository.dart';
import 'package:device_shift/common/database/repositories/offset_repository.dart';
import 'package:device_shift/feature/vibration_measurement/data/models/offset.dart';

import '../../measurement_results/data/models/measurement.dart';

class MeasuringViewModel {
  final MeasurementRepository _measurementRepository;
  final OffsetRepository _offsetRepository;

  MeasuringViewModel(this._measurementRepository, this._offsetRepository);

  Future<bool> saveMeasurementAndResultsToDB({required String title, String? description, required List<MeasuredOffset> allMeasuredResults}) async {
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    int measurementId = await _measurementRepository.insertMeasurement(Measurement(id: 0, title: title, description: description, timeOfMeasurement: currentTime, favorite: false));
    if (measurementId > 0) {
      int numberOfInsertedOffsetRecords = await _offsetRepository
          .insertAllMeasuredOffsets(allMeasuredResults, measurementId);
      if (numberOfInsertedOffsetRecords == allMeasuredResults.length) {
        return true;
      } else {
        await _measurementRepository.deleteMeasurement(measurementId);
        return false;
      }
    } else {
      return false;
    }
  }
}