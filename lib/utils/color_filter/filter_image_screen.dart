import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'crop_screen.dart';
import 'effect.dart';

class FilterImageScreen extends StatefulWidget {
  const FilterImageScreen({Key? key}) : super(key: key);

  @override
  _FilterImageScreenState createState() => _FilterImageScreenState();
}

class _FilterImageScreenState extends State<FilterImageScreen> {
  // VARIABLES AND CONSTANTS
  double _screenHeight = 0.0;
  File? _image;
  final picker = ImagePicker();
  ColorFilter? _selectedFilter;
  List<ColorFilter> filterList = [
    ColorFilter.matrix(yellowEffect),
    ColorFilter.matrix(darkBgEffect),
    ColorFilter.matrix(pinkEffect),
    ColorFilter.matrix(blackAndWhite),
    ColorFilter.matrix(darken),
    ColorFilter.matrix(lighten),
    ColorFilter.matrix(greyEffect),
  ];

  // LIFE CYCLE

  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height - 60;
    return Column(
      children: [
        addImageContainer(context),
        filterColorOptionContainer(context),
        imageFilterOptionContainer(context)
      ],
    );
  }

  // HELPERS

  Future getImage(ImageSource imageSource) async {
    final pickedFile = await picker.getImage(source: imageSource);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Widget addImageContainer(BuildContext context) {
    return Container(
        height: _screenHeight * 0.5,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(5),
        color: Theme.of(context).primaryColorLight,
        child: _image == null
            ? Center(
                child: IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Theme.of(context).primaryColor,
                  ),
                  iconSize: 50,
                  onPressed: () {
                    getImage(ImageSource.gallery);
                  },
                ),
              )
            : Container(
                child: _selectedFilter == null
                    ? Image.file(File(_image!.path))
                    : ColorFiltered(
                        colorFilter: _selectedFilter!,
                        child: Image.file(
                          File(_image!.path),
                        ),
                      ),
              ));
  }

  Widget filterColorOptionContainer(BuildContext context) {
    return Expanded(
      flex: 1,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return imageContainer(filterList[index]);
        },
        itemCount: filterList.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget filterCropOptionsContainer(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  Widget imageFilterOptionContainer(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: _screenHeight * 0.08,
      width: 250,
      child: OutlineButton(
        borderSide: BorderSide(width: 2, color: Theme.of(context).primaryColor),
        onPressed: () {
          if (_selectedFilter != null && _image != null) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CropScreen(
                      imageFile: _image!,
                      filter: _selectedFilter!,
                    )));
          }
        },
        child: Text(
          'Crop Image',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );
  }

  Widget imageContainer(ColorFilter filter) {
    return InkWell(
      onTap: () {
        setState(() {
          debugPrint("filter change");
          _selectedFilter = filter;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 100,
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ColorFiltered(
              colorFilter: filter,
              child: Image.asset(
                'images/mascot.png',
                fit: BoxFit.contain,
              ),
            ),
            const Text("name")
          ],
        ),
      ),
    );
  }
}
