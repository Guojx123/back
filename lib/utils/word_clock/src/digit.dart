import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:back/utils/word_clock/src/time_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'constants.dart';

/// Used to how 1 character with assets/words2.png background image blended on font
class Digit extends StatefulWidget {
  final int Function(BuildContext, TimeModel)? selector;
  final String? simpleString;

  const Digit(this.selector, {Key? key, this.simpleString}) : super(key: key);
  @override
  _DigitState createState() => _DigitState();
}

class _DigitState extends State<Digit> {
  ui.Image? _image;
  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  _loadImage() async {
    ByteData bd = await rootBundle.load("images/words.png");
    final Uint8List bytes = Uint8List.view(bd.buffer);
    final ui.Codec codec = await ui.instantiateImageCodec(bytes);
    final ui.Image image = (await codec.getNextFrame()).image;
    setState(() => _image = image);
  }

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: Theme.of(context).brightness == Brightness.light
          ? ColorFilter.matrix([
              // invert image, convert white to invert of dark blue, invert image again
              //R  G   B    A  Const
              1 - Constants.lessDarkBlue.red / 255, 0, 0, 0,
              Constants.lessDarkBlue.red.toDouble(), //
              0, 1 - Constants.lessDarkBlue.green / 255, 0, 0,
              Constants.lessDarkBlue.green.toDouble(), //
              0, 0, 1 - Constants.lessDarkBlue.blue / 255, 0,
              Constants.lessDarkBlue.blue.toDouble(), //
              0, 0, 0, 1, 0, //
            ])
          : ColorFilter.matrix([
              // convert white to invert of darkBlue and then invert entire image again
              //R  G   B    A  Const
              -(255 - Constants.darkBlue.red) / 255, 0, 0, 0, 255, //
              0, -(255 - Constants.darkBlue.green) / 255, 0, 0, 255, //
              0, 0, -(255 - Constants.darkBlue.blue) / 255, 0, 255, //
              0, 0, 0, 1, 0, //
            ]),
      child: _image != null
          ? FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _image!.width.toDouble(),
                height: _image!.height.toDouble(),
                child: widget.simpleString != null
                    ? CustomPaint(
                        painter: DigitPainter(
                            _image!, widget.simpleString!, MediaQuery.of(context).size.width),
                      )
                    : widget.selector != null
                        ? Selector<TimeModel, int>(
                            selector: widget.selector!,
                            builder: (_, digit, child) => CustomPaint(
                              painter: DigitPainter(
                                  _image!, digit.toString(), MediaQuery.of(context).size.width),
                            ),
                          )
                        : const SizedBox(),
              ),
            )
          : const SizedBox(),
    );
    return Container();
  }
}

class DigitPainter extends CustomPainter {
  final TextPainter textPainter;
  final ui.Image image;
  final String digit;
  final double fontSize;

  DigitPainter(this.image, this.digit, this.fontSize)
      : textPainter = TextPainter(
            text: TextSpan(
              text: digit,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 1000,
                color: Constants.digitColor,
              ),
            ),
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center),
        super();

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = const Offset(0, 0) & size;
    canvas.drawImage(image, Offset.zero, Paint());
    canvas.saveLayer(rect, Paint()..blendMode = BlendMode.dstATop);
    textPainter
      ..layout(minWidth: size.width)
      ..paint(canvas, const Offset(0, -220));
    canvas.restore();
  }

  @override
  bool shouldRepaint(DigitPainter oldDelegate) => textPainter != oldDelegate.textPainter;
}
