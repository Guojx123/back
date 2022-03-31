import 'package:back/utils/galaxy_clock/clock/painter.dart';
import 'package:back/utils/galaxy_clock/clock/theme.dart';
import 'package:flutter/material.dart';

class ClockCircle extends StatelessWidget {
  final double diameter;

  final double strokeWidht;

  final ClockTheme theme;

  final double angleRadians;

  const ClockCircle({
    Key? key,
    required this.diameter,
    required this.strokeWidht,
    required this.theme,
    required this.angleRadians,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angleRadians,
      alignment: Alignment.center,
      child: CustomPaint(
        painter: ClockCirclePainter(
          strokeWidth: strokeWidht,
          theme: theme,
        ),
        child: SizedBox(
          height: diameter,
          width: diameter,
        ),
      ),
    );
  }
}
