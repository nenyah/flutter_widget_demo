import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_widget_demo/guess/guess_app_bar.dart';
import 'package:flutter_widget_demo/guess/result_notice.dart';
import 'package:flutter_widget_demo/storage/sp_storage.dart';

class GuessPage extends StatefulWidget {
  final String title;

  const GuessPage({super.key, required this.title});

  @override
  State<GuessPage> createState() => _GuessPageState();
}

class _GuessPageState extends State<GuessPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  int _value = 0;
  final Random _random = Random();
  bool _guessing = false;
  int _guessCount = 0;
  final int _maxGuess = 10;
  bool? _isBig;
  String _infoMsg = "点击生成随机数";
  String _bigMsg = "太大了";
  final TextEditingController _guessCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initConfig();
  }

  /// 生成随机值
  void _generateRandomValue() {
    setState(() {
      _guessing = true;
      _value = _random.nextInt(100);
      SpStorage.instance.saveGuessConfig(guessing: _guessing, value: _value);
      print(_value);
    });
  }

  /// 校验输入值
  void _onCheck() {
    int? guess = int.tryParse(_guessCtrl.text);
    // 游戏未开始，或者输入非整数，无视
    if (!_guessing || guess == null) return;

    if (_guessCount >= _maxGuess) {
      setState(() {
        _guessing = false;
        _guessCount = 0;
        _guessCtrl.text = "";
        _infoMsg = "猜太多次了，请重新开始";
      });
      return;
    }

    _guessCount++;
    if (guess == _value) {
      setState(() {
        _guessing = false;
        _guessCount = 0;
        _guessCtrl.text = "";
        _infoMsg = "恭喜你猜对了";
        _isBig = null;
      });
      return;
    }
    setState(() {
      _guessCtrl.text = "";
      _isBig = guess > _value;
      _bigMsg = _isBig! ? "太大了" : "太小了";
    });
  }

  @override
  void dispose() {
    _guessCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: GuessAppBar(
        onCheck: _onCheck,
        controller: _guessCtrl,
      ),
      body: Stack(children: [
        if (_isBig != null)
          Column(
            children: [
              if (_isBig!) ResultNotice(color: Colors.redAccent, info: _bigMsg),
              const Spacer(),
              if (!_isBig!)
                ResultNotice(color: Colors.blueAccent, info: _bigMsg),
            ],
          ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (!_guessing) Text(_infoMsg),
              Text(
                _guessing ? "**" : '$_value',
                style: const TextStyle(
                    fontSize: 68,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        )
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: _guessing ? null : _generateRandomValue,
        backgroundColor: _guessing ? Colors.grey : Colors.blue,
        tooltip: 'Increment',
        child: const Icon(Icons.ac_unit),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void _initConfig() async {
    Map<String, dynamic> config = await SpStorage.instance.readGuessConfig();
    _guessing = config['guessing'] ?? false;
    _value = config['value'] ?? 0;
    setState(() {});
  }
}
