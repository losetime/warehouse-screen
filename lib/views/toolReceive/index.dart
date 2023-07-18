import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/globalProvider.dart';
import '../../components/home/header.dart';

class ToolReceive extends StatefulWidget {
  const ToolReceive({Key? key}) : super(key: key);
  @override
  State<ToolReceive> createState() => _ToolReceive();
}

class _ToolReceive extends State<ToolReceive>
    with SingleTickerProviderStateMixin {
  late HomeProvider provider;

  Map personInfo = {};

  Map toolStats = {};

  List sourceData = [];

  @override
  void initState() {
    super.initState();
  }

  /*
   * @desc 初始化Provider 
   */
  void initProvider(context) {
    provider = Provider.of<HomeProvider>(context);
    provider.addListener(() {
      setState(() {
        sourceData = provider.socketInfo['toolRecList'];
        personInfo = provider.socketInfo.containsKey('peopleInfo')
            ? provider.socketInfo['peopleInfo']
            : {};
        toolStats = provider.socketInfo.containsKey('toolSingleSumPO')
            ? provider.socketInfo['toolSingleSumPO']
            : {};
      });
    });
  }

  /*
   * @desc 渲染人员信息
   */
  Widget renderPersonInfo() {
    var photoUrl =
        personInfo.containsKey('photoUrl') ? personInfo['photoUrl'] : '';
    var userName =
        personInfo.containsKey('userName') ? personInfo['userName'] : '';
    var personInfoWrap = Container(
      width: 250,
      height: 230,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(0, 116, 216, 1),
            Color.fromRGBO(0, 74, 164, 1),
          ],
        ),
        borderRadius: BorderRadius.circular(10.0), //3像素圆角
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '人员信息',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'personal information',
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.5),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(4.0), //3像素圆角
            ),
            child: photoUrl == ''
                ? Image.asset(
                    'assets/images/avatar.png',
                    width: 100,
                    height: 120,
                  )
                : Image.network(
                    photoUrl,
                    width: 100,
                    height: 120,
                  ),
          ),
          Text(
            userName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
    return personInfoWrap;
  }

  /*
   * @desc 领用情况
   */
  Widget renderReturned() {
    String receiveNum = toolStats.isNotEmpty ? toolStats['receiveNum'] : '';
    Widget returnedWrap = Container(
      width: 250,
      height: 230,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(0, 116, 216, 1),
            Color.fromRGBO(0, 74, 164, 1),
          ],
        ),
        borderRadius: BorderRadius.circular(10.0), //3像素圆角
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                '本次领用情况',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              Text(
                'Receiving condition',
                style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 0.5),
                  fontSize: 10,
                ),
              ),
            ],
          ),
          SizedBox(
            width: double.maxFinite,
            height: 170,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: const [
                    Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                    ),
                    Text(
                      '领用完成',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      receiveNum,
                      style: const TextStyle(
                        color: Color.fromRGBO(18, 155, 255, 1),
                        fontSize: 32,
                      ),
                    ),
                    const Text(
                      '领用总数 ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
    return returnedWrap;
  }

  /*
   * @desc 渲染卡片信息
   */
  List<Widget> renderCardInfo() {
    List<Widget> cardInfoList = sourceData.map((item) {
      String imgPath = 'assets/images/receiving-bg.png';
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage(imgPath),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  '工器具名称：',
                  style: TextStyle(
                    color: Color.fromRGBO(128, 135, 165, 1),
                    fontSize: 18,
                  ),
                ),
                Text(
                  '${item['toolName']}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  '器具编号：',
                  style: TextStyle(
                    color: Color.fromRGBO(128, 135, 165, 1),
                    fontSize: 18,
                  ),
                ),
                Text(
                  '${item['codeNumber']}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  '类别：',
                  style: TextStyle(
                    color: Color.fromRGBO(128, 135, 165, 1),
                    fontSize: 18,
                  ),
                ),
                Text(
                  '${item['toolTypeName']}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  '仓位：',
                  style: TextStyle(
                    color: Color.fromRGBO(128, 135, 165, 1),
                    fontSize: 18,
                  ),
                ),
                Text(
                  '${item['expectPosition']}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }).toList();

    return cardInfoList;
  }

  @override
  Widget build(BuildContext context) {
    initProvider(context);
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [renderPersonInfo(), renderReturned()],
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: GridView.count(
                        //水平子Widget之间间距
                        crossAxisSpacing: 10.0,
                        //垂直子Widget之间间距
                        mainAxisSpacing: 12.0,
                        //GridView内边距
                        // padding: EdgeInsets.all(10.0),
                        //一行的Widget数量
                        crossAxisCount: 3,
                        //子Widget宽高比例
                        childAspectRatio: 0.92,
                        shrinkWrap: true,
                        //子Widget列表
                        children: renderCardInfo(),
                      ),
                    ),
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
