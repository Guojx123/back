import 'package:back/model/skill/skill_category_animation.dart';
import 'package:back/model/skill/skill_category_business.dart';
import 'package:back/model/skill/skill_category_conclusion.dart';
import 'package:back/model/skill/skill_category_design_patterns.dart';
import 'package:back/model/skill/skill_category_notes.dart';
import 'package:back/widgets/demo_item.dart';

List<SkillItemCategory> buildSkillCategoryList = [
  designPatternsCreate,
  businessCreate,
  conclusionsCreate,
  notesCreate,
  animationCreate,
];

/// add item [SkillItemCategory]
SkillItemCategory designPatternsCreate = SkillItemCategory(
  name: '设计模式',
  itemList: buildDesignPatternsDemoItems('lib/category/skill/patterns/'),
);

SkillItemCategory businessCreate = SkillItemCategory(
  name: '业务',
  itemList: buildBusinessDemoItems('lib/category/skill/business/'),
);

SkillItemCategory conclusionsCreate = SkillItemCategory(
  name: '结论',
  itemList: buildConclusionsDemoItems('lib/category/skill/conclusion/'),
);

SkillItemCategory notesCreate = SkillItemCategory(
  name: '笔记',
  itemList: buildNotesDemoItems('lib/category/skill/notes/'),
);

SkillItemCategory animationCreate = SkillItemCategory(
  name: '动画',
  itemList: buildAnimationDemoItems('lib/category/skill/animation/'),
);

class SkillItemCategory {
  final String name;
  final List<DemoItem> itemList;

  SkillItemCategory({required this.name, required this.itemList});
}
