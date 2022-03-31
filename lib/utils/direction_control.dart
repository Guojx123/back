import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 控制屏幕方向
class DirectionControl {
  static DirectionControl? _instance;

  static DirectionControl get instance => _instance ??= DirectionControl();

  bool isLandscape = false;

  init(BuildContext context) {
    /// 判断当前屏幕方向
    isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    /// 当屏幕宽度大于360时，允许横屏
    // final bool isHugeSize = MediaQuery.of(context).size.width > 360.0;
    // if (isLandscape && isHugeSize) {
    //   setLandscape();
    // } else {
    //   setPortrait();
    // }
  }

  static void setPortrait() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  static void setLandscape() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }
}
