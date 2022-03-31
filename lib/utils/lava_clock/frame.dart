import 'package:flutter/material.dart';

import 'lava_clock.dart';

class ClockFrame extends StatefulWidget {
  final Function(AnimationController controller) child;
  final AnimationController? animationController;

  const ClockFrame({Key? key, required this.child, this.animationController}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ClockFrameState();
}

class _ClockFrameState extends State<ClockFrame> with TickerProviderStateMixin {
  late AnimationController _animation;

  TweenSequence<Color?> tweenColors = TweenSequence(colorList
      .asMap()
      .map(
        (index, color) => MapEntry(
          index,
          TweenSequenceItem(
            weight: 1.0,
            tween: ColorTween(
              begin: color,
              end: colorList[index + 1 < colorList.length ? index + 1 : 0],
            ),
          ),
        ),
      )
      .values
      .toList());

  @override
  void initState() {
    _animation = widget.animationController ??
        AnimationController(duration: const Duration(minutes: 5), vsync: this);
    _animation.repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        final color = tweenColors.evaluate(AlwaysStoppedAnimation(_animation.value));
        return Scaffold(
          backgroundColor: color,
          body: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 100),
              child: Center(
                child: AspectRatio(
                  aspectRatio: 5 / 3,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final borderRadius = constraints.biggest.width * 0.09;
                      final borderWidth = constraints.biggest.width * 0.03;
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(borderRadius),
                          border: Border.all(
                              width: borderWidth, color: Colors.black87, style: BorderStyle.solid),
                        ),
                        child: ClipRRect(
                          child: widget.child(_animation),
                          borderRadius: BorderRadius.circular(borderRadius - borderWidth),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
