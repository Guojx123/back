import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';

class FlipClockPage extends StatefulWidget {
  const FlipClockPage({Key? key}) : super(key: key);

  @override
  _FlipClockState createState() => _FlipClockState();
}

class _FlipClockState extends State<FlipClockPage> with WidgetsBindingObserver {
  late DateTime startTime;

  @override
  void initState() {
    super.initState();
    // 保持屏幕常亮
    Wakelock.enable();
    startTime = DateTime.now();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      setState(() {
        startTime = DateTime.now();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();

    Wakelock.disable();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Center(
      child: SizedBox(
        height: (screenSize.width / 7 - 10) * 2 + 1,
        child: FlipClock(
          startTime: startTime,
          digitColor: Colors.white,
          backgroundColor: Colors.lightGreen,
          digitSize: screenSize.width / 7,
          borderRadius: const BorderRadius.all(Radius.circular(4.0)),
          width: screenSize.width / 7 - 20,
          height: (screenSize.width / 7 - 10) * 2,
          screenWidth: screenSize.width,
          screenHeight: screenSize.width,
          timeLeft: const Duration(days: 365),
          flipDirection: FlipDirection.up,
        ),
      ),
    );
  }
}

class FlipClock extends StatelessWidget {
  late final DigitBuilder _digitBuilder;
  late final Widget _separator;
  final DateTime startTime;
  final EdgeInsets spacing;
  final FlipDirection flipDirection;

  /// 为true时，展示为倒计时
  final bool countdownMode;

  final bool _showHours;
  final bool showDays;

  late final Duration timeLeft;

  /// 当倒计时时钟达到零时调用
  final VoidCallback? onDone;

  final double height;
  final double width;

  final double screenWidth;
  final double screenHeight;

  FlipClock({
    Key? key,
    required this.startTime,
    required Color digitColor,
    required Color backgroundColor,
    required double digitSize,
    required this.width,
    required this.height,
    required this.screenWidth,
    required this.screenHeight,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(0.0)),
    this.spacing = const EdgeInsets.symmetric(horizontal: 2.0),
    this.flipDirection = FlipDirection.down,
    required this.timeLeft,
    this.countdownMode = false,
    this.showDays = false,
  })  : _showHours = true,
        onDone = null,
        super(key: key) {
    _digitBuilder = (context, digit) => Container(
          alignment: Alignment.center,
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius,
          ),
          child: Text(
            '$digit',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: digitSize, color: digitColor),
          ),
        );
    _separator = Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      width: width / 2,
      height: height,
      alignment: Alignment.center,
      child: Text(
        ':',
        style: TextStyle(
          fontSize: digitSize,
          color: digitColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var time = startTime;
    final initStream = Stream<DateTime>.periodic(const Duration(milliseconds: 1000), (_) {
      var oldTime = time;
      (countdownMode)
          ? timeLeft = timeLeft - const Duration(seconds: 1)
          : time = time.add(const Duration(seconds: 1));

      if (!countdownMode && oldTime.day != time.day) {
        time = oldTime;
        if (onDone != null) onDone!();
      }

      return time;
    });
    final timeStream =
        (countdownMode ? initStream.take(timeLeft.inSeconds) : initStream).asBroadcastStream();

    // TODO: 允许用户自定义时间格式
    var digitList = <Widget>[];

    if (showDays) {
      digitList.addAll([
        _buildSegment(
            timeStream,
            (DateTime time) => (timeLeft.inDays > 99) ? 9 : (timeLeft.inDays ~/ 10),
            (DateTime time) => (timeLeft.inDays > 99) ? 9 : (timeLeft.inDays % 10),
            startTime,
            "days"),
        Column(
          children: <Widget>[
            Padding(
              padding: spacing,
              child: _separator,
            ),
            (showDays)
                ? Container(color: Colors.black)
                : Container(
                    color: Colors.transparent,
                  )
          ],
        )
      ]);
    }

    if (_showHours) {
      digitList.addAll([
        _buildSegment(
            timeStream,
            (DateTime time) => (countdownMode) ? (timeLeft.inHours % 24) ~/ 10 : (time.hour) ~/ 10,
            (DateTime time) => (countdownMode) ? (timeLeft.inHours % 24) % 10 : (time.hour) % 10,
            startTime,
            "Hours"),
        Column(
          children: <Widget>[
            Padding(
              padding: spacing,
              child: _separator,
            ),
            (showDays)
                ? Container(color: Colors.black)
                : Container(
                    color: Colors.transparent,
                  )
          ],
        )
      ]);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: digitList
        ..addAll([
          // Minutes
          _buildSegment(
              timeStream,
              (DateTime time) =>
                  (countdownMode) ? (timeLeft.inMinutes % 60) ~/ 10 : (time.minute) ~/ 10,
              (DateTime time) =>
                  (countdownMode) ? (timeLeft.inMinutes % 60) % 10 : (time.minute) % 10,
              startTime,
              "minutes"),

          Column(
            children: <Widget>[
              Padding(
                padding: spacing,
                child: _separator,
              ),
              (showDays)
                  ? Container(color: Colors.black)
                  : Container(
                      color: Colors.transparent,
                    )
            ],
          ),

          // Seconds
          _buildSegment(
              timeStream,
              (DateTime time) =>
                  (countdownMode) ? (timeLeft.inSeconds % 60) ~/ 10 : (time.second) ~/ 10,
              (DateTime time) =>
                  (countdownMode) ? (timeLeft.inSeconds % 60) % 10 : (time.second) % 10,
              startTime,
              "seconds")
        ]),
    );
  }

  _buildSegment(
    Stream<DateTime> timeStream,
    int Function(DateTime) tensDigit,
    int Function(DateTime) onesDigit,
    DateTime startTime,
    String id,
  ) {
    return Column(
      children: <Widget>[
        Row(children: [
          Padding(
            padding: spacing,
            child: FlipPanel<int>.stream(
              itemStream: timeStream.map<int>(tensDigit),
              itemBuilder: _digitBuilder,
              duration: const Duration(milliseconds: 450),
              initValue: tensDigit(startTime),
              direction: flipDirection,
            ),
          ),
          Padding(
            padding: spacing,
            child: FlipPanel<int>.stream(
              itemStream: timeStream.map<int>(onesDigit),
              itemBuilder: _digitBuilder,
              duration: const Duration(milliseconds: 450),
              initValue: onesDigit(startTime),
              direction: flipDirection,
            ),
          ),
        ]),
        (showDays)
            ? Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            id.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            : Row()
      ],
    );
  }
}

typedef Widget DigitBuilder(BuildContext, int);

///
/// Signature for a function that creates a widget for a given index, e.g., in a list.
///
typedef Widget IndexedItemBuilder(BuildContext, int);

///
/// Signature for a function that creates a widget for a value emitted from a [Stream]
///
typedef Widget StreamItemBuilder<T>(BuildContext, T);

///
/// An enum defines all supported directions of [FlipPanel]
///
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

