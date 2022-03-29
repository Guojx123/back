import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SpUtil {
  SharedPreferences? preferences;

  static SpUtil? _instance;

  SpUtil._() {
    _init();
  }

  static SpUtil? getInstance() {
    _instance ??= SpUtil._();
    return _instance;
  }

  Future<void> _init() async {
    preferences ??= await SharedPreferences.getInstance();
  }

  /// 防止在使用的时候还没初始化 SharedPreferences，进行预初始化
  static Future<SpUtil?> preInit() async {
    if (_instance == null) {
      // 先初始化 SharedPreferences
      var preferences = await SharedPreferences.getInstance();
      // 再初始化 SpUtil
      _instance = SpUtil._pre(preferences);
    }
    return _instance;
  }

  /// 命名构造函数
  SpUtil._pre(this.preferences);

  /// put object list.
  Future<bool> putObjectList(String key, List<Object> list) {
    List<String>? _dataList = list.map((value) {
      return json.encode(value);
    }).toList();
    return preferences!.setStringList(key, _dataList);
  }

  /// get obj list.
  List<T> getObjList<T>(String key, T Function(Map v) f, {List<T> defValue = const []}) {
    List<Map> dataList = getObjectList(key) ?? [];
    List<T>? list = dataList.map((value) {
      return f(value);
    }).toList();
    return list;
  }

  /// get object list.
  List<Map>? getObjectList(String key) {
    List<String>? dataLis = preferences!.getStringList(key);
    return dataLis?.map((value) {
      Map _dataMap = json.decode(value);
      return _dataMap;
    }).toList();
  }

  /// get string.
  String getString(String key, {String defValue = ''}) => preferences!.getString(key) ?? defValue;

  /// put string.
  Future<bool> putString(String key, String value) => preferences!.setString(key, value);

  /// get bool.
  bool getBool(String key, {bool defValue = false}) => preferences!.getBool(key) ?? defValue;

  /// put bool.
  Future<bool> putBool(String key, bool value) => preferences!.setBool(key, value);

  /// get int.
  int getInt(String key, {int defValue = 0}) => preferences!.getInt(key) ?? defValue;

  /// put int.
  Future<bool> putInt(String key, int value) => preferences!.setInt(key, value);

  /// get double.
  double getDouble(String key, {double defValue = 0.0}) => preferences!.getDouble(key) ?? defValue;

  /// put double.
  Future<bool> putDouble(String key, double value) => preferences!.setDouble(key, value);

  /// get string list.
  List<String> getStringList(
    String key, {
    List<String> defValue = const [],
  }) =>
      preferences!.getStringList(key) ?? defValue;

  /// put string list.
  Future<bool> putStringList(
    String key,
    List<String> value,
  ) =>
      preferences!.setStringList(key, value);

  /// get dynamic.
  dynamic getDynamic(String key, {Object? defValue}) => preferences!.get(key) ?? defValue;

  /// have key.
  bool haveKey(String key) => preferences!.getKeys().contains(key);

  /// get keys.
  Set<String> getKeys() => preferences!.getKeys();

  /// remove.
  Future<bool> remove(String key) => preferences!.remove(key);

  /// clear.
  Future<bool> clear() => preferences!.clear();
}
