import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../provider/globalProvider.dart';
import '../../enums/homeEnum.dart'
    show freightSpaceHeader, freightSpaceRowKey, toolHeader, toolRowKey;
import '../../components/home/header.dart';
import '../../components/common/YmTable.dart';
import '../../utils/base.dart';

class HomeIndex extends StatefulWidget {
  const HomeIndex({Key? key}) : super(key: key);
  @override
  State<HomeIndex> createState() => _HomeIndex();
}

class _HomeIndex extends State<HomeIndex> with SingleTickerProviderStateMixin {
  late HomeProvider provider;

  late BaseUtils baseUtils;

  List<List> toolLogList = [];

  List<List> storeLogList = [];

  Map overviewData = {
    'receiveNum': '',
    'returnNum': '',
    'storeNum': '',
    'toolNum': '',
    'toolTypeNum': ''
  };

  int tabIndex = 0;

  late Timer switchTabsTimer;

  late Timer switchTableTimer;

  late double listViewHeight;

  int indicatorOne = 0;

  int indicatorTwo = 0;

  @override
  void initState() {
    super.initState();
    baseUtils = BaseUtils();
    Future.microtask(() => initProvider());
    // setTimingSwitchTab();
    changeIndicator();
  }

  @override
  void dispose() {
    switchTabsTimer.cancel();
    switchTableTimer.cancel();
    super.dispose();
  }

  /*
   * @desc 初始化Provider 
   */
  void initProvider() {
    provider = Provider.of<HomeProvider>(context, listen: false);
    provider.addListener(() {
      setState(() {
        storeLogList = baseUtils.formattTableData(
            provider.socketInfo['storeList'], listViewHeight);
        toolLogList = baseUtils.formattTableData(
            provider.socketInfo['toolIncorrectList'], listViewHeight);
        overviewData = provider.socketInfo['toolSum'];
      });
    });
  }

  /*
   * @desc 修改指示器
   */
  void changeIndicator() {
    switchTableTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      switch (tabIndex) {
        case 0:
          if (indicatorOne + 1 >= storeLogList.length) {
            setState(() {
              indicatorOne = 0;
            });
          } else {
            setState(() {
              indicatorOne += 1;
            });
          }
          break;
        case 1:
          if (indicatorTwo + 1 >= toolLogList.length) {
            setState(() {
              indicatorTwo = 0;
            });
          } else {
            setState(() {
              indicatorTwo += 1;
            });
          }
          break;
      }
    });
  }

  /*
   * @desc 设置定时切换Tab
   **/
  void setTimingSwitchTab() {
    switchTabsTimer = Timer.periodic(const Duration(seconds: 20), (timer) {
      if (tabIndex == 0 && toolLogList.isNotEmpty) {
        setState(() {
          tabIndex = 1;
        });
      } else {
        setState(() {
          tabIndex = 0;
        });
      }
    });
  }

  /*
   * @desc 渲染统计单项
   */
  Widget renderOverviewItem(String name, String key) {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            overviewData[key],
            style: const TextStyle(
              color: Color.fromRGBO(61, 255, 247, 1),
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /*
   * @desc 渲染统计部分
   **/
  Widget renderOverview() {
    var overviewWrap = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '工器具信息',
                style: TextStyle(
                  color: Color.fromRGBO(40, 219, 254, 1),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                margin: const EdgeInsets.only(
                  top: 5.0,
                ),
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
                  children: [
                    renderOverviewItem('工器具类型', 'toolTypeNum'),
                    const Image(
                      image: AssetImage('assets/images/split-line.png'),
                    ),
                    renderOverviewItem('工器具总数量', 'toolNum'),
                    const Image(
                      image: AssetImage('assets/images/split-line.png'),
                    ),
                    renderOverviewItem('总仓位', 'storeNum'),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 100,
          height: 50,
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                '今日领还',
                style: TextStyle(
                  color: Color.fromRGBO(40, 219, 254, 1),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                margin: const EdgeInsets.only(
                  top: 5.0,
                ),
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
                  children: [
                    renderOverviewItem('领取数量', 'receiveNum'),
                    const Image(
                      image: AssetImage('assets/images/split-line.png'),
                    ),
                    renderOverviewItem('归还数量', 'returnNum'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
    return overviewWrap;
  }

  /*
   * @desc 渲染Tabs 
   **/
  Widget renderTabs() {
    return Row(
      children: [
        InkWell(
          child: Container(
            width: 100,
            height: 33,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: tabIndex == 0
                    ? const AssetImage('assets/images/tab-bg_active.png')
                    : const AssetImage('assets/images/tab-bg.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: const Center(
              child: Text(
                '仓位状态',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          onTap: () {
            setState(() {
              tabIndex = 0;
            });
          },
        ),
        InkWell(
          child: Container(
            width: 100,
            height: 33,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: tabIndex == 1
                    ? const AssetImage('assets/images/tab-bg_active.png')
                    : const AssetImage('assets/images/tab-bg.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: const Center(
              child: Text(
                '异常工器具',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          onTap: () {
            setState(() {
              tabIndex = 1;
            });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    listViewHeight = MediaQuery.of(context).size.height - 162 - 35 - 40 - 60;
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
      ),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(0, 16, 76, 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeaderWrap(),
          Padding(
            padding: const EdgeInsets.only(
              // top: 10,
              bottom: 10,
              left: 50,
              right: 50,
            ),
            child: renderOverview(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: renderTabs(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: tabIndex == 0
                ? YmTable(
                    header: freightSpaceHeader,
                    rowKey: freightSpaceRowKey,
                    sourceData: storeLogList,
                    tableHeight: listViewHeight,
                    indicator: indicatorOne,
                    indicatorPosition: 'right',
                  )
                : YmTable(
                    header: toolHeader,
                    rowKey: toolRowKey,
                    sourceData: toolLogList,
                    tableHeight: listViewHeight,
                    indicator: indicatorTwo,
                    indicatorPosition: 'right',
                  ),
          ),
        ],
      ),
    );
  }
}
