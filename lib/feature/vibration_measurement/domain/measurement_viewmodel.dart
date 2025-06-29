import 'package:device_shift/common/constants/fourier_transform_axis.dart';
import 'package:device_shift/common/database/repositories/measurement_repository.dart';
import 'package:device_shift/common/database/repositories/offset_repository.dart';
import 'package:device_shift/common/preferences/app_preferences.dart';
import 'package:device_shift/common/utils/fourier_transform_helper.dart';
import 'package:device_shift/feature/vibration_measurement/data/models/offset.dart';
import 'package:fl_chart/fl_chart.dart';
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

  Future<int> compareCurrentToReferentMeasurement(int currentReferentMeasurement, List<MeasuredOffset> measuredOffsets) async {

    double? allowedFrequencyDeviation = AppPreferences.getAllowedFrequencyDeviation();
    double? allowedAmplitudeDeviation = AppPreferences.getAllowedAmplitudeDeviation();

    if (allowedFrequencyDeviation != null && allowedAmplitudeDeviation != null) {
      if (allowedFrequencyDeviation >= 0 && allowedAmplitudeDeviation >= 0) {

        List<MeasuredOffset> referentMeasuredOffsets = await getOffsetsForMeasurement(currentReferentMeasurement);

        List<FlSpot> referentXFlSpots = FourierTransformHelper.applyFourierTransformToOffsets(referentMeasuredOffsets, FourierTransformAxis.xAxis);
        List<FlSpot> referentYFlSpots = FourierTransformHelper.applyFourierTransformToOffsets(referentMeasuredOffsets, FourierTransformAxis.yAxis);
        List<FlSpot> referentZFlSpots = FourierTransformHelper.applyFourierTransformToOffsets(referentMeasuredOffsets, FourierTransformAxis.zAxis);

        List<FlSpot> measuredXFlSpots = FourierTransformHelper.applyFourierTransformToOffsets(measuredOffsets, FourierTransformAxis.xAxis);
        List<FlSpot> measuredYFlSpots = FourierTransformHelper.applyFourierTransformToOffsets(measuredOffsets, FourierTransformAxis.yAxis);
        List<FlSpot> measuredZFlSpots = FourierTransformHelper.applyFourierTransformToOffsets(measuredOffsets, FourierTransformAxis.zAxis);

        bool isFrequencyFoundWithinRanges = false;

        for (int i = 0; i < referentXFlSpots.length; i++) {
          isFrequencyFoundWithinRanges = false;
          for (int j = 0; j < measuredXFlSpots.length; j++) {
            if (measuredXFlSpots[j].x > (referentXFlSpots[i].x - allowedFrequencyDeviation)
              && measuredXFlSpots[j].x < (referentXFlSpots[i].x + allowedFrequencyDeviation)) {
              if ((measuredXFlSpots[j].y - referentXFlSpots[i].y).abs() < allowedAmplitudeDeviation) {
                isFrequencyFoundWithinRanges = true;
                break;
              }
            }
          }
          if (!isFrequencyFoundWithinRanges) {
            return 1;
          }
        }

        for (int i = 0; i < referentYFlSpots.length; i++) {
          isFrequencyFoundWithinRanges = false;
          for (int j = 0; j < measuredYFlSpots.length; j++) {
            if (measuredYFlSpots[j].x > (referentYFlSpots[i].x - allowedFrequencyDeviation)
                && measuredYFlSpots[j].x < (referentYFlSpots[i].x + allowedFrequencyDeviation)) {
              if ((measuredYFlSpots[j].y - referentYFlSpots[i].y).abs() < allowedAmplitudeDeviation) {
                isFrequencyFoundWithinRanges = true;
                break;
              }
            }
          }
          if (!isFrequencyFoundWithinRanges) {
            return 1;
          }
        }

        for (int i = 0; i < referentZFlSpots.length; i++) {
          isFrequencyFoundWithinRanges = false;
          for (int j = 0; j < measuredZFlSpots.length; j++) {
            if (measuredZFlSpots[j].x > (referentZFlSpots[i].x - allowedFrequencyDeviation)
                && measuredZFlSpots[j].x < (referentZFlSpots[i].x + allowedFrequencyDeviation)) {
              if ((measuredZFlSpots[j].y - referentZFlSpots[i].y).abs() < allowedAmplitudeDeviation) {
                isFrequencyFoundWithinRanges = true;
                break;
              }
            }
          }
          if (!isFrequencyFoundWithinRanges) {
            return 1;
          }
        }
        return 0;
      } else {
        return 2;
      }
    } else {
      return 2;
    }
  }

  Future<List<MeasuredOffset>> getOffsetsForMeasurement(int measurementId) async {
    return await _offsetRepository.getOffsetsForMeasurement(measurementId);
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