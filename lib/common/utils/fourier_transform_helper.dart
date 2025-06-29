import 'dart:math';

import 'package:device_shift/common/constants/fourier_transform_axis.dart';
import 'package:device_shift/feature/vibration_measurement/data/models/offset.dart';
import 'package:fftea/impl.dart';
import 'package:fl_chart/fl_chart.dart';

class FourierTransformHelper {
  static List<FlSpot> applyFourierTransformToOffsets(List<MeasuredOffset> measuredOffsets, FourierTransformAxis axis) {
    List<double> offsets = [];

    if (axis == FourierTransformAxis.xAxis) {
      for (int i = 0; i < measuredOffsets.length; i++) {
        offsets.add(measuredOffsets.elementAt(i).xAxisOffset);
      }
    } else if (axis == FourierTransformAxis.yAxis) {
      for (int i = 0; i < measuredOffsets.length; i++) {
        offsets.add(measuredOffsets.elementAt(i).yAxisOffset);
      }
    } else if (axis == FourierTransformAxis.zAxis) {
      for (int i = 0; i < measuredOffsets.length; i++) {
        offsets.add(measuredOffsets.elementAt(i).zAxisOffset);
      }
    }

    final fft = FFT(offsets.length);
    final spectrum = fft.realFft(offsets);
    final magnitudes = spectrum.map((c) => sqrt(c.x * c.x + c.y * c.y)).toList();
    List<double> magnitudesValuesForGraph = magnitudes.cast<double>();

    int halfMagnitudes = magnitudesValuesForGraph.length ~/ 2;
    double sampling = 10.0;
    double frequencyStep = sampling / magnitudesValuesForGraph.length;
    List<FlSpot> spotsForGraph = [];

    for (int i = 0; i < halfMagnitudes; i++) {
      double frequency = i * frequencyStep;
      double amplitude = magnitudes[i];
      spotsForGraph.add(FlSpot(frequency, amplitude));
    }

    return spotsForGraph;
  }
}