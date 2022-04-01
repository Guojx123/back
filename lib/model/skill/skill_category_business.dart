import 'package:back/category/skill/business/color_filter.dart';
import 'package:back/category/skill/business/input_field.dart';
import 'package:back/widgets/base_widget.dart';
import 'package:back/widgets/demo_item.dart';
import 'package:flutter/material.dart';

// 开发技巧-业务
List<DemoItem> buildBusinessDemoItems(String codePath) {
  return [
    DemoItem(
      icon: Icons.data_thresholding,
      title: '输入框',
      subtitle: '简介',
      keyword: 'placeholder',
      documentationUrl: 'https://flutter.cn/',
      buildRoute: (context) =>
          BaseWidget('输入框使用', codePath + 'input_field', const InputFieldPage()),
    ),
    DemoItem(
      icon: Icons.data_thresholding,
      title: '过滤颜色',
      subtitle: '简介',
      keyword: 'color_filter',
      documentationUrl: 'https://flutter.cn/',
      buildRoute: (context) =>
          BaseWidget('过滤颜色', codePath + 'color_filter', const ColorFilterPage()),
    ),
  ];
}
