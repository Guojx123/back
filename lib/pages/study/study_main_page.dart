import 'package:back/Model/study/study_category.dart';
import 'package:flutter/material.dart';

import 'study_category_demo_list.dart';
import 'study_main_page_list_item.dart';

class StudyMainPage extends StatelessWidget {
  const StudyMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('学习路线'),
        backgroundColor: const Color(0xFF03A89E).withOpacity(0.8),
        elevation: 0,
      ),
      body: Container(
        color: const Color(0xFF03A89E).withOpacity(0.8),
        child: ListView.builder(
          itemBuilder: (context, index) {
            var itemCategory = buildStudyCategoryList[index];
            return StudyMainPageListItem(
              itemCategory.name ?? '',
              itemCategory.subName ?? '',
              itemCategory.icon ?? '',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudyCategoryDemoList(
                      itemCategory.list ?? [],
                      itemCategory.name ?? '',
                    ),
                  ),
                );
              },
            );
          },
          itemCount: buildStudyCategoryList.length,
        ),
      ),
    );
  }
}