  ///
  /// Create a flip panel from iterable source
  ///
  /// * [itemBuilder] is called periodically in each time of [period]
  /// * The animation is looped in [loop] times before finished.
  /// Setting [loop] to -1 makes flip animation run forever.
  /// * The [period] should be two times greater than [duration] of flip animation,
  /// otherwise the animation becomes jerky/stuttery.
  ///
  const FlipPanel.builder({
    Key? key,
    required IndexedItemBuilder itemBuilder,
    required this.itemsCount,
    required this.period,
    this.duration = const Duration(milliseconds: 500),
    this.loop = 1,
    this.startIndex = 0,
    this.spacing = 0.5,
    this.direction = FlipDirection.down,
  })  : indexedItemBuilder = itemBuilder,
        streamItemBuilder = null,
        itemStream = null,
        initValue = null,
        super(key: key);

  ///
  /// Create a flip panel from stream source
  ///
  /// * [itemBuilder] is called whenever a new value is emitted from [itemStream]
  ///
  const FlipPanel.stream({
    Key? key,
    required this.itemStream,
    required StreamItemBuilder<T> itemBuilder,
    this.initValue,
    this.duration = const Duration(milliseconds: 500),
    this.spacing = 0.5,
    this.direction = FlipDirection.down,
  })  : assert(itemStream != null),
        indexedItemBuilder = null,
        streamItemBuilder = itemBuilder,
        itemsCount = 1,
        period = const Duration(),
        loop = 0,
        startIndex = 0,
        super(key: key);

  @override
  _FlipPanelState<T> createState() => _FlipPanelState<T>();
}

class _FlipPanelState<T> extends State<FlipPanel> with SingleTickerProviderStateMixin {
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
    if (_subscription != null) _subscription?.cancel();
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
        if (_child2 != null) {
          _child1 = _child2;
        } else {
          _child1 = _isStreamMode
              ? widget.streamItemBuilder!(context, _currentValue)
              : widget.indexedItemBuilder!(context, _currentIndex % widget.itemsCount);
        }
        _child2 = null;
        _upperChild1 = _upperChild2 ?? makeUpperClip(_child1);
        _lowerChild1 = _lowerChild2 ?? makeLowerClip(_child1);
      }
      if (_child2 == null) {
        _child2 = _isStreamMode
            ? widget.streamItemBuilder!(context, _nextValue)
            : widget.indexedItemBuilder!(context, (_currentIndex + 1) % widget.itemsCount);
        _upperChild2 = makeUpperClip(_child2);
        _lowerChild2 = makeLowerClip(_child2);
      }
    } else {
      if (_child2 != null) {
        _child1 = _child2;
      } else {
        _child1 = _isStreamMode
            ? widget.streamItemBuilder!(context, _currentValue)
            : widget.indexedItemBuilder!(context, _currentIndex % widget.itemsCount);
      }
      _upperChild1 = _upperChild2 ?? makeUpperClip(_child1);
      _lowerChild1 = _lowerChild2 ?? makeLowerClip(_child1);
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
                      child: _lowerChild1)
                ],
              );
  }
}
