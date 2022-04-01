import 'package:flutter/material.dart';

class ClockTheme {
  final Color startColor;

  final Color endColor;

  static const ClockTheme orange = ClockTheme(
    startColor: Color(0xFFE65100),
    endColor: Color(0xFFFFEB3B),
  );

  static const ClockTheme white = ClockTheme(
    startColor: Color(0xFF5F9EA0),
    endColor: Color(0xFFF0FFFF),
  );

  static const ClockTheme blue = ClockTheme(
    startColor: Color(0xFF000080),
    endColor: Color(0xFF6495ED),
  );

  static const ClockTheme grey = ClockTheme(
    startColor: Color(0xFF607D8B),
    endColor: Color(0xFFDDDDDD),
  );

  static const ClockTheme purple = ClockTheme(
    startColor: Color(0xFF151547),
    endColor: Color(0xFFAB47BC),
  );

  const ClockTheme({required this.startColor, required this.endColor});

  @override
  int get hashCode => super.hashCode;
}
