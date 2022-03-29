import 'package:back/widgets/subtitle_widget.dart';
import 'package:back/widgets/title_widget.dart';
import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  const InputField({Key? key}) : super(key: key);

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: ListView(
        children: <Widget>[
          TitleWidget('提示缩小在输入上方'),
          TextField(
            decoration:
                InputDecoration(fillColor: Colors.blue.shade100, filled: true, labelText: 'Hello'),
          ),
          TitleWidget('输入后提示消失，如果输入不符合要求就可以报相应错误（自定义提示语）'),
          TextField(
            decoration: InputDecoration(
                fillColor: Colors.blue.shade100,
                filled: true,
                hintText: 'Hello',
                errorText: 'error'),
          ),
          TitleWidget('添加图标'),
          TextField(
            decoration: InputDecoration(
                fillColor: Colors.blue.shade100,
                filled: true,
                helperText: 'help',
                prefixIcon: Icon(Icons.local_airport),
                suffixText: 'airport'),
          ),
          TitleWidget('输入框添加圆切角'),
          TextField(
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                )),
          ),
          TitleWidget('利用ThemeData改变TextField的边框样色'),
          Theme(
            data: ThemeData(primaryColor: Colors.red, hintColor: Colors.blue),
            child: TextField(
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  )),
            ),
          ),
          TitleWidget('改变输入框粗细'),
          Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            height: 60.0,
            decoration: BoxDecoration(
                color: Colors.blueGrey,
                border: Border.all(color: Colors.black54, width: 4.0),
                borderRadius: BorderRadius.circular(12.0)),
            child: TextFormField(
              decoration: const InputDecoration.collapsed(hintText: 'hello'),
            ),
          ),
          SubtitleWidget(
              '改变边框的粗细,这些TextField的decoration彻底不能满足要求了，需要重构成这种方式,InputDecoration.collapsed可以禁用装饰线，而是使用外面包围的Container的装饰线'),
        ],
      ),
    );
  }
}
