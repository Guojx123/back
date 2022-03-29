import 'package:back/Category/Study/config/config.dart';
import 'package:back/Widgets/base_widget.dart';
import 'package:back/Widgets/demo_item.dart';
import 'package:flutter/material.dart';

List<DemoItem> buildEnvironmentDemoItems(String codePath) {
  return [
    DemoItem(
      icon: Icons.important_devices,
      title: 'Flutter学习框架',
      subtitle: '简介',
      keyword: 'flutter',
      documentationUrl: 'https://flutter.cn/',
      buildRoute: (context) => BaseWidget(
        'Flutter学习框架',
        codePath + 'app',
        ConfigPage(),
        isMarkDown: true,
      ),
    ),
  ];
}
