class Measurement {
  final int id;
  final String title;
  final String? description;
  final int timeOfMeasurement;
  final bool favorite;

  Measurement({
    required this.id,
    required this.title,
    this.description,
    required this.timeOfMeasurement,
    required this.favorite,
  });

  factory Measurement.fromExternalModel(Map<String, dynamic> measurementEntity){
    return Measurement(
        id: measurementEntity['id'],
        title: measurementEntity['title'],
        description: measurementEntity['description'],
        timeOfMeasurement: measurementEntity['timeOfMeasurement'],
        favorite: measurementEntity['favorite'] == 1);
  }
}