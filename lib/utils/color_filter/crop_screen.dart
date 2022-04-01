import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

import 'my_paint.dart';

class CropScreen extends StatefulWidget {
  final File imageFile;
  final ColorFilter filter;

  const CropScreen({Key? key, required this.imageFile, required this.filter}) : super(key: key);

  @override
  _CropScreenState createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
  // VARIABLES
  late ui.Image _image; // get in init state
  final GlobalKey _repaintBoundaryKey = GlobalKey();

  // LIFE CYCLE

  @override
  void initState() {
    loadImageFromFile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: appBar(context),
      body: _image != null
          ? Center(
              child: RepaintBoundary(
                key: _repaintBoundaryKey,
                child: FittedBox(
                  child: SizedBox(
                    height: _image.height.toDouble(),
                    width: _image.width.toDouble(),
                    child: CustomPaint(
                      painter: MyPainter(
                          image: _image,
                          filter: widget.filter,
                          screenSize: MediaQuery.of(context).size),
                    ),
                  ),
                ),
              ),
            )
          : Center(
              child: Text("Loading image..."),
            ),
    );
  }

  // WIDGETS

  AppBar appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: Text(
        'Crop Image',
        style: Theme.of(context).textTheme.headline6,
      ),
      actions: [
        TextButton(
          onPressed: () {
            showSaveToGalleryAlert(context);
          },
          child: Text(
            'save',
            style: Theme.of(context).textTheme.headline6,
          ),
        )
      ],
    );
  }

  // HELPERS

  void loadImageFromFile() async {
    final data = await widget.imageFile.readAsBytes(); // Gives Uint8List data
    var decodedImage = await decodeImageFromList(data); // Converts image as dart's Image (dart:ui)
    setState(() {
      _image = decodedImage;
    });
  }

  void saveToGallery() async {
    RenderRepaintBoundary boundary =
        _repaintBoundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    double dpr = ui.window.devicePixelRatio;
    ui.Image image = await boundary.toImage(pixelRatio: dpr);
    // 编码的png导致背景颜色为黑色
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData != null) {
      await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
    }
  }

  void checkPermission() async {
    // NSPhotoLibraryAddUsageDescription add in info.plist
    // Add storage read write permission in manifest
    var permissionStatus = await Permission.storage.status;
    if (permissionStatus != PermissionStatus.granted) {
      var result = await Permission.storage.request();
      if (result == PermissionStatus.granted) {
        saveToGallery();
      } else {
        debugPrint("Permission not granted");
      }
    } else {
      saveToGallery();
    }
  }

  showSaveToGalleryAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('save'),
            content: Text("Are you sure you want to save this image?"),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.blue, letterSpacing: 1.5),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text(
                  "Yes",
                  style: TextStyle(color: Colors.blue, letterSpacing: 1.5),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  checkPermission();
                },
              ),
            ],
          );
        });
  }
}
