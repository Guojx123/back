import 'package:back/utils/clock/customizer.dart';
import 'package:back/utils/clock/model.dart';
import 'package:back/utils/galaxy_clock/clock/galaxy_clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GalaxyClockPage extends StatefulWidget {
  const GalaxyClockPage({Key? key}) : super(key: key);

  @override
  State<GalaxyClockPage> createState() => _GalaxyClockPageState();
}

class _GalaxyClockPageState extends State<GalaxyClockPage> {
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
      (ClockModel model) => GalaxyClock(model),
    );
  }
}
