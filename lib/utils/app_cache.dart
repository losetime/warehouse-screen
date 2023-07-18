import 'package:shared_preferences/shared_preferences.dart';
import '../enums/commonEnum.dart';

class AppCache {
  final SharedPreferences sharedPreferences;

  AppCache._({required this.sharedPreferences});

  factory AppCache.create({
    required SharedPreferences sharedPreferences,
  }) =>
      AppCache._(
        sharedPreferences: sharedPreferences,
      );

  //  缓存类采取单例模式
  static AppCache? _instance;

  //  一定要在main里面初始化
  static Future<void> init() async {
    _instance ??= AppCache.create(
      sharedPreferences: await SharedPreferences.getInstance(),
    );
  }

  // 简化获取工具类的缓存实例，以便在下方封装一些方法
  static SharedPreferences get _pre => _instance!.sharedPreferences;

  // ---------------------------------- ip地址 -----------------------------------------

  //  封装设置主机的方法
  static Future<bool> setHost(String host) async {
    return await _pre.setString(CacheKey.host, host);
  }

  //  封装清除主机的方法
  static Future<bool> cleanHost() async {
    return await _pre.setString(CacheKey.host, '');
  }

  //  封装获取主机的方法
  static String? get host => _pre.getString(CacheKey.host);
}
