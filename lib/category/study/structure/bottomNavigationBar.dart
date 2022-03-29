import 'package:back/widgets/multi_selection_widget.dart';
import 'package:back/widgets/subtitle_widget.dart';
import 'package:back/widgets/title_widget.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarPage extends StatefulWidget {
  @override
  _BottomNavigationBarPageState createState() => _BottomNavigationBarPageState();
}

class _BottomNavigationBarPageState extends State<BottomNavigationBarPage> {
  int currentIndex = 1;
  late PageController pageController;
  var currentPage = 0;
  var itemType = BottomNavigationBarType.fixed;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TitleWidget('BottomNavigationBar基本使用'),
        SubtitleWidget("样式"),
        MultiSelectionWidget(
          'Type',
          BottomNavigationBarType.values,
          BottomNavigationBarType.values,
          (value) {
            setState(() => itemType = value);
          },
        ),
        BottomNavigationBar(
          type: itemType,
          iconSize: 24,
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() => currentIndex = index);
          },
          fixedColor: Colors.blue,
          unselectedItemColor: Colors.red,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: 'List',
              icon: Icon(Icons.list),
            ),
            BottomNavigationBarItem(
              label: 'Message',
              icon: Icon(Icons.message),
            ),
            BottomNavigationBarItem(
              label: 'add',
              icon: Icon(Icons.add),
            ),
            BottomNavigationBarItem(
              label: 'menu',
              icon: Icon(Icons.menu),
            ),
            BottomNavigationBarItem(
              label: 'other',
              icon: Icon(Icons.devices_other),
            ),
          ],
        ),
        TitleWidget('在Scaffold中，配合PageView使用BottomNavigationBar'),
        Expanded(
          child: Column(
            children: <Widget>[
              Expanded(
                child: PageView(
                  children: <Widget>[
                    Container(
                      color: Colors.grey.shade200,
                    ),
                    Container(
                      color: Colors.redAccent,
                    ),
                    Container(
                      color: Colors.blueAccent,
                    ),
                  ],
                  controller: pageController,
                  physics: BouncingScrollPhysics(),
                  onPageChanged: (page) {
                    setState(() => currentPage = page);
                  },
                ),
              ),
              BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.toys),
                    label: 'toys',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.tap_and_play),
                    label: 'play',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.landscape),
                    label: 'landscape',
                  ),
                ],
                onTap: (page) {
                  pageController.animateToPage(
                    page,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                },
                currentIndex: currentPage,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
