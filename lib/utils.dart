Duration clampDuration(Duration value, Duration min, Duration max) {
  final dValue = value.inMilliseconds.toDouble();
  final dMin = min.inMilliseconds.toDouble();
  final dMax = max.inMilliseconds.toDouble();
  return Duration(milliseconds: dValue.clamp(dMin, dMax).round());
}
