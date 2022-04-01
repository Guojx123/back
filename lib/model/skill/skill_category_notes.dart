import 'package:back/category/skill/notes/stream_periodic.dart';
import 'package:back/widgets/base_widget.dart';
import 'package:back/widgets/demo_item.dart';
import 'package:flutter/material.dart';

List<DemoItem> buildNotesDemoItems(String codePath) {
  return [
    DemoItem(
      icon: Icons.data_thresholding,
      title: '流的周期性',
      subtitle: '简介',
      keyword: 'stream_periodic',
      documentationUrl: 'https://flutter.cn/',
      buildRoute: (context) =>
          BaseWidget('流的周期性', codePath + 'stream_periodic', const StreamPeriodicPage()),
    ),
  ];
}
