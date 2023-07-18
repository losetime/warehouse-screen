import 'package:flutter/material.dart';

//with ChangeNotifier 混入ChangeNotifier的意思是不做权限管理，每个类都可以拿到
class HomeProvider with ChangeNotifier {
  Map socketInfo = {};

  setSocketInfo(Map val) {
    socketInfo = val;
    notifyListeners(); //广播通知
  }
}

class DomainProvider with ChangeNotifier {
  String domain = '';

  setDomain(String val) {
    domain = val;
    notifyListeners(); //广播通知
  }
}

class BroadcastProvider with ChangeNotifier {
  Map broadcastInfo = {};

  setBroadcastInfo(Map val) {
    broadcastInfo = val;
    notifyListeners(); //广播通知
  }
}
