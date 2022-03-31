import 'package:back/utils/clock/model.dart';
import 'package:back/utils/direction_control.dart';
import 'package:back/utils/lava_clock/custom_customizer.dart';
import 'package:back/utils/lava_clock/frame.dart';
import 'package:back/utils/lava_clock/lava_clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LavaClockPage extends StatefulWidget {
  const LavaClockPage({Key? key}) : super(key: key);

  @override
  State<LavaClockPage> createState() => _LavaClockPageState();
}

class _LavaClockPageState extends State<LavaClockPage> {
  @override
  void initState() {
    super.initState();
    // 设置横屏
    DirectionControl.setLandscape();
    // 隐藏系统状态栏、底部导航栏
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  @override
  Widget build(BuildContext context) {
    return CustomClockCustomizer(
      (ClockModel model) => ClockFrame(
        child: (controller) => LavaClock(model, animationController: controller),
      ),
    );
  }
}
