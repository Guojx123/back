import 'package:back/widgets/base_widget.dart';
import 'package:back/widgets/demo_item.dart';
import 'package:flutter/material.dart';

List<DemoItem> buildDesignNotesCreateDemoItems(String codePath) {
  return [
    DemoItem(
      icon: Icons.data_thresholding,
      title: '自定义路由动画',
      subtitle: '简介',
      keyword: 'route_animation',
      documentationUrl: 'https://flutter.cn/',
      buildRoute: (context) => BaseWidget(
        '自定义路由动画',
        codePath + 'custom_routing_animation',
        Container(),
        isMarkDown: true,
      ),
    ),
  ];
}
