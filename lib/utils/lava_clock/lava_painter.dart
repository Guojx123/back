import 'dart:math';

import 'package:flutter/material.dart';

import 'ball.dart';

class LavaPainter extends CustomPainter {
  final Lava lava;
  final Color color;

  LavaPainter(this.lava, {required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (lava.size != size) lava.updateSize(size);
    lava.draw(canvas, size, color, debug: false);
  }

  @override
  bool shouldRepaint(LavaPainter lavaPainter) {
    return true;
  }
}

class Lava {
  num step = 5;
  Size size = const Size(0, 0);

  double get width => size.width;

  double get height => size.height;

  late Rect sRect;

  double get sx => (width ~/ step).floor().toDouble();

  double get sy => (height ~/ step).floor().toDouble();

  bool _paint = false;
  double item = 0;
  int sign = 1;

  late Map<int, Map<int, ForcePoint<double>>> matrix;

  late List<Ball> balls;
  int ballsLength;

  Lava(this.ballsLength);

  updateSize(Size size) {
    this.size = size;
    sRect = Rect.fromCenter(center: Offset.zero, width: sx.toDouble(), height: sy.toDouble());

    matrix = {};
    debugPrint('Gino sx:' + sx.toString());
    try {
      for (int i = (sRect.left - step).toInt(); i < sRect.right + step; i++) {
        matrix[i] = {};
        for (int j = (sRect.top - step).toInt(); j < sRect.bottom + step; j++) {
          matrix[i]![j] =
              ForcePoint((i + sx ~/ 2).toDouble() * step, (j + sy ~/ 2).toDouble() * step);
        }
      }
      balls = List.filled(ballsLength, Ball(const Size(0, 0)));
      for (var index = 0; ballsLength > index; index++) {
        balls[index] = Ball(size);
      }
    } catch (e, s) {
      debugPrint('ball error :$e, $s');
    }
  }

  double computeForce(int sx, int sy) {
    num force;
    if (!sRect.contains(Offset(sx.toDouble(), sy.toDouble()))) {
      force = .6 * sign;
    } else {
      force = 0;
      final point = matrix[sx]![sy];

      try {
        for (final ball in balls) {
          force += ball.width *
              ball.width /
              (-2 * point!.x * ball.pos.x -
                  2 * point.y * ball.pos.y +
                  ball.pos.magnitude +
                  point.magnitude);
        }
      } catch (e, s) {
        debugPrint('ball force error :$e, $s');
      }
      force *= sign;
    }

    matrix[sx]?[sy]?.force = force.toDouble();
    return force.toDouble();
  }

  final List<int> plx = [0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0, 0];
  final List<int> ply = [0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 1, 0, 1, 0, 1];
  final List<int> mscases = [0, 3, 0, 3, 1, 3, 0, 3, 2, 2, 0, 2, 1, 1, 0];
  final ix = [1, 0, -1, 0, 0, 1, 0, -1, -1, 0, 1, 0, 0, 1, 1, 0, 0, 0, 1, 1];

  List? marchingSquares(List params, Path path) {
    int sx = params[0];
    int sy = params[1];
    int? pdir = params[2];

    if (matrix[sx]?[sy]?.computed == item) return [];

    int dir, mscase = 0;
    for (var a = 0; 4 > a; a++) {
      final dx = ix[a + 12];
      final dy = ix[a + 16];
      double? force = matrix[sx + dx]?[sy + dy]?.force;
      if (force == null || force == 0 || force > 0 && sign < 0 || force < 0 && sign > 0) {
        force = computeForce(sx + dx, sy + dy);
      }
      if (force.abs() > 1) mscase += pow(2, a).toInt();
    }

    if (15 == mscase) {
      return [sx, sy - 1, null];
    } else if (5 == mscase) {
      dir = 2 == pdir ? 3 : 1;
    } else if (10 == mscase) {
      dir = 3 == pdir ? 0 : 2;
    } else {
      dir = mscases[mscase];
      matrix[sx]![sy]!.computed = item;
    }

    final dx1 = plx[4 * dir + 2];
    final dy1 = ply[4 * dir + 2];
    final pForce1 = matrix[sx + dx1]![sy + dy1]!.force;

    final dx2 = plx[4 * dir + 3];
    final dy2 = ply[4 * dir + 3];
    final pForce2 = matrix[sx + dx2]![sy + dy2]!.force;
    final p = step / ((pForce1.abs() - 1).abs() / (pForce2.abs() - 1).abs() + 1.0);

    final dxX = plx[4 * dir];
    final dyX = ply[4 * dir];
    final dxY = plx[4 * dir + 1];
    final dyY = ply[4 * dir + 1];

    final lineX = matrix[sx + dxX]![sy + dyX]!.x + ix[dir] * p;
    final lineY = matrix[sx + dxY]![sy + dyY]!.y + ix[dir + 4] * p;

    if (_paint == false) {
      path.moveTo(lineX, lineY);
    } else {
      path.lineTo(lineX, lineY);
    }
    _paint = true;
    return [sx + ix[dir + 4], sy + ix[dir + 8], dir];
  }

  draw(Canvas canvas, Size size, Color color, {bool debug = false}) {
    for (Ball ball in balls) {
      ball.moveIn(size);
    }

    try {
      item++;
      sign = -sign;
      _paint = true;

      for (Ball ball in balls) {
        Path path = Path();
        List params = [
          (ball.pos.x / step - sx / 2).round(),
          (ball.pos.y / step - sy / 2).round(),
          0,
        ];
        params = marchingSquares(params, path) ?? [];
        if (_paint) {
          path.close();

          Paint paint = Paint()..color = color;

          canvas.drawPath(path, paint);

          _paint = false;
        }
      }
    } catch (e, s) {
      debugPrint('ball draw error :$e, $s');
    }

    if (debug) {
      for (var ball in balls) {
        canvas.drawCircle(Offset(ball.pos.x.toDouble(), ball.pos.y.toDouble()), ball.width,
            Paint()..color = Colors.black.withOpacity(0.5));
      }

      matrix.forEach((_, item) => item.forEach((_, point) => canvas.drawCircle(
          Offset(point.x.toDouble(), point.y.toDouble()),
          max(1, min(point.force.abs(), 5)),
          Paint()..color = point.force > 0 ? Colors.blue : Colors.red)));
    }
  }
}
