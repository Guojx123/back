library animated_floatactionbuttons;

import 'package:back/Utils/animated_floatactionbuttons-0.1.0/transform_float_button.dart';
import 'package:flutter/material.dart';

class AnimatedFloatingActionButton extends StatefulWidget {
  final List<Widget> fabButtons;
  final Color colorStartAnimation;
  final Color colorEndAnimation;
  final AnimatedIconData animatedIconData;

  const AnimatedFloatingActionButton(
      {Key? key,
      required this.fabButtons,
      required this.colorStartAnimation,
      required this.colorEndAnimation,
      required this.animatedIconData})
      : super(key: key);

  @override
  _AnimatedFloatingActionButtonState createState() => _AnimatedFloatingActionButtonState();
}

class _AnimatedFloatingActionButtonState extends State<AnimatedFloatingActionButton>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  late AnimationController _animationController;
  Animation<Color>? _buttonColor;
  late Animation<double> _animateIcon;
  late Animation<double> _translateButton;
  final Curve _curve = Curves.easeOut;
  final double _fabHeight = 56.0;

  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget toggle() {
    return FloatingActionButton(
      backgroundColor: _buttonColor?.value,
      onPressed: animate,
      tooltip: '切换',
      child: AnimatedIcon(
        icon: widget.animatedIconData,
        progress: _animateIcon,
      ),
    );
  }

  List<Widget> _setFabButtons() {
    List<Widget> processButtons = [];
    for (int i = 0; i < widget.fabButtons.length; i++) {
      processButtons.add(TransformFloatButton(
        floatButton: widget.fabButtons[i],
        translateValue: _translateButton.value * (widget.fabButtons.length - i),
      ));
    }
    processButtons.add(toggle());
    return processButtons;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: _setFabButtons(),
    );
  }
}
