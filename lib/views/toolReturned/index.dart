import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/globalProvider.dart';
import '../../components/home/header.dart';
import '../../enums/homeEnum.dart'
    show
        toolReturnedHistoryHeader,
        toolReturnedHistoryKey,
        toolReturnedRealTimeHeader,
        toolReturnedRealTimeKey;
import '../../components/common/YmTable.dart';
import '../../utils/base.dart';
import 'dart:async';

class ToolReturned extends StatefulWidget {
  const ToolReturned({Key? key}) : super(key: key);
  @override
  State<ToolReturned> createState() => _ToolReturned();
}

class _ToolReturned extends State<ToolReturned>
    with SingleTickerProviderStateMixin {
  late HomeProvider provider;

  late BroadcastProvider broadcastProvider;

  late BaseUtils baseUtils;

  List<List> toolYGHList = [];

  List<List> toolZKYCList = [];

  late double listViewHeight;

  List<Widget> broadcastPanel = [];

  int indicatorOne = 0;

  int indicatorTwo = 0;

  late Timer switchTableTimer;

  @override
  void initState() {
    baseUtils = BaseUtils();
    Future.microtask(() => initProvider());
    changeIndicator();
    super.initState();
  }

  @override
  void dispose() {
    switchTableTimer.cancel();
    super.dispose();
  }

  /*
   * @desc 初始化Provider 
   */
  void initProvider() {
    provider = Provider.of<HomeProvider>(context, listen: false);
    broadcastProvider = Provider.of<BroadcastProvider>(context, listen: false);
    provider.addListener(() {
      setState(() {
        toolYGHList = baseUtils.formattTableData(
            provider.socketInfo['toolYGHList'], listViewHeight);
        toolZKYCList = baseUtils.formattTableData(
            provider.socketInfo['toolZKYCList'], listViewHeight);
      });
    });
    broadcastProvider.addListener(() {
      setState(() {
        broadcastPanel = renderBroadcastWrap();
      });
    });
  }

  /*
   * @desc 修改指示器
   */
  void changeIndicator() {
    switchTableTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (indicatorOne + 1 >= toolYGHList.length) {
        setState(() {
          indicatorOne = 0;
        });
      } else {
        setState(() {
          indicatorOne += 1;
        });
      }
      if (indicatorTwo + 1 >= toolZKYCList.length) {
        setState(() {
          indicatorTwo = 0;
        });
      } else {
        setState(() {
          indicatorTwo += 1;
        });
      }
    });
  }

  /*
   * @desc 渲染广播字段
   */
  List<Widget> renderBroadcastWrap() {
    List content = broadcastProvider.broadcastInfo['content'];
    List<Widget> broadcastWrap = content.map((item) {
      List<String> colorList = item['fontColor'].split(',');
      return Text(
        item['metadata'],
        style: TextStyle(
          color: Color.fromRGBO(
              int.parse(colorList[0]),
              int.parse(colorList[1]),
              int.parse(colorList[2]),
              double.parse(colorList[3])),
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      );
    }).toList();
    return broadcastWrap;
  }

  @override
  Widget build(BuildContext context) {
    listViewHeight = MediaQuery.of(context).size.height - 162 - 35 - 40 - 20;
    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        decoration: const BoxDecoration(
          color: Color.fromRGBO(0, 16, 76, 1),
        ),
        child: Column(
          children: [
            const HeaderWrap(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromRGBO(0, 92, 173, 1),
                          Color.fromRGBO(0, 57, 138, 1),
                        ],
                      ),
                      border: Border.all(
                        color: const Color.fromRGBO(7, 187, 237, 1),
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: broadcastPanel,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: YmTable(
                          header: toolReturnedHistoryHeader,
                          rowKey: toolReturnedHistoryKey,
                          sourceData: toolYGHList,
                          tableHeight: listViewHeight,
                          indicator: indicatorOne,
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: YmTable(
                          header: toolReturnedRealTimeHeader,
                          rowKey: toolReturnedRealTimeKey,
                          sourceData: toolZKYCList,
                          tableHeight: listViewHeight,
                          indicatorPosition: 'right',
                          indicator: indicatorTwo,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
