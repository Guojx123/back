import 'package:back/Widgets/subtitle_widget.dart';
import 'package:back/Widgets/title_widget.dart';
import 'package:flutter/material.dart';

class ConfigPage extends StatelessWidget {
  const ConfigPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TitleWidget('示例'),
        SubtitleWidget('windows'),
        ExcludeSemantics(
          child: Container(
            width: 100,
            height: 100,
            color: Colors.blueAccent,
            child: const Text('配置环境'),
          ),
        )
      ],
    );
  }
}
