import 'package:back/model/skill/skill_category_design_patterns.dart';
import 'package:back/model/skill/skill_category_notes.dart';
import 'package:back/widgets/demo_item.dart';

List<SkillItemCategory> buildSkillCategoryList = [
  designPatternsCreate,
  notesCreate,
];

/// add item [SkillItemCategory]
SkillItemCategory designPatternsCreate = SkillItemCategory(
  name: '设计模式',
  itemList: buildDesignPatternsCreateDemoItems('lib/category/skill/patterns/'),
);

SkillItemCategory notesCreate = SkillItemCategory(
  name: '笔记',
  itemList: buildDesignNotesCreateDemoItems('lib/category/skill/notes/'),
);

class SkillItemCategory {
  final String name;
  final List<DemoItem> itemList;

  SkillItemCategory({required this.name, required this.itemList});
}
