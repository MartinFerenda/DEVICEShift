class MeasuredOffset{
  final int id;
  final double xAxisOffset;
  final double yAxisOffset;
  final double zAxisOffset;
  final double offsetTime;
  final int measurementId;

  MeasuredOffset({
    required this.id,
    required this.xAxisOffset,
    required this.yAxisOffset,
    required this.zAxisOffset,
    required this.offsetTime,
    required this.measurementId,
  });

  factory MeasuredOffset.fromExternalModel(Map<String, dynamic> offsetEntity){
    return MeasuredOffset(
        id: offsetEntity['id'],
        xAxisOffset: offsetEntity['xAxisOffset'],
        yAxisOffset: offsetEntity['yAxisOffset'],
        zAxisOffset: offsetEntity['zAxisOffset'],
        offsetTime: offsetEntity['offsetTime'],
        measurementId: offsetEntity['measurementId']);
  }
}