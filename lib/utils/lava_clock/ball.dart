import 'dart:math';
import 'dart:ui';

class ForcePoint<T extends num> {
  T x, y;

  num get magnitude => x * x + y * y;

  ForcePoint(this.x, this.y);

  double computed = 0;
  double force = 0;

  ForcePoint add(ForcePoint<T> point) => ForcePoint(point.x + x, point.y + y);

  ForcePoint copyWith({T? x, T? y}) => ForcePoint(x ?? this.x, y ?? this.y);
}

class Ball {
  late ForcePoint velocity;
  late ForcePoint pos;
  late double width;

  Ball(Size size) {
    double vel({double ratio = 1}) =>
        (Random().nextDouble() > .5 ? 1 : -1) * (.2 + .25 * Random().nextDouble());
    velocity = ForcePoint(vel(ratio: 0.25), vel());

    var i = .1;
    var h = 1.5;

    double calculatePosition(double fullSize) => Random().nextDouble() * fullSize;
    pos = ForcePoint(calculatePosition(size.width), calculatePosition(size.height));

    width =
        size.shortestSide / 15 + (Random().nextDouble() * (h - i) + i) * (size.shortestSide / 15);
  }

  moveIn(Size size) {
    if (pos.x >= size.width - width) {
      if (pos.x > 0) velocity.x = -velocity.x;
      pos = pos.copyWith(x: size.width - width);
    } else if (pos.x <= width) {
      if (velocity.x < 0) velocity.x = -velocity.x;
      pos.x = width;
    }
    if (pos.y >= size.height - width) {
      if (velocity.y > 0) velocity.y = -velocity.y;
      pos.y = size.height - width;
    } else if (pos.y <= width) {
      if (velocity.y < 0) velocity.y = -velocity.y;
      pos.y = width;
    }
    pos = pos.add(velocity);
  }
}
