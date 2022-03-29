import 'package:back/Widgets/base_widget.dart';
import 'package:back/category/skill/notes/input_field.dart';
import 'package:back/widgets/demo_item.dart';
import 'package:flutter/material.dart';

List<DemoItem> buildDesignNotesCreateDemoItems(String codePath) {
  return [
    DemoItem(
      icon: Icons.data_thresholding,
      title: '输入框',
      subtitle: '简介',
      keyword: 'placeholder',
      documentationUrl: 'https://flutter.cn/',
      buildRoute: (context) => BaseWidget('输入框使用', codePath + 'input_field', const InputField()),
    ),
  ];
}
