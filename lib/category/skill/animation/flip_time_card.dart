import 'dart:async';
import 'dart:math';

import 'package:back/widgets/title_widget.dart';
import 'package:flutter/material.dart';

class FlipTimeCard extends StatefulWidget {
  const FlipTimeCard({Key? key}) : super(key: key);

  @override
  _FlipTimeCardState createState() => _FlipTimeCardState();
}

class _FlipTimeCardState extends State<FlipTimeCard> {
  @override
  Widget build(BuildContext context) {
    return SimpleWidget();
  }
}

class SimpleWidget extends StatelessWidget {
  final digits = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
  var count = 0;

  SimpleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          TitleWidget('根据列表创建'),
          FlipPanel.builder(
            itemBuilder: (context, index) => Container(
              alignment: Alignment.center,
              width: 96.0,
              height: 128.0,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              child: Text(
                '${digits[index]}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 80.0,
                  color: Colors.yellow,
                ),
              ),
            ),
            itemsCount: digits.length,
            period: const Duration(milliseconds: 1000),
            loop: -1,
          ),
          TitleWidget('通过流创建'),
          FlipPanel.stream(
            initValue: count,
            itemsCount: digits.length,
            itemStream: Stream.periodic(
              const Duration(milliseconds: 1000),
              (_) => ++count,
            ),
            itemBuilder: (context, index) => Container(
              alignment: Alignment.center,
              width: 96.0,
              height: 128.0,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              child: Text(
                '$count',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 80.0,
                  color: Colors.yellow,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Signature for a function that creates a widget for a given index, e.g., in a
/// list.
typedef Widget IndexedItemBuilder(buildContext, int);

/// Signature for a function that creates a widget for a value emitted from a [Stream]
typedef Widget StreamItemBuilder<T>(buildContext, T);

/// A widget for flip panel with built-in animation
/// Content of the panel is built from [IndexedItemBuilder] or [StreamItemBuilder]
///
/// Note: the content size should be equal
enum FlipDirection { up, down }

class FlipPanel<T> extends StatefulWidget {
  final IndexedItemBuilder? indexedItemBuilder;
  final StreamItemBuilder<T>? streamItemBuilder;
  final Stream<T>? itemStream;
  final int itemsCount;
  final Duration period;
  final Duration? duration;
  final int loop;
  final int startIndex;
  final T? initValue;
  final double spacing;
  final FlipDirection? direction;

  const FlipPanel({
    Key? key,
    this.indexedItemBuilder,
    this.streamItemBuilder,
    this.itemStream,
    required this.itemsCount,
    required this.period,
    this.duration,
    required this.loop,
    required this.startIndex,
    this.initValue,
    required this.spacing,
    this.direction,
  }) : super(key: key);

  /// Create a flip panel from iterable source
  /// [itemBuilder] is called periodically in each time of [period]
  /// The animation is looped in [loop] times before finished.
  /// Setting [loop] to -1 makes flip animation run forever.
  /// The [period] should be two times greater than [duration] of flip animation,
  /// if not the animation becomes jerky/stuttery.
  const FlipPanel.builder({
    Key? key,
    required IndexedItemBuilder itemBuilder,
    required this.itemsCount,
    required this.period,
    this.duration = const Duration(milliseconds: 500),
    this.loop = 1,
    this.startIndex = 0,
    this.spacing = 0.5,
    this.direction = FlipDirection.up,
  })  : indexedItemBuilder = itemBuilder,
        streamItemBuilder = null,
        itemStream = null,
        initValue = null,
        super(key: key);

  /// Create a flip panel from stream source
  /// [itemBuilder] is called whenever a  value is emitted from [itemStream]
  const FlipPanel.stream({
    Key? key,
    required this.itemStream,
    required StreamItemBuilder<T> itemBuilder,
    this.initValue,
    this.duration = const Duration(milliseconds: 500),
    this.spacing = 0.5,
    this.direction = FlipDirection.up,
    required this.itemsCount,
  })  : indexedItemBuilder = null,
        streamItemBuilder = itemBuilder,
        period = const Duration(),
        loop = 0,
        startIndex = 0,
        super(key: key);

  @override
  _FlipPanelState<T> createState() => _FlipPanelState<T>();
}

class _FlipPanelState<T> extends State<FlipPanel> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  late int _currentIndex;
  late bool _isReversePhase;
  late bool _isStreamMode;
  late bool _running;
  final _perspective = 0.003;
  // There's something wrong in the perspective transform,
  // I use a very small value instead of zero to temporarily get it around.
  final _zeroAngle = 0.0001;
  late int _loop;
  T? _currentValue, _nextValue;
  late Timer _timer;
  StreamSubscription<dynamic>? _subscription;

  Widget? _child1, _child2;
  Widget? _upperChild1, _upperChild2;
  Widget? _lowerChild1, _lowerChild2;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.startIndex;
    _isStreamMode = widget.itemStream != null;
    _isReversePhase = false;
    _running = false;
    _loop = 0;

    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _isReversePhase = true;
          _controller.reverse();
        }
        if (status == AnimationStatus.dismissed) {
          _currentValue = _nextValue;
          _running = false;
        }
      })
      ..addListener(() {
        setState(() {
          _running = true;
        });
      });
    _animation = Tween(begin: _zeroAngle, end: pi / 2).animate(_controller);

    _timer = Timer.periodic(widget.period, (_) {
      if (widget.loop < 0 || _loop < widget.loop) {
        if (_currentIndex + 1 == widget.itemsCount - 2) {
          _loop++;
        }
        _currentIndex = (_currentIndex + 1) % widget.itemsCount;
        _child1 = null;
        _isReversePhase = false;
        _controller.forward();
      } else {
        _timer.cancel();
        _currentIndex = (_currentIndex + 1) % widget.itemsCount;
        setState(() {
          _running = false;
        });
      }
    });

    if (_isStreamMode) {
      _currentValue = widget.initValue;
      _subscription = widget.itemStream!.distinct().listen((value) {
        if (_currentValue == null) {
          _currentValue = value;
        } else if (value != _currentValue) {
          _nextValue = value;
          _child1 = null;
          _isReversePhase = false;
          _controller.forward();
        }
      });
    } else if (widget.loop < 0 || _loop < widget.loop) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _subscription?.cancel();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _buildChildWidgetsIfNeed(context);

    return _buildPanel();
  }

  void _buildChildWidgetsIfNeed(BuildContext context) {
    Widget makeUpperClip(Widget? widget) {
      return ClipRect(
        child: Align(
          alignment: Alignment.topCenter,
          heightFactor: 0.5,
          child: widget,
        ),
      );
    }

    Widget makeLowerClip(Widget? widget) {
      return ClipRect(
        child: Align(
          alignment: Alignment.bottomCenter,
          heightFactor: 0.5,
          child: widget,
        ),
      );
    }

    if (_running) {
      if (_child1 == null) {
        _child1 = _child2 != null
            ? _child2
            : _isStreamMode
                ? widget.streamItemBuilder!(context, _currentValue)
                : widget.indexedItemBuilder!(context, _currentIndex % widget.itemsCount);
        _child2 = null;
        _upperChild1 = _upperChild2 != null ? _upperChild2 : makeUpperClip(_child1);
        _lowerChild1 = _lowerChild2 != null ? _lowerChild2 : makeLowerClip(_child1);
      }
      if (_child2 == null) {
        _child2 = _isStreamMode
            ? widget.streamItemBuilder!(context, _nextValue)
            : widget.indexedItemBuilder!(context, (_currentIndex + 1) % widget.itemsCount);
        _upperChild2 = makeUpperClip(_child2);
        _lowerChild2 = makeLowerClip(_child2);
      }
    } else {
      _child1 = _child2 != null
          ? _child2
          : _isStreamMode
              ? widget.streamItemBuilder!(context, _currentValue)
              : widget.indexedItemBuilder!(context, _currentIndex % widget.itemsCount);
      _upperChild1 = _upperChild2 != null ? _upperChild2 : makeUpperClip(_child1);
      _lowerChild1 = _lowerChild2 != null ? _lowerChild2 : makeLowerClip(_child1);
    }
  }

  Widget _buildUpperFlipPanel() => widget.direction == FlipDirection.up
      ? Stack(
          children: [
            Transform(
                alignment: Alignment.bottomCenter,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, _perspective)
                  ..rotateX(_zeroAngle),
                child: _upperChild1),
            Transform(
              alignment: Alignment.bottomCenter,
              transform: Matrix4.identity()
                ..setEntry(3, 2, _perspective)
                ..rotateX(_isReversePhase ? _animation.value : pi / 2),
              child: _upperChild2,
            ),
          ],
        )
      : Stack(
          children: [
            Transform(
                alignment: Alignment.bottomCenter,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, _perspective)
                  ..rotateX(_zeroAngle),
                child: _upperChild2),
            Transform(
              alignment: Alignment.bottomCenter,
              transform: Matrix4.identity()
                ..setEntry(3, 2, _perspective)
                ..rotateX(_isReversePhase ? pi / 2 : _animation.value),
              child: _upperChild1,
            ),
          ],
        );

  Widget _buildLowerFlipPanel() => widget.direction == FlipDirection.up
      ? Stack(
          children: [
            Transform(
                alignment: Alignment.topCenter,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, _perspective)
                  ..rotateX(_zeroAngle),
                child: _lowerChild2),
            Transform(
              alignment: Alignment.topCenter,
              transform: Matrix4.identity()
                ..setEntry(3, 2, _perspective)
                ..rotateX(_isReversePhase ? pi / 2 : -_animation.value),
              child: _lowerChild1,
            )
          ],
        )
      : Stack(
          children: [
            Transform(
                alignment: Alignment.topCenter,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, _perspective)
                  ..rotateX(_zeroAngle),
                child: _lowerChild1),
            Transform(
              alignment: Alignment.topCenter,
              transform: Matrix4.identity()
                ..setEntry(3, 2, _perspective)
                ..rotateX(_isReversePhase ? -_animation.value : pi / 2),
              child: _lowerChild2,
            )
          ],
        );

  Widget _buildPanel() {
    return _running
        ? Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildUpperFlipPanel(),
              Padding(
                padding: EdgeInsets.only(top: widget.spacing),
              ),
              _buildLowerFlipPanel(),
            ],
          )
        : _isStreamMode && _currentValue == null
            ? Container()
            : Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Transform(
                      alignment: Alignment.bottomCenter,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, _perspective)
                        ..rotateX(_zeroAngle),
                      child: _upperChild1),
                  Padding(
                    padding: EdgeInsets.only(top: widget.spacing),
                  ),
                  Transform(
                    alignment: Alignment.topCenter,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, _perspective)
                      ..rotateX(_zeroAngle),
                    child: _lowerChild1,
                  )
                ],
              );
  }
}
