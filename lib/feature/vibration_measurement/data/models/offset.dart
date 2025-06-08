class Offset{
  final int id;
  final double xAxisOffset;
  final double yAxisOffset;
  final double zAxisOffset;
  final int measurementId;

  Offset({
    required this.id,
    required this.xAxisOffset,
    required this.yAxisOffset,
    required this.zAxisOffset,
    required this.measurementId,
  });

  factory Offset.fromExternalModel(Map<String, dynamic> offsetEntity){
    return Offset(
        id: offsetEntity['id'],
        xAxisOffset: offsetEntity['xAxisOffset'],
        yAxisOffset: offsetEntity['yAxisOffset'],
        zAxisOffset: offsetEntity['zAxisOffset'],
        measurementId: offsetEntity['measurementId']);
  }
}