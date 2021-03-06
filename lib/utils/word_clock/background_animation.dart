import 'dart:math';

import 'package:flutter/material.dart';

import 'constants.dart';

/// Show random connected nodes animation in background
class BackgroundAnimation extends StatefulWidget {
  const BackgroundAnimation({Key? key}) : super(key: key);

  @override
  _BackgroundAnimationState createState() => _BackgroundAnimationState();
}

const total = 22;

class _BackgroundAnimationState extends State<BackgroundAnimation> with TickerProviderStateMixin {
  late List<Animation<Offset>> animations;
  late List<AnimationController> controllers;
  final Random random = Random();

  @override
  void initState() {
    controllers = List.generate(total, (i) {
      return AnimationController(
          vsync: this, duration: Duration(seconds: 15, milliseconds: random.nextInt(5000)));
    });

    animations = List.generate(total, (i) {
      var tween = Tween<Offset>(
          begin: Offset(random.nextDouble(), random.nextDouble()),
          end: Offset(random.nextDouble(), random.nextDouble()));
      var a = tween.animate(controllers[i]);
      a
        ..addListener(() {
          setState(() {});
        })
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            tween.begin = tween.end;
            controllers[i].reset();
            tween.end = Offset(random.nextDouble(), random.nextDouble());
            controllers[i].forward();
          }
        });
      return a;
    });

    for (var c in controllers) {
      c.forward();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BackgroundPainter(
        animations,
        Theme.of(context).brightness == Brightness.light
            ? Constants.backgroudPatternBlue
            : Constants.backgroudPatternBlueDark,
        Theme.of(context).brightness == Brightness.light
            ? Constants.backgroudCirclePatternBlue
            : Constants.backgroudCirclePatternBlue,
      ),
    );
  }

  @override
  void dispose() {
    controllers.forEach((f) => f.dispose());
    super.dispose();
  }
}

class BackgroundPainter extends CustomPainter {
  final Paint paintLine;
  final Paint paintCircle;
  List<Animation<Offset>> points;

  BackgroundPainter(this.points, Color line, Color circle)
      : paintLine = Paint()
          ..color = line
          ..isAntiAlias = true
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..strokeWidth = 6,
        paintCircle = Paint()
          ..color = circle
          ..isAntiAlias = true
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..strokeWidth = 6,
        super();

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length; i++) {
      canvas.drawCircle(getOffset(points[i], size), 10, paintCircle);
    }

    for (int i = 3; i < points.length; i += 3) {
      canvas.drawLine(getOffset(points[i - 3], size), getOffset(points[i], size), paintLine);
      canvas.drawLine(getOffset(points[i - 2], size), getOffset(points[i], size), paintLine);
      canvas.drawLine(getOffset(points[i - 1], size), getOffset(points[i], size), paintLine);
    }
  }

  Offset getOffset(Animation<Offset> offset, Size size) =>
      Offset(offset.value.dx * size.width, offset.value.dy * size.height);

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
