import 'dart:async';
import 'package:device_shift/common/database/offset_db.dart';
import 'package:device_shift/common/preferences/app_preferences.dart';
import 'package:device_shift/feature/vibration_measurement/data/models/offset.dart';
import 'package:device_shift/feature/vibration_measurement/domain/measurement_viewmodel.dart';
import 'package:device_shift/feature/vibration_measurement/presentation/enums/measuring_state.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../common/database/database_service.dart';
import '../../../../common/database/measurement_db.dart';
import '../../../../l10n/app_localizations.dart';

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
  double buttonsHeight = 40;

  StreamSubscription<UserAccelerometerEvent>? _userAccelerometerSubscription;
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

    //TODO: NUMBER OF READINGS PER SECOND
    _userAccelerometerSubscription = userAccelerometerEventStream().listen((event) {
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
    _userAccelerometerSubscription?.cancel();
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

  Future<void> _saveMeasurementAndResultsToDB(BuildContext context, AppLocalizations localizations) async {
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
                child: Text(localizations.ok),
              ),
            ],
            title: Text(localizations.error),
            contentPadding: const EdgeInsets.all(20.0),
            content: Text(localizations.error_saving_data),
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

  void _compareResultToReferent(AppLocalizations localizations) async{
    int? currentReferentMeasurementId = AppPreferences.getReferentMeasurementId();
    if (currentReferentMeasurementId != null) {
      if (currentReferentMeasurementId > 0) {
        int? operatingDeviceStatus = await _measuringViewModel?.compareCurrentToReferentMeasurement(currentReferentMeasurementId, _allMeasuredData);
        if (operatingDeviceStatus == 0) {
          _showResultInDialog(title: localizations.comparison_successful, content: localizations.device_ok);
        } else if (operatingDeviceStatus == 1) {
          _showResultInDialog(title: localizations.comparison_successful, content: localizations.device_not_ok);
        } else {
          _showResultInDialog(title: localizations.error, content: localizations.allowed_deviation_not_specified);
        }
      } else {
        _showResultInDialog(title: localizations.error, content: localizations.referent_measurement_not_selected);
      }
    } else {
      _showResultInDialog(title: localizations.error, content: localizations.referent_measurement_not_selected);
    }
  }

  Future<void> _showResultInDialog ({required String title, required String content}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog (
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }

  @override
  void dispose() {
    _userAccelerometerSubscription?.cancel();
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
    final localizations = AppLocalizations.of(context)!;
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
              localizations.start
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
                    decoration: InputDecoration(labelText: localizations.title),
                    validator: (value) =>
                    value == null || value.trim().isEmpty ? localizations.title_required : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: localizations.description_optional),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent
                      ),
                      onPressed:() {
                        _saveMeasurementAndResultsToDB(context, localizations);
                      },
                      child: Text(localizations.save),
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
            child: Column(
              children: [
                Padding(padding: EdgeInsetsGeometry.only(left: 0, right: 0, top: 15, bottom: 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: buttonsWidth,
                        height: buttonsHeight,
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
                            textAlign: TextAlign.center,
                            (){
                              if (_measuringState == MeasuringState.running) {
                                return localizations.stop;
                              } else if (_measuringState == MeasuringState.idle){
                                return localizations.start;
                              } else {
                                return localizations.reset;
                              }
                            }(),
                          ),
                        ),
                      ),
                      if (_measuringState == MeasuringState.stopped) ... [
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: buttonsWidth,
                          height: buttonsHeight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.greenAccent
                            ),
                            onPressed: (){
                              _saveResults();
                            },
                            child: Text(
                              localizations.save
                            )
                          ),
                        ),
                      ],
                    ]
                  ),
                ),
                if (AppPreferences.getReferentMeasurementId() != null && AppPreferences.getReferentMeasurementId()! > 0 && _measuringState == MeasuringState.stopped) ... [
                  Padding(padding: EdgeInsetsGeometry.only(left: 0, right: 0, top: 20, bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: SizedBox(
                            width: buttonsWidth,
                            height: buttonsHeight,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.greenAccent
                              ),
                              onPressed: (){
                                _compareResultToReferent(localizations);
                              },
                              child: Text(
                                localizations.compare
                              )
                            ),
                          ),
                        ),
                      ]
                    ),
                  ),
                ]
              ]
            )
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
