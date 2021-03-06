import 'package:back/widgets/subtitle_widget.dart';
import 'package:back/widgets/title_widget.dart';
import 'package:flutter/material.dart';

class SingletonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleWidget('模式分析'),
        SubtitleWidget(
            '这种模式涉及到一个单一的类，该类负责创建自己的对象，同时确保只有单个对象被创建。这个类提供了一种访问其唯一的对象的方式，可以直接访问，不需要实例化该类的对象。'),
        TitleWidget('解决问题'),
        SubtitleWidget('相同对象访问缓存，不需要再去执行代码'),
        FlatButton(
            onPressed: () {
              Singleton singleton = Singleton.getInstance();
              debugPrint(singleton.toString());
            },
            child: Text('单例对象')),
        TitleWidget('线程安全'),
        SubtitleWidget('任何Dart程序的并发都是运行多个isolate的结果。因为Dart没有共享内存的并发，没有竞争的可能性所以不需要锁，也就不用担心死锁的问题。'),
        // 官方文档：https://webdev.dartlang.org/articles/performance/event-loop
      ],
    );
  }
}

class Singleton {
  /// 单例对象
  static Singleton? _instance;

  /// 内部构造方法，可避免外部暴露构造函数，进行实例化
  Singleton._internal();

  /// 工厂构造方法，这里使用命名构造函数方式进行声明
  factory Singleton.getInstance() => _getInstance();

  /// 获取单例内部方法
  static _getInstance() {
    // 只能有一个实例
    _instance ??= Singleton._internal();
    return _instance;
  }
}
