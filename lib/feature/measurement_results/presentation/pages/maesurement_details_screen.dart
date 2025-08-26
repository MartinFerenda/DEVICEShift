import 'dart:math';

import 'package:device_shift/feature/measurement_results/data/models/measurement.dart';
import 'package:device_shift/feature/vibration_measurement/data/models/offset.dart';
import 'package:fftea/impl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../common/constants/app_screens.dart';
import '../../../../common/widgets/custom_app_bar.dart';

class MeasurementDetailsScreen extends StatelessWidget {
  const MeasurementDetailsScreen({super.key});

  List<FlSpot> getSpotsForGraph(List<double> magnitudes) {
    int fftSize = magnitudes.length;
    return List.generate(fftSize ~/ 2, (i) {
      double frequency = i * 10.0 / fftSize;
      return FlSpot(frequency, magnitudes[i]);
    });
  }

  @override
  Widget build(BuildContext context) {

    final arguments = ModalRoute.of(context)?.settings.arguments as Map;
    final measurement = arguments['measurement'] as Measurement;
    final measuredOffsets = arguments['measuredOffsets'] as List<MeasuredOffset>;

    List<double> xOffsets = [];
    List<double> yOffsets = [];
    List<double> zOffsets = [];

    for (int i = 0; i < measuredOffsets.length; i++) {
      MeasuredOffset offset = measuredOffsets.elementAt(i);
      xOffsets.add(offset.xAxisOffset);
      yOffsets.add(offset.yAxisOffset);
      zOffsets.add(offset.zAxisOffset);
    }

    final fftX = FFT(xOffsets.length);
    final spectrumX = fftX.realFft(xOffsets);
    final magnitudesX = spectrumX.map((c) => sqrt(c.x * c.x + c.y *c.y)).toList();
    List<FlSpot> xSpots = getSpotsForGraph(magnitudesX.cast<double>());

    final fftY = FFT(yOffsets.length);
    final spectrumY = fftY.realFft(yOffsets);
    final magnitudesY = spectrumY.map((c) => sqrt(c.x * c.x + c.y *c.y)).toList();
    List<FlSpot> ySpots = getSpotsForGraph(magnitudesY.cast<double>());

    final fftZ = FFT(zOffsets.length);
    final spectrumZ = fftZ.realFft(zOffsets);
    final magnitudesZ = spectrumZ.map((c) => sqrt(c.x * c.x + c.y *c.y)).toList();
    List<FlSpot> zSpots = getSpotsForGraph(magnitudesZ.cast<double>());

    var dateAndTime = DateFormat('dd.MM.yyyy. HH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(measurement.timeOfMeasurement));

    return Scaffold(
      appBar: CustomAppBar(currentScreen: AppScreens.resultDetails.index),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                children: [
                  Text(measurement.title),
                ],
              )
            ),
            SizedBox(
              height: 300,
              child: Padding(padding: EdgeInsetsGeometry.all(10),
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: xSpots,
                        isCurved: true,
                        color: Colors.redAccent,
                        dotData: FlDotData(show: false),
                      ),
                      LineChartBarData(
                        spots: ySpots,
                        isCurved: true,
                        color: Colors.green,
                        dotData: FlDotData(show: false),
                      ),
                      LineChartBarData(
                        spots: zSpots,
                        isCurved: true,
                        color: Colors.blueAccent,
                        dotData: FlDotData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(padding: EdgeInsetsGeometry.only(left: 0, right: 0, top: 10, bottom: 0),
                  child: Text(
                      dateAndTime
                  ),
                )
              ],
            ),
            Divider(
              color: Colors.black38,
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    textAlign: TextAlign.left,
                    measurement.description ?? ""
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}