import 'dart:async';
import 'package:device_shift/feature/vibration_measurement/data/models/offset.dart';
import 'package:device_shift/feature/vibration_measurement/presentation/enums/measuring_state.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MeasurementScreen extends StatefulWidget {
  const MeasurementScreen({super.key});

  @override
  _MeasurementScreenState createState() => _MeasurementScreenState();
}

class _MeasurementScreenState extends State<MeasurementScreen> {
  double buttonsWidth = 150;

  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  List<MeasuredOffset> _allMeasuredData = [];
  List<MeasuredOffset> _lastValuesForGraph = [];
  double _startTime = 0;
  MeasuringState _measuringState = MeasuringState.idle;
  final double _visibleGraphDuration = 10;

  void _startMeasuring() {
    _startTime = DateTime.now().millisecondsSinceEpoch.toDouble();
    _lastValuesForGraph.clear();
    _allMeasuredData.clear();

    _accelerometerSubscription = accelerometerEvents.listen((event) {
      final currentTime = DateTime.now().millisecondsSinceEpoch.toDouble();
      final time = (currentTime - _startTime) / 1000.0;

      setState(() {
        _allMeasuredData.add(MeasuredOffset(id: 0, xAxisOffset: event.x, yAxisOffset: event.y, zAxisOffset: event.z, offsetTime: time, measurementId: 0));
        _lastValuesForGraph.add(MeasuredOffset(id: 0, xAxisOffset: event.x, yAxisOffset: event.y, zAxisOffset: event.z, offsetTime: time, measurementId: 0));
        if (_lastValuesForGraph.length > 100) {
          _lastValuesForGraph.removeAt(0);
        }
      });
    });

    setState(() {
      _measuringState = MeasuringState.running;
    });
  }

  void _stopMeasuring() {
    _accelerometerSubscription?.cancel();
    setState(() {
      _measuringState = MeasuringState.stopped;
    });
  }

  void _saveResults() {
    setState(() {
      _measuringState = MeasuringState.saving;
    });
  }

  void _reset() {
    _lastValuesForGraph.clear();
    _allMeasuredData.clear();
    _startTime = 0;
    setState(() {
      _measuringState = MeasuringState.idle;
    });
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  List<FlSpot> _getXAxisSpots() {
    // return _lastValuesForGraph.map((m) => FlSpot(m.offsetTime, m.xAxisOffset)).toList();
    if (_lastValuesForGraph.isEmpty) return [];
    final double latestX = _lastValuesForGraph.last.offsetTime;
    final double windowStart = latestX - _visibleGraphDuration;

    return _lastValuesForGraph.where((spot) => spot.offsetTime >= windowStart).map((spot) => FlSpot(spot.offsetTime, spot.xAxisOffset > 5 ? 5 : spot.xAxisOffset)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final visibleSpots = _getXAxisSpots();

    if (visibleSpots.isEmpty) {
      return Scaffold(
        body: Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent
            ),
            onPressed: () {
              if (_measuringState == MeasuringState.idle) {
                _startMeasuring();
              } else if (_measuringState == MeasuringState.running){
                _stopMeasuring();
              } else {
                _reset();
              }
            },
            child: Text(
              'START'
            ),
          ),
        )
      );
    } else {
      if (_measuringState == MeasuringState.saving) {
        return Scaffold(
          body: Center(
            child: Text(
              'SAVING...'
            ),
          )
        );
      }
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: LineChart(
                LineChartData(
                  minX: visibleSpots.first.x,
                  maxX: visibleSpots.first.x + _visibleGraphDuration,
                  lineBarsData: [
                    LineChartBarData(
                      spots: visibleSpots,
                      isCurved: true,
                      color: Colors.redAccent,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: buttonsWidth,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent
                    ),
                    onPressed: () {
                      if (_measuringState == MeasuringState.running) {
                        _stopMeasuring();
                      } else if (_measuringState == MeasuringState.idle){
                        _startMeasuring();
                      } else {
                        _reset();
                      }
                    },
                    child: Text(
                      (){
                        if (_measuringState == MeasuringState.running) {
                          return 'STOP';
                        } else if (_measuringState == MeasuringState.idle){
                          return 'START';
                        } else {
                          return 'RESET';
                        }
                      }(),
                    ),
                  ),
                ),
                if (_measuringState == MeasuringState.stopped) ... [
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    width: buttonsWidth,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent
                      ),
                      onPressed: (){
                        _saveResults();
                      },
                      child: Text(
                        'SAVE'
                      )
                    ),
                  ),
                ],
              ]
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
