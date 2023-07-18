// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:dio/dio.dart';
import '/utils/app_cache.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:intranet_ip/intranet_ip.dart';
import '../utils/global_context.dart';

class WebSocketChannel {
  static final WebSocketChannel _instance = WebSocketChannel._internal();
  factory WebSocketChannel() => _instance;
  WebSocketChannel._internal();

  static WebSocketChannel get socketIntance => _instance;

  late IOWebSocketChannel channel;

  String voiceUrl = '';

  String websocketUrl = '';

  bool isFirstConnect = true;

  /*
   * @desc 创建websocket连接
   **/
  void initWebSocket(onData) async {
    var host = AppCache.host;
    if (host == null || host.isEmpty) {
      // 开机自启动太快，ip总是获取失败
      // await Future.delayed(const Duration(microseconds: 2000), _getSocketUrl);
      await Future.delayed(const Duration(microseconds: 1000), () {
        EasyLoading.showInfo('连接地址为空，请设置', duration: const Duration(days: 30));
      });
    } else {
      websocketUrl = '';
      voiceUrl = '';
      isFirstConnect = true;
      _getConnectionInfo(host, onData);
    }
  }

  void onWebsocketSuccess(message, callback) {
    if (isFirstConnect) {
      EasyLoading.showSuccess('连接成功');
      isFirstConnect = false;
    }
    callback(message);
  }

  void onWebsocketError(socketUrl) {
    channel.sink.close(status.goingAway); //关闭连接通道
    if (AppCache.host != null && AppCache.host!.isNotEmpty) {
      AppCache.cleanHost();
    }
    EasyLoading.showError('websocket连接失败, 连接地址：$socketUrl');
  }

  void onWebsocketDone(onData) {
    EasyLoading.showToast('连接终止', duration: const Duration(days: 1));
    Future.delayed(const Duration(seconds: 10), () {
      initWebSocket(onData);
      EasyLoading.showToast('正在重连', duration: const Duration(days: 1));
      isFirstConnect = true;
    });
  }

  void dispose() {
    channel.sink.close(); //关闭连接通道
  }

  /*
   * @desc 获取socketUrl
   */
  // _getSocketUrl() async {
  //   AppCache.cleanHost();
  //   String intranetIp = 'http://192.168.35.20:12240';
  //   int intranetIpCode = await _findNetwrok(intranetIp);
  //   if (intranetIpCode == 20000) {
  //     AppCache.setHost(intranetIp);
  //     await _getConnectionInfo(intranetIp);
  //   } else {
  //     try {
  //       final ipv4 = await intranetIpv4();
  //       int address = ipv4.rawAddress[2];
  //       for (var i = 2; i < 256; i++) {
  //         String ip = 'http://192.168.$address.$i:12240';
  //         EasyLoading.show(status: '正在查找服务，请稍后($ip)');
  //         int code = await _findNetwrok(ip);
  //         if (code == 20000) {
  //           AppCache.setHost(ip);
  //           await _getConnectionInfo(ip);
  //           break;
  //         }
  //         if (i == 255) {
  //           EasyLoading.show(status: '没有找到可用服务，请检查');
  //           Future.delayed(const Duration(microseconds: 4000), _getSocketUrl);
  //         }
  //       }
  //     } catch (e) {
  //       EasyLoading.show(status: '获取ip地址失败');
  //       Future.delayed(const Duration(microseconds: 4000), _getSocketUrl);
  //     }
  //   }
  // }

  /*
   * @desc 获取可用的域名
   */
  // _findNetwrok(String ip) async {
  //   debugPrint('$ip/person/sniff/bingo');
  //   try {
  //     Response response = await Dio(BaseOptions(
  //       connectTimeout: 2000,
  //     )).get('$ip/person/sniff/bingo');
  //     var result = response.data;
  //     if (result['code'] == 20000) {
  //       return 20000;
  //     } else {
  //       return 0;
  //     }
  //   } catch (e) {
  //     return 0;
  //   }
  // }

  /*
   * @desc 通过域名获取相关连接信息
   */
  _getConnectionInfo(String ip, callback) async {
    if (websocketUrl.isNotEmpty) {
      return;
    }
    try {
      // EasyLoading.show(status: '获取服务地址中...');
      Response response = await Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 16),
      )).get('$ip/person/sniff/serverUrl');
      var result = response.data;
      if (result['code'] == 20000) {
        EasyLoading.dismiss();
        var voiceTemp = result['data']!['VOICE_URL'];
        var websocketTemp = result['data']!['WEBSOCKET_URL'];
        if (voiceTemp == null || voiceTemp.isEmpty) {
          EasyLoading.show(status: '语音服务未启动，请检查');
          return;
        }
        voiceUrl = voiceTemp;
        websocketUrl = websocketTemp;
        if (websocketUrl.isNotEmpty) {
          channel = IOWebSocketChannel.connect(Uri.parse(websocketUrl));
          channel.stream.listen(
              (message) => onWebsocketSuccess(message, callback),
              onDone: () => onWebsocketDone(callback),
              onError: (error) => onWebsocketError(websocketUrl));
        }
      } else {
        // Future.delayed(const Duration(microseconds: 4000), _getSocketUrl);
        EasyLoading.showToast('获取服务地址失败：$ip, 请检查服务地址是否正确',
            duration: const Duration(days: 1));
        await Future.delayed(const Duration(seconds: 10), () {
          _getConnectionInfo(ip, callback);
        });
      }
    } catch (e) {
      EasyLoading.showToast('获取服务地址失败：$ip, 请检查网络是否正确',
          duration: const Duration(days: 1));
      await Future.delayed(const Duration(seconds: 10), () {
        _getConnectionInfo(ip, callback);
      });
    }
  }

  showTextFieldAlertDialog(String prompt) async {
    final globalContext = NavigatorProvider.navigatorContext;
    // print(globalContext);
    if (globalContext != null) {
      return showDialog(
          context: globalContext,
          builder: (context) {
            return AlertDialog(
              title: const Text('提示'),
              content: Text(prompt),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    '确定',
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {
                    Navigator.pop(context, "确定");
                  },
                ),
              ],
            );
          });
    }
  }
}
