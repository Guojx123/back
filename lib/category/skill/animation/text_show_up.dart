import 'package:back/widgets/title_widget.dart';
import 'package:flutter/material.dart';

class TextShowUp extends StatefulWidget {
  const TextShowUp({Key? key}) : super(key: key);

  @override
  _TextShowUpState createState() => _TextShowUpState();
}

class _TextShowUpState extends State<TextShowUp> with SingleTickerProviderStateMixin {
  late Animation animation;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.fastOutSlowIn,
    );
    animation.addListener(() => setState(() {}));
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TitleWidget('手动显示'),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
          child: Opacity(
            opacity: animation.value,
            child: Transform(
              transform: Matrix4.translationValues(0.0, animation.value * -50.0, 0.0),
              child: const Text(
                'Creates insets with symmetrical vertical and horizontal offsets.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
        ),
        ElevatedButton(
          child: const Text('Show'),
          onPressed: showUp,
        ),
      ],
    );
  }

  void showUp() {
    setState(() {
      animationController.reset();
      animationController.forward();
    });
  }
}
