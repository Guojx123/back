import 'package:back/utils/color_filter/filter_image_screen.dart';
import 'package:flutter/material.dart';

class ColorFilterPage extends StatefulWidget {
  const ColorFilterPage({Key? key}) : super(key: key);

  @override
  State<ColorFilterPage> createState() => _ColorFilterPageState();
}

class _ColorFilterPageState extends State<ColorFilterPage> {
  @override
  Widget build(BuildContext context) {
    return const FilterImageScreen();
  }
}
