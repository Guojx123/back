import 'package:back/category/skill/animation/flip_clock.dart';
import 'package:back/category/skill/animation/flip_time_card.dart';
import 'package:back/category/skill/animation/image_clock.dart';
import 'package:back/category/skill/animation/text_show_up.dart';
import 'package:back/widgets/base_widget.dart';
import 'package:back/widgets/demo_item.dart';
import 'package:flutter/material.dart';

List<DemoItem> buildAnimationDemoItems(String codePath) {
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
    DemoItem(
      icon: Icons.data_thresholding,
      title: '翻页时间卡片',
      subtitle: '简介',
      keyword: 'flip_time_card',
      documentationUrl: 'https://flutter.cn/',
      buildRoute: (context) => BaseWidget(
        '翻页时间卡片',
        codePath + 'flip_time_card',
        const FlipTimeCard(),
      ),
    ),
    DemoItem(
      icon: Icons.data_thresholding,
      title: '文字渐现',
      subtitle: '简介',
      keyword: 'text_show_up',
      documentationUrl: 'https://flutter.cn/',
      buildRoute: (context) => BaseWidget(
        '文字渐现',
        codePath + 'text_show_up',
        const TextShowUp(),
      ),
    ),
    DemoItem(
      icon: Icons.data_thresholding,
      title: '翻页时钟',
      subtitle: '简介',
      keyword: 'flip_clock',
      documentationUrl: 'https://flutter.cn/',
      buildRoute: (context) => BaseWidget(
        '翻页时钟',
        codePath + 'flip_clock',
        const FlipClockPage(),
      ),
    ),
    DemoItem(
      icon: Icons.data_thresholding,
      title: '图片时钟',
      subtitle: '简介',
      keyword: 'image_clock',
      documentationUrl: 'https://flutter.cn/',
      buildRoute: (context) => const ImageClockPage(),
    ),
  ];
}
