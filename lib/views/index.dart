import 'dart:convert';
import 'package:flutter/material.dart'; //卡片式主题
import 'package:flutter/cupertino.dart'; //ios式风格
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../provider/globalProvider.dart';
import 'home/index.dart';
import 'toolReturned/index.dart';
import 'toolReceive/index.dart';
import 'dart:async';
import '../utils/web_socket_channel.dart';
// import 'package:dio/dio.dart';
// import 'dart:convert' as convert;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../utils/app_cache.dart';
import '../utils/logger.dart';

// 动态组件
class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  late HomeProvider homeProvider;
  late DomainProvider domainProvider;
  late BroadcastProvider broadcastProvider;
  final List<BottomNavigationBarItem> bottomTabs = [
    const BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.car_detailed), label: '主页'),
    const BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.person), label: '我的'),
  ];

  // final audioPlayer = AudioPlayer();

  final List<Widget> tabBodies = [
    const HomeIndex(),
    const ToolReturned(),
    const ToolReceive()
  ];

  late FlutterTts flutterTts;

  late WebSocketChannel webSocketChannel;

  List<String> voiceList = [];

  int currentIndex = 0;
  // var currentPage;

  bool isSocketInit = false;

  @override
  void initState() {
    // currentPage = tabBodies[currentIndex];
    super.initState();
    EasyLoading.instance.displayDuration = const Duration(milliseconds: 6000);
    initTts();
    Future.microtask(() => {initProvider()});
    if (!isSocketInit) {
      isSocketInit = true;
      initWebSocket();
    }
  }

  @override
  void dispose() {
    webSocketChannel.dispose();
    super.dispose();
  }

  /*
   * @desc 初始化Provider
   */
  void initProvider() {
    homeProvider = Provider.of<HomeProvider>(context, listen: false);
    domainProvider = Provider.of<DomainProvider>(context, listen: false);
    broadcastProvider = Provider.of<BroadcastProvider>(context, listen: false);
    domainProvider.addListener(() {
      if (domainProvider.domain.isNotEmpty) {
        AppCache.setHost(domainProvider.domain);
        initWebSocket();
      }
    });
  }

  /*
   * @desc 初始化TTS 
   **/
  void initTts() async {
    flutterTts = FlutterTts();
    await flutterTts.setLanguage("zh-CN");
    List engines = await flutterTts.getEngines;
    logger.i(engines);
    String engine =
        engines.firstWhere((element) => element == 'com.iflytek.speechcloud');
    if (engine.isNotEmpty) {
      await flutterTts.setEngine(engine);
      await flutterTts.setSpeechRate(0.8);
    } else {
      EasyLoading.show(status: '未找到语音引擎');
    }
  }

  /*
   * @desc 语音播报队列
   **/
  Future voiceBroadcast() async {
    try {
      // Response response = await Dio(BaseOptions(
      //   connectTimeout: const Duration(seconds: 5),
      // )).get('${webSocketChannel.voiceUrl}?content=${voiceList[0]}');
      // var result = response.data;
      // if (result['code'] == 20000) {
      //   var url = result['data'];
      //   var list = convert.base64Decode(url);
      //   audioPlayer.play(BytesSource(list));
      //   audioPlayer.onPlayerComplete.listen((event) {
      //     voiceList.removeAt(0);
      //     if (voiceList.isNotEmpty) {
      //       voiceBroadcast();
      //     }
      //   });
      // }
      await flutterTts.speak(voiceList[0]);
      await flutterTts.awaitSpeakCompletion(true);
      voiceList.removeAt(0);
      if (voiceList.isNotEmpty) {
        voiceBroadcast();
      }
    } catch (e) {
      EasyLoading.show(status: '语音服务连接失败, $e');
    }
  }

  /*
   * @desc 创建websocket连接
   **/
  void initWebSocket() {
    webSocketChannel = WebSocketChannel.socketIntance;
    webSocketChannel.initWebSocket(onWebsocketSuccess);
    Future.delayed(const Duration(milliseconds: 1000), () {
      isSocketInit = false;
    });
  }

  void onWebsocketSuccess(message) {
    Map result = jsonDecode(message);
    switch (result['type']) {
      // 更新列表
      case 'toolScreenData':
        homeProvider.setSocketInfo(result['data']);
        // 判断跳转哪个页面
        String eventMark = result['data']['screenEvent'];
        switch (eventMark) {
          case 'overview':
            setState(() {
              currentIndex = 0;
            });
            break;
          case 'returned':
            setState(() {
              currentIndex = 1;
            });
            break;
          case 'recipiented':
            setState(() {
              currentIndex = 2;
            });
            break;
        }
        break;
      // 语音播报
      case 'toolLog':
        broadcastProvider.setBroadcastInfo(result);
        String voiceText =
            result['content'].map((item) => item['metadata']).join();
        if (voiceList.isEmpty) {
          // 语音播报列表如果为空，插入数据，并启动播报
          voiceList.add(voiceText);
          voiceBroadcast();
        } else {
          // 直接插入
          voiceList.add(voiceText);
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // 去除顶部状态栏和底部操作栏
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return Scaffold(
      // backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
      // bottomNavigationBar: BottomNavigationBar(
      //     type: BottomNavigationBarType.fixed,
      //     currentIndex: currentIndex,
      //     items: bottomTabs,
      //     // 点击事件
      //     onTap: (index) {
      //       setState(() {
      //         currentIndex = index;
      //         currentPage = tabBodies[currentIndex];
      //       });
      //     }),
      body: IndexedStack(index: currentIndex, children: tabBodies),
    );
  }
}
