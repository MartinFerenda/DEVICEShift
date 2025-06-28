import 'package:device_shift/common/preferences/app_preferences.dart';
import 'package:device_shift/feature/measurement_results/data/models/measurement.dart';
import 'package:device_shift/feature/measurement_results/presentation/widgets/results_list_item.dart';
import 'package:device_shift/feature/vibration_measurement/data/models/offset.dart';
import 'package:flutter/material.dart';

import '../../../../common/database/database_service.dart';
import '../../../../common/database/measurement_db.dart';
import '../../../../common/database/offset_db.dart';
import '../../domain/results_viewmodel.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  ResultsViewModel? _resultsViewmodel;
  Future<List<Measurement>>? _allMeasurements;
  int referentMeasurementId = 0;

  @override
  void initState() {
    super.initState();
    _initializeViewModel();
    referentMeasurementId = AppPreferences.getReferentMeasurementId() ?? 0;
  }

  Future<void> _initializeViewModel() async {
    final dbService = DatabaseService();
    final db = await dbService.database;
    final measurementRepository = MeasurementDB(db);
    final offsetRepository = OffsetDB(db);
    setState(() {
      _resultsViewmodel = ResultsViewModel(measurementRepository, offsetRepository);
      _allMeasurements = _resultsViewmodel?.getAllMeasurements();
    });
  }

  void _setFavorite(int id, bool currentFavoriteValue) async {
    final success = await _resultsViewmodel?.setMeasurementAsFavorite(id, currentFavoriteValue);
    if (success == true) {
      setState(() {
        _allMeasurements = _resultsViewmodel!.getAllMeasurements();
      });
    }
  }

  void _deleteMeasurement(int measurementId) async {
    final deleted = await _resultsViewmodel?.deleteMeasurement(measurementId);
    if (deleted == true) {
      setState(() {
        if (measurementId == AppPreferences.getReferentMeasurementId()) {
          AppPreferences.setReferentMeasurementId(-1);
        }
        _allMeasurements = _resultsViewmodel!.getAllMeasurements();
      });
    }
  }

  void _openDetailsScreen(Measurement measurement) async {
    List<MeasuredOffset>? measuredOffsets = await _resultsViewmodel?.getOffsetsForMeasurement(measurement.id);
    Navigator.pushNamed(context, '/measurement_details', arguments: {'measurement': measurement, 'measuredOffsets': measuredOffsets});
  }

  @override
  Widget build(BuildContext context) {
    referentMeasurementId = AppPreferences.getReferentMeasurementId() ?? -1;

    return Scaffold(
      body:  _allMeasurements == null
        ? const Center(child: CircularProgressIndicator())
        : FutureBuilder<List<Measurement>>(
          future: _allMeasurements,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No measurements found."));
            }

            final measurements = snapshot.data!;

            return ListView.builder(
              itemCount: measurements.length,
              itemBuilder: (context, index) {
                final measurement = measurements[index];
                return ResultsListItem(
                  title: measurement.title,
                  description: measurement.description,
                  isReferentMeasurement: measurement.id ==
                      referentMeasurementId ? true : false,
                  onTapSetReferent: () {
                    AppPreferences.setReferentMeasurementId(measurement.id);
                    setState(() {
                      referentMeasurementId = measurement.id;
                    });
                  },
                  isFavoriteMeasurement: measurement.favorite,
                  onTapSetFavorite: () {
                    _setFavorite(measurement.id, measurement.favorite);
                  },
                  onTapDelete: () {
                    _deleteMeasurement(measurement.id);
                  },
                  onTapOpenDetails: () {
                    _openDetailsScreen(measurement);
                  },
                );
              }
            );
          }
        )
    );
  }
}
