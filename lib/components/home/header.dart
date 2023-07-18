import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; //ios式风格
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:date_format/date_format.dart';
import '../../components/common/weather.dart';
import '../../provider/globalProvider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class HeaderWrap extends StatefulWidget {
  const HeaderWrap({Key? key}) : super(key: key);
  @override
  State<HeaderWrap> createState() => _HeaderWrap();
}

class _HeaderWrap extends State<HeaderWrap>
    with SingleTickerProviderStateMixin {
  String nowTime = '';

  late Timer dateTimer;

  final TextEditingController _textFieldController = TextEditingController();

  late DomainProvider domainProvider;

  @override
  void initState() {
    super.initState();
    initProvider();
    getNowTime();
  }

  @override
  void dispose() {
    dateTimer.cancel();
    super.dispose();
  }

  /*
   * @desc 设置当前时间
   */
  void getNowTime() {
    const weekday = [" ", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"];
    dateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      DateTime currentDate = DateTime.now();
      setState(() {
        nowTime = '${formatDate(currentDate, [
              yyyy,
              '-',
              mm,
              '-',
              dd
            ])}  ${weekday[currentDate.weekday]}  ${formatDate(currentDate, [
              HH,
              ':',
              nn,
              ':',
              ss
            ])}';
        // +
        //     weekday[currentDate.weekday] +
        //     formatDate(currentDate, [HH, ':', nn, ':', ss]);
      });
    });
  }

  /*
   * @desc 初始化Provider 
   */
  void initProvider() {
    domainProvider = Provider.of<DomainProvider>(context, listen: false);
  }

  showTextFieldAlertDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('设置'),
            content: TextField(
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: "请输入域名地址"),
            ),
            actions: <Widget>[
              TextButton(
                  child: const Text(
                    '取消',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onPressed: () {
                    Navigator.pop(context, "取消");
                  }),
              TextButton(
                child: const Text(
                  '确定',
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () {
                  domainProvider.setDomain(_textFieldController.text);
                  Navigator.pop(context, "确定");
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      // alignment: Alignment.center,
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('assets/images/header-bg.png'),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.only(
              left: 20,
              top: 8,
            ),
            child: Text(
              nowTime,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              right: 20,
              top: 8,
            ),
            child: Row(
              children: [
                const RealTimeWeather(),
                InkWell(
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: 12,
                    ),
                    child: const Icon(CupertinoIcons.settings,
                        color: Colors.white, size: 16),
                  ),
                  onTap: () {
                    EasyLoading.dismiss();
                    showTextFieldAlertDialog(context);
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
