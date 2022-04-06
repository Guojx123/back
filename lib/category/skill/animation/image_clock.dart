import 'package:back/utils/clock/customizer.dart';
import 'package:back/utils/clock/model.dart';
import 'package:back/utils/word_clock/image_clock_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImageClockPage extends StatefulWidget {
  const ImageClockPage({Key? key}) : super(key: key);

  @override
  State<ImageClockPage> createState() => _ImageClockPageState();
}

class _ImageClockPageState extends State<ImageClockPage> {
  @override
  void initState() {
    super.initState();
    // 设置横屏
    // DirectionControl.setLandscape();
    // 隐藏系统状态栏、底部导航栏
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  @override
  Widget build(BuildContext context) {
    return ClockCustomizer(
      (ClockModel model) => ImageClock(model),
    );
  }
}
