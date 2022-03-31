import 'dart:io';

import 'package:back/Pages/easeImport.dart';
import 'package:back/Widgets/notfound.dart';
import 'package:back/pages/widget/providercategory.dart';
import 'package:back/utils/navigatormanager.dart';
import 'package:back/utils/sp_util.dart';
import 'package:back/utils/word_clock/src/time_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() => realRunApp();

void realRunApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 竖屏
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  init().then((_) {
    runApp(
      MultiProvider(
        providers: [
          Provider(create: (_) => 1008),
          ChangeNotifierProvider(create: (_) => ChangeNotifyModel()),
          ChangeNotifierProvider(create: (_) => SelectorModel()),
          ChangeNotifierProvider(create: (_) => TimeModel())
        ],
        child: MyApp(),
      ),
    );
  });
}

/// 初始化
Future init() async {
  await SpUtil.preInit();
}

SystemUiOverlayStyle setNavigationBarTextColor(bool light) {
  return SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black,
    systemNavigationBarDividerColor: null,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarColor: null,
    statusBarIconBrightness: light ? Brightness.light : Brightness.dark,
    statusBarBrightness: light ? Brightness.dark : Brightness.light,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      // 在组件渲染之后，再覆写状态栏颜色
      // 如果使用了APPBar，则需要修改brightness属性
      SystemUiOverlayStyle systemUiOverlayStyle =
          const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
    return GetMaterialApp(
      home: MaterialApp(
        title: 'Back',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: MyHomePage(title: 'Back'),
        onUnknownRoute: (RouteSettings setting) {
          return MaterialPageRoute(builder: (context) => NotFoundWidget());
        },
        navigatorKey: RouteManager.navigatorKey,
        navigatorObservers: [NavigatorManager.getInstance()],
      ),
    );
  }
}
