import 'package:device_shift/feature/measurement_results/data/models/measurement.dart';
import 'package:device_shift/feature/vibration_measurement/data/models/offset.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../common/constants/app_screens.dart';
import '../../../../common/widgets/custom_app_bar.dart';

class MeasurementDetailsScreen extends StatelessWidget {
  const MeasurementDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final arguments = ModalRoute.of(context)?.settings.arguments as Map;
    final measurement = arguments['measurement'] as Measurement;
    final measuredOffsets = arguments['measuredOffsets'] as List<MeasuredOffset>;

    List<FlSpot> xOffsets = [];
    List<FlSpot> yOffsets = [];
    List<FlSpot> zOffsets = [];

    for (int i = 0; i < measuredOffsets.length; i++) {
      MeasuredOffset offset = measuredOffsets.elementAt(i);
      xOffsets.add(FlSpot(offset.offsetTime, offset.xAxisOffset));
      yOffsets.add(FlSpot(offset.offsetTime, offset.yAxisOffset));
      zOffsets.add(FlSpot(offset.offsetTime, offset.zAxisOffset));
    }

    var dateAndTime = DateFormat('dd.MM.yyyy. HH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(measurement.timeOfMeasurement));

    return Scaffold(
      appBar: CustomAppBar(currentScreen: AppScreens.resultDetails.index),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Padding(padding: EdgeInsetsGeometry.only(left: 0, right: 0, top: 10, bottom: 10),
                  child: Text(
                    measurement.title,
                    overflow: TextOverflow.clip,
                    maxLines: 3,
                    softWrap: false,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 300,
              child: Padding(padding: EdgeInsetsGeometry.all(10),
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: xOffsets,
                        isCurved: true,
                        color: Colors.redAccent,
                        dotData: FlDotData(show: false),
                      ),
                      LineChartBarData(
                        spots: yOffsets,
                        isCurved: true,
                        color: Colors.green,
                        dotData: FlDotData(show: false),
                      ),
                      LineChartBarData(
                        spots: zOffsets,
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
            Row(
              children: [
                Text(
                  measurement.description ?? ""
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}