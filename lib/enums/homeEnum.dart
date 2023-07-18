List<String> freightSpaceHeader = <String>[
  '仓位',
  '工器具总数量',
  '工器具在位数量',
  '工器具出库数量',
  '仓位状态',
  '放置状态'
];

List<String> freightSpaceRowKey = [
  'name',
  'toolExpectSum',
  'toolInSum',
  'toolLeaveSum',
  'status',
  'toolIncorrectSum',
];

List<String> toolHeader = [
  '名称',
  '工器具编号',
  '类别',
  '标签',
  '型号',
  '当前仓位',
  '正确仓位',
];

List<String> toolRowKey = [
  'name',
  'codeNumber',
  'toolTypeName',
  'toolTagName',
  'id',
  'currentPosition',
  'expectPosition',
];

List<String> toolReturnedHistoryHeader = ['姓名', '工器具名称', '归还仓位'];

List<String> toolReturnedHistoryKey = [
  'userName',
  'toolName',
  'expectPosition',
];

List<String> toolReturnedRealTimeHeader = ['工器具名称', '正确仓位', '错误仓位'];

List<String> toolReturnedRealTimeKey = [
  'toolName',
  'expectPosition',
  'currentPosition',
];

List testTableData = [
  {
    "userName": '测试数据1',
    "currentPosition": '测试数据1',
    "expectPosition": '测试数据1',
    "toolName": '锤子',
  },
  {
    "userName": '测试数据2',
    "currentPosition": '测试数据2',
    "expectPosition": '测试数据2',
    "toolName": '锤子',
  },
  {
    "userName": '测试数据3',
    "currentPosition": '测试数据3',
    "expectPosition": '测试数据3',
    "toolName": '锤子',
  },
];
