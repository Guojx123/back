import 'dart:async';

import 'package:back/utils/clock/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'lava_painter.dart';

List<Color> colorList = [
  const Color(0xFFDB7093),
  const Color(0xFF4169E1),
  const Color(0xFFFFA07A),
  const Color(0xFFBA55D3),
  const Color(0xFF48D1CC),
  const Color(0xFF808000),
  const Color(0xFF8FBC8F),
  const Color(0xFFBA55D3),
  const Color(0xffff5858)
];

/// Lava clock.
class LavaClock extends StatefulWidget {
  final AnimationController? animationController;
  const LavaClock(this.model, {Key? key, this.animationController}) : super(key: key);

  final ClockModel model;

  @override
  _LavaClockState createState() => _LavaClockState();
}

class _LavaClockState extends State<LavaClock> with TickerProviderStateMixin {
  DateTime _dateTime = DateTime.now();
  Lava lava = Lava(6);
  Timer? _timer;
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
    super.initState();
    _animation = widget.animationController ??
        AnimationController(duration: const Duration(minutes: 5), vsync: this);
    _animation.repeat();

    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(LavaClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
        const Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black;
    final hour = DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final defaultStyle = TextStyle(
      color: Colors.white,
      fontFamily: 'Rubik',
      shadows: [
        Shadow(
          blurRadius: 120,
          color: Colors.black.withOpacity(0.1),
          offset: const Offset(0, 0),
        ),
        Shadow(
          blurRadius: 60,
          color: Colors.black.withOpacity(0.2),
          offset: const Offset(0, 0),
        ),
      ],
    );

    return Semantics(
        label: '$hour $minute',
        value: '$hour $minute',
        readOnly: true,
        child: ExcludeSemantics(
            child: LayoutBuilder(
                builder: (context, constraints) => AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      color: backgroundColor,
                      child: AnimatedBuilder(
                          animation: _animation,
                          builder: (BuildContext context, Widget? child) {
                            final color =
                                tweenColors.evaluate(AlwaysStoppedAnimation(_animation.value));
                            return Container(
                              color: color?.withOpacity(0.4),
                              child: CustomPaint(
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        hour,
                                        style: defaultStyle.copyWith(
                                            fontSize: constraints.maxWidth / 4),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            20, 0, 20, constraints.maxWidth / 20),
                                        child: Text(
                                          ':',
                                          style: defaultStyle.copyWith(
                                              fontSize: constraints.maxWidth / 4),
                                        ),
                                      ),
                                      Text(
                                        minute,
                                        style: defaultStyle.copyWith(
                                            fontSize: constraints.maxWidth / 4),
                                      ),
                                    ],
                                  ),
                                ),
                                painter: LavaPainter(lava, color: color ?? Colors.black),
                              ),
                            );
                          }),
                    ))));
  }
}
