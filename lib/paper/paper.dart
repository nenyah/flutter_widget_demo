import 'package:flutter/material.dart';
import 'package:flutter_widget_demo/paper/color_selector.dart';
import 'package:flutter_widget_demo/paper/model.dart';
import 'package:flutter_widget_demo/paper/stroke_width_selector.dart';

import 'conform_dialog.dart';
import 'paper_app_bar.dart';
import 'paper_painter.dart';

class Paper extends StatefulWidget {
  const Paper({super.key});

  @override
  State<Paper> createState() => _PaperState();
}

class _PaperState extends State<Paper> with AutomaticKeepAliveClientMixin {
  final List<Line> _lines = []; // 线列表
  final List<Line> _historyLines = [];

  // 颜色激活索引
  int _activeColorIndex = 0;

  // 线宽激活索引
  int _activeStorkWidthIndex = 0;

  // 支持的颜色
  final List<Color> supportColors = [
    Colors.black,
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ];

// 支持的线粗
  final List<double> supportStorkWidths = [1, 2, 4, 6, 8, 10];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: PaperAppBar(
          onClear: _showClearDialog,
          onBack: _lines.isEmpty ? null : _back,
          onRevocation: _historyLines.isEmpty ? null : _revocation,
        ),
        body: Stack(children: [
          GestureDetector(
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            child: CustomPaint(
              painter: PaperPainter(
                lines: _lines,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints.expand(),
              ),
            ),
          ),
          Positioned(
              bottom: 0,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Expanded(
                    child: ColorSelector(
                        supportColors: supportColors,
                        activeIndex: _activeColorIndex,
                        onSelect: _onSelectColor),
                  ),
                  StorkWidthSelector(
                    activeIndex: _activeStorkWidthIndex,
                    color: supportColors[_activeColorIndex],
                    supportStorkWidths: supportStorkWidths,
                    onSelect: _onSelectStrokeWidth,
                  ),
                ],
              )),
        ]));
  }

  void _showClearDialog() {
    String msg = "您的当前操作会清空绘制内容，是否确定删除!";
    showDialog(
        context: context,
        builder: (ctx) => ConformDialog(
              title: '清空提示',
              conformText: '确定',
              msg: msg,
              onConform: _clear,
            ));
  }

  void _clear() {
    _lines.clear();
    Navigator.of(context).pop();
    setState(() {});
  }

  // 拖拽开始，添加新线
  void _onPanStart(DragStartDetails details) {
    _lines.add(Line(
      points: [details.localPosition],
      // 使用激活线宽
      strokeWidth: supportStorkWidths[_activeStorkWidthIndex],
      color: supportColors[_activeColorIndex],
    ));
  }

  // 拖拽中，为新线添加点
  void _onPanUpdate(DragUpdateDetails details) {
    Offset point = details.localPosition;
    double distance = (_lines.last.points.last - point).distance;
    if (distance > 5) {
      _lines.last.points.add(details.localPosition);
      setState(() {});
    }
  }

  void _onSelectStrokeWidth(int index) {
    if (index != _activeStorkWidthIndex) {
      setState(() {
        _activeStorkWidthIndex = index;
      });
    }
  }

  void _onSelectColor(int index) {
    if (index != _activeColorIndex) {
      setState(() {
        _activeColorIndex = index;
      });
    }
  }

  void _back() {
    Line line = _lines.removeLast();
    _historyLines.add(line);
    setState(() {});
  }

  void _revocation() {
    Line line = _historyLines.removeLast();
    _lines.add(line);
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;
}
