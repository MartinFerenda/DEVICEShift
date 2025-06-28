import 'dart:async';
import 'package:device_shift/common/database/offset_db.dart';
import 'package:device_shift/feature/vibration_measurement/data/models/offset.dart';
import 'package:device_shift/feature/vibration_measurement/domain/measurement_viewmodel.dart';
import 'package:device_shift/feature/vibration_measurement/presentation/enums/measuring_state.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../common/database/database_service.dart';
import '../../../../common/database/measurement_db.dart';

class MeasurementScreen extends StatefulWidget {
  final VoidCallback onNavigateToThird;
  const MeasurementScreen({required this.onNavigateToThird, super.key});

  @override
  State<MeasurementScreen> createState() => _MeasurementScreenState();
}

class _MeasurementScreenState extends State<MeasurementScreen> {
  MeasuringViewModel? _measuringViewModel;

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  double buttonsWidth = 150;

  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  List<MeasuredOffset> _allMeasuredData = [];
  List<MeasuredOffset> _lastValuesForGraph = [];
  double _startTime = 0;
  MeasuringState _measuringState = MeasuringState.idle;
  final double _visibleGraphDuration = 10;

  @override
  void initState() {
    super.initState();
    _initializeViewModel();
  }

  Future<void> _initializeViewModel() async {
    final dbService = DatabaseService();
    final db = await dbService.database;
    final measurementRepository = MeasurementDB(db);
    final offsetRepository = OffsetDB(db);
    setState(() {
      _measuringViewModel = MeasuringViewModel(measurementRepository, offsetRepository);
    });
  }

  void _startMeasuring() {
    _startTime = DateTime.now().millisecondsSinceEpoch.toDouble();
    _lastValuesForGraph.clear();
    _allMeasuredData.clear();
    _measuringViewModel?.clearResults();

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
    _measuringViewModel?.setMeasuredResults(_allMeasuredData);
    setState(() {
      _measuringState = MeasuringState.stopped;
    });
  }

  void _saveResults() {
    setState(() {
      _measuringState = MeasuringState.saving;
    });
  }

  Future<void> _saveMeasurementAndResultsToDB(BuildContext context) async {
    bool? measurementAndResultsSaved = false;
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text.trim();
      final description = _descriptionController.text.trim();
      measurementAndResultsSaved = await _measuringViewModel?.saveMeasurementAndResultsToDB(title: title, description: description);
    }
    if (measurementAndResultsSaved != null) {
      if(measurementAndResultsSaved) {
        widget.onNavigateToThird();
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            actions: [
              TextButton(onPressed: (){
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
            title: const Text('Error'),
            contentPadding: const EdgeInsets.all(20.0),
            content: const Text('Error saving data. Please try again.'),
          ),
        );
      }
    }
  }

  void _reset() {
    _lastValuesForGraph.clear();
    _allMeasuredData.clear();
    _measuringViewModel?.clearResults();
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
    if (_lastValuesForGraph.isEmpty) return [];
    final double latestX = _lastValuesForGraph.last.offsetTime;
    final double windowStart = latestX - _visibleGraphDuration;

    return _lastValuesForGraph.where((spot) => spot.offsetTime >= windowStart).map((spot) => FlSpot(spot.offsetTime, spot.xAxisOffset > 5 ? 5 : spot.xAxisOffset)).toList();
  }

  List<FlSpot> _getYAxisSpots() {
    if (_lastValuesForGraph.isEmpty) return [];
    final double latestX = _lastValuesForGraph.last.offsetTime;
    final double windowStart = latestX - _visibleGraphDuration;

    return _lastValuesForGraph.where((spot) => spot.offsetTime >= windowStart).map((spot) => FlSpot(spot.offsetTime, spot.yAxisOffset > 5 ? 5 : spot.yAxisOffset)).toList();
  }

  List<FlSpot> _getZAxisSpots() {
    if (_lastValuesForGraph.isEmpty) return [];
    final double latestX = _lastValuesForGraph.last.offsetTime;
    final double windowStart = latestX - _visibleGraphDuration;

    return _lastValuesForGraph.where((spot) => spot.offsetTime >= windowStart).map((spot) => FlSpot(spot.offsetTime, spot.zAxisOffset > 5 ? 5 : spot.zAxisOffset)).toList();
  }

  @override
  Widget build(BuildContext context) {
    // _measuringViewModel = Provider.of<MeasuringViewModel>(context);
    final visibleXSpots = _getXAxisSpots();
    final visibleYSpots = _getYAxisSpots();
    final visibleZSpots = _getZAxisSpots();

    if (visibleXSpots.isEmpty) {
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
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Title is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description (optional)'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent
                      ),
                      onPressed:() {
                        _saveMeasurementAndResultsToDB(context);
                      },
                      child: const Text('SAVE'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              //TODO: MAYBE ADD LEGEND WITH COLORS FOR EACH AXIS
              child: LineChart(
                LineChartData(
                  minX: visibleXSpots.first.x,
                  maxX: visibleXSpots.first.x + _visibleGraphDuration,
                  lineBarsData: [
                    LineChartBarData(
                      spots: visibleXSpots,
                      isCurved: true,
                      color: Colors.redAccent,
                      dotData: FlDotData(show: false),
                    ),
                    LineChartBarData(
                      spots: visibleYSpots,
                      isCurved: true,
                      color: Colors.green,
                      dotData: FlDotData(show: false),
                    ),
                    LineChartBarData(
                      spots: visibleZSpots,
                      isCurved: true,
                      color: Colors.blueAccent,
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
                  //TODO: IF REFERENT MEASUREMENT IS SET IN PREFS, ADD BUTTON FOR COMPARING TO CURRENT MEASURING
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
