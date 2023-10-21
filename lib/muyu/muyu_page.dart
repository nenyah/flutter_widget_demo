import 'dart:math';

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_demo/muyu/animate_text.dart';
import 'package:flutter_widget_demo/muyu/count_panel.dart';
import 'package:flutter_widget_demo/muyu/models/audio_option.dart';
import 'package:flutter_widget_demo/muyu/models/image_option.dart';
import 'package:flutter_widget_demo/muyu/models/metric_record.dart';
import 'package:flutter_widget_demo/muyu/muyu_assets.dart';
import 'package:flutter_widget_demo/muyu/options/select_audio.dart';
import 'package:flutter_widget_demo/muyu/options/select_image.dart';
import 'package:flutter_widget_demo/muyu/record_history.dart';
import 'package:flutter_widget_demo/storage/db_storage/db_storage.dart';
import 'package:uuid/uuid.dart';

import '../storage/sp_storage.dart';

class MuyuPage extends StatefulWidget {
  const MuyuPage({super.key});

  @override
  State<MuyuPage> createState() => _MuyuPageState();
}

class _MuyuPageState extends State<MuyuPage> {
  int _counter = 0;
  final Random _random = Random();

  AudioPool? pool;

  int _curValue = 0;

  final List<ImageOption> imageOptions = const [
    ImageOption('基础版', 'assets/images/muyu.png', 1, 3),
    ImageOption('尊享版', 'assets/images/muyu2.png', 3, 6),
    ImageOption('豪奢版', 'assets/images/muyu3.png', 6, 9),
  ];

  int _activeImageIndex = 0;

  final List<AudioOption> audioOptions = const [
    AudioOption('音效1', 'muyu_01.mp3'),
    AudioOption('音效2', 'muyu_02.mp3'),
    AudioOption('音效3', 'muyu_03.mp3'),
  ];

  int _activeAudioIndex = 0;

  // 激活图像
  String get activeImage => imageOptions[_activeImageIndex].src;

  // 敲击是增加值
  int get knockValue {
    int min = imageOptions[_activeImageIndex].min;
    int max = imageOptions[_activeImageIndex].max;
    return min + _random.nextInt(max + 1 - min);
  }

  List<MeritRecord> _records = [];
  final Uuid uuid = const Uuid();

  void saveConfig() {
    SpStorage.instance.saveMuYUConfig(
      counter: _counter,
      activeImageIndex: _activeImageIndex,
      activeAudioIndex: _activeAudioIndex,
    );
  }

  @override
  void initState() {
    super.initState();
    _initAudioPool();
    _initConfig();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("电子木鱼"),
        actions: [
          IconButton(
            onPressed: _toHistory,
            icon: const Icon(Icons.history),
          )
        ],
      ),
      body: Column(children: [
        Expanded(
            child: CountPanel(
          count: _counter,
          onTapSwitchAudio: _onTapSwitchAudio,
          onTapSwitchImage: _onTapSwitchImage,
        )),
        Expanded(
            child: Stack(alignment: Alignment.topCenter, children: [
          MuyuAssetsImage(image: activeImage, onTap: _onKnock),
          if (_curValue != 0)
            AnimateText(
              text: '功德+$_curValue',
              record: _records.last,
            )
        ])),
      ]),
    );
  }

  void _toHistory() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RecordHistory(records: _records.reversed.toList()),
      ),
    );
  }

  void _onTapSwitchAudio() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return AudioOptionPanel(
          audioOptions: audioOptions,
          activeIndex: _activeAudioIndex,
          onSelect: _onSelectAudio,
        );
      },
    );
  }

  void _onTapSwitchImage() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return ImageOptionPanel(
          imageOptions: imageOptions,
          activeIndex: _activeImageIndex,
          onSelect: _onSelectImage,
        );
      },
    );
  }

  void _onKnock() {
    pool?.start();
    setState(() {
      _curValue = knockValue;
      _counter += _curValue;
      // 添加功德记录
      String id = uuid.v4();
      var _cruRecord = MeritRecord(
        id,
        DateTime.now().millisecondsSinceEpoch,
        _curValue,
        activeImage,
        audioOptions[_activeAudioIndex].name,
      );
      _records.add(_cruRecord);
      saveConfig();
      DbStorage.instance.meritRecordDao.insert(_cruRecord);
    });
  }

  void _initAudioPool() async {
    pool = await FlameAudio.createPool(
      'muyu_01.mp3',
      maxPlayers: 4,
    );
  }

  void _onSelectImage(int value) {
    Navigator.of(context).pop();
    if (value == _activeImageIndex) return;
    setState(() {
      _activeImageIndex = value;
      saveConfig();
    });
  }

  String get activeAudio => audioOptions[_activeAudioIndex].src;

  void _onSelectAudio(int value) async {
    Navigator.of(context).pop();
    if (value == _activeAudioIndex) return;
    _activeAudioIndex = value;
    saveConfig();
    pool = await FlameAudio.createPool(
      activeAudio,
      maxPlayers: 1,
    );
  }

  Future<void> _initConfig() async {
    Map<String, dynamic> config = await SpStorage.instance.readMuYUConfig();
    _counter = config['counter'] ?? 0;
    _activeImageIndex = config['activeImageIndex'] ?? 0;
    _activeAudioIndex = config['activeAudioIndex'] ?? 0;
    _records = await DbStorage.instance.meritRecordDao.query();
    setState(() {});
  }
}
