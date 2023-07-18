class BaseUtils {
  /*
   * @desc 分割表格数据为二维数组
   */
  List<List> formattTableData(List sourceData, double tableHeight) {
    List<List> twoDimList = [];
    int len = tableHeight ~/ 40;
    int index = 1;
    while (true) {
      if (index * len < sourceData.length) {
        List temp = sourceData.skip((index - 1) * len).take(len).toList();
        twoDimList.add(temp);
        index++;
        continue;
      }
      List temp = sourceData.skip((index - 1) * len).toList();
      twoDimList.add(temp);
      break;
    }
    return twoDimList;
  }
}
