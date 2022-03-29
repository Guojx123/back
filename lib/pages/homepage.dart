import 'package:back/pages/study/study_main_page.dart';
import 'package:back/pages/widget/mainpage_page_header.dart';
import 'package:back/pages/widget/mainpage_page_layout.dart';
import 'package:flutter/material.dart';

import 'skill/skill_main_page.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late PageController pageController;
  ValueNotifier<double> notifier = ValueNotifier<double>(0);

  @override
  void initState() {
    super.initState();
    pageController = PageController(viewportFraction: 0.9);
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            ValueListenableBuilder(
              valueListenable: notifier,
              builder: (context, value, widget) {
                return Container(
                  color: Color.lerp(
                    const Color(0xFF03A89E),
                    const Color(0xFFFFD700),
                    notifier.value,
                  ),
                );
              },
            ),
            const MainPagePageHeader(),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              height: MediaQuery.of(context).size.height * 0.76,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: PageView(
                      controller: pageController
                        ..addListener(() {
                          notifier.value =
                              pageController.offset / pageController.position.maxScrollExtent;
                        }),
                      children: <Widget>[
                        PageWidget(
                          'Learning route \n学习路线',
                          'Show Flutter Widgets in category \n分类展示Flutter中的小部件',
                          'images/study_bg.jpg',
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => StudyMainPage()),
                            );
                          },
                        ),
                        PageWidget(
                          'Development skills \n开发技巧',
                          'Show UI Pattern in most Apps \n展示大多数应用的UI样式',
                          'images/skill_bg.png',
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SkillMainPage()),
                            );
                          },
                        ),
                        PageWidget(
                          'Utilities \n实用工具',
                          'Show Flutter Utils \n介绍Flutter中实用的工具',
                          'images/util_bg.jpg',
                          () {
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => UtilMainPage()));
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 12, left: 36, right: 36),
                    child: ValueListenableBuilder(
                      valueListenable: notifier,
                      builder: (context, value, widget) {
                        return LinearProgressIndicator(
                          value: notifier.value,
                          valueColor: AlwaysStoppedAnimation(
                            Color.lerp(
                              const Color(0xFF03A89E),
                              const Color(0xFFFFD700),
                              notifier.value,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
