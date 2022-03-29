import 'package:back/utils/markdown/syntax_highlighter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markdown_widget/markdown_widget.dart';

class MarkdownPage extends StatefulWidget {
  final demoFilePath;
  final String? title;

  MarkdownPage(this.demoFilePath, {this.title});

  @override
  _MarkdownPageState createState() => _MarkdownPageState();
}

class _MarkdownPageState extends State<MarkdownPage> {
  String? _markdownCodeString;

  @override
  void didChangeDependencies() {
    getExampleCode(context, '${widget.demoFilePath}', DefaultAssetBundle.of(context))
        .then<void>((String code) {
      if (mounted) {
        setState(() {
          _markdownCodeString = code;
        });
      }
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var style = SyntaxHighlighterStyle.lightThemeStyle();

    try {
      if (_markdownCodeString != null) DartSyntaxHighlighter(style).format(_markdownCodeString!);
    } catch (err) {
      debugPrint('format error');
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "Demo"),
      ),
      body: _markdownCodeString == null
          ? const Center(
              child: Text('Not Found'),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: MarkdownWidget(data: _markdownCodeString!),
            ),
    );
  }
}

Map<String, String>? _exampleCode;
String? _code;

Future<String> getExampleCode(context, String filePath, AssetBundle bundle) async {
  if (_exampleCode == null) await _parseExampleCode(context, filePath, bundle);
  return _code ?? 'no found';
}

Future<void> _parseExampleCode(context, String filePath, AssetBundle bundle) async {
  String? code;
  try {
    code = await bundle.loadString(filePath);
  } catch (err) {
    Navigator.of(context).pop();
  }
  _code = code;
}
