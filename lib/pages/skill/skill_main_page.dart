import 'package:back/model/skill/skill_category.dart';
import 'package:back/pages/skill/skill_main_list_item.dart';
import 'package:flutter/material.dart';

class SkillMainPage extends StatelessWidget {
  const SkillMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('开发技巧'),
        backgroundColor: const Color(0xFF81BF4E).withOpacity(0.8),
        elevation: 0,
      ),
      body: Container(
        color: const Color(0xFF81BF4E).withOpacity(0.8),
        child: ListView.builder(
          itemBuilder: (context, index) {
            SkillItemCategory itemCategory = buildSkillCategoryList[index];
            return SkillMainPageListItem(
              title: itemCategory.name,
              itemList: itemCategory.itemList,
            );
          },
          itemCount: buildSkillCategoryList.length,
        ),
      ),
    );
  }
}
