import 'package:back/widgets/demo_item.dart';
import 'package:flutter/material.dart';

class SkillMainPageListItem extends StatelessWidget {
  const SkillMainPageListItem({
    Key? key,
    required this.title,
    required this.itemList,
  }) : super(key: key);

  final String title;
  final List<DemoItem> itemList;

  @override
  Widget build(BuildContext context) {
    Widget listItem(String title, Function() onTap) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: Stack(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 24),
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 48),
                decoration: BoxDecoration(
                  color: Colors.teal.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Theme(
      data: ThemeData(
        primaryColor: Colors.white,
        primarySwatch: Colors.teal,
      ),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        initiallyExpanded: false,
        children: itemList
            .map((e) => listItem(
                  e.title,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: e.buildRoute),
                    );
                  },
                ))
            .toList(),
      ),
    );
  }
}
