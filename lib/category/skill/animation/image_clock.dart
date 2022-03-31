import 'package:back/utils/word_clock/src/customizer.dart';
import 'package:back/utils/word_clock/src/image_clock.dart';
import 'package:back/utils/word_clock/src/model.dart';
import 'package:flutter/material.dart';

class ImageClockPage extends StatefulWidget {
  const ImageClockPage({Key? key}) : super(key: key);

  @override
  State<ImageClockPage> createState() => _ImageClockPageState();
}

class _ImageClockPageState extends State<ImageClockPage> {
  @override
  Widget build(BuildContext context) {
    return ClockCustomizer((ClockModel model) => ImageClock(model));
  }
}
