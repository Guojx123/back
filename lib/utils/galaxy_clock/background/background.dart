import 'package:back/utils/galaxy_clock/background/star.dart';
import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final int starsCount;

  Background({this.starsCount = 50});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: List.generate(
          starsCount,
          (i) => Star(),
        ),
      ),
    );
  }
}
