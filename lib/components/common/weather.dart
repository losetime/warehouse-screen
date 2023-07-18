import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../enums/commonEnum.dart' show appId, appSecret;

class RealTimeWeather extends StatefulWidget {
  const RealTimeWeather({Key? key}) : super(key: key);
  @override
  State<RealTimeWeather> createState() => _RealTimeWeather();
}

class _RealTimeWeather extends State<RealTimeWeather>
    with SingleTickerProviderStateMixin {
  String weatherStatus = '';
  String temperature = '';

  @override
  void initState() {
    initWeather();
    super.initState();
  }

  /*
   * @desc 
   */
  initWeather() async {
    try {
      Response response = await Dio().get(
          'https://www.yiketianqi.com/free/day?appid=${appId}&appsecret=${appSecret}&unescape=1');
      var result = response.data;
      setState(() {
        weatherStatus = result['wea'];
        temperature = result['tem'] + '℃';
      });
    } catch (e) {
      print(e);
    }
  }

  /*
   * @desc 处理天气图标
   */
  IconData getWeatherIcon() {
    switch (weatherStatus) {
      case 'yun':
        return const IconData(0xe617,
            fontFamily: 'AliIcon', matchTextDirection: true);
      case 'qing':
        return const IconData(0xe615,
            fontFamily: 'AliIcon', matchTextDirection: true);
      case 'yin':
        return const IconData(0xe61d,
            fontFamily: 'AliIcon', matchTextDirection: true);
      case 'yu':
        return const IconData(0xe61a,
            fontFamily: 'AliIcon', matchTextDirection: true);
      case 'xue':
        return const IconData(0xe61b,
            fontFamily: 'AliIcon', matchTextDirection: true);
      case 'lei':
        return const IconData(0xe61e,
            fontFamily: 'AliIcon', matchTextDirection: true);
      case 'shachen':
        return const IconData(0xe61f,
            fontFamily: 'AliIcon', matchTextDirection: true);
      case 'wu':
        return const IconData(0xe620,
            fontFamily: 'AliIcon', matchTextDirection: true);
      case 'bingbao':
        return const IconData(0xe622,
            fontFamily: 'AliIcon', matchTextDirection: true);
      default:
        return const IconData(0xe615,
            fontFamily: 'AliIcon', matchTextDirection: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          getWeatherIcon(),
          size: 16,
          color: const Color.fromRGBO(33, 150, 243, 1),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
          child: Text(
            weatherStatus,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        Text(
          temperature,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
