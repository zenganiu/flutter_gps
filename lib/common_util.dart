import 'dart:convert';

import 'package:flutter/services.dart';

class CommonUtil {
  CommonUtil._();

  /// 获取asset中的jsonMap数据
  static Future<List<dynamic>> getAssetJsonList(String path) async {
    final js = await getAssetJson(path);
    if (js is List) {
      return js;
    }
    return [];
  }

  /// 获取asset中的jsonMap数据
  static Future<Map<dynamic, dynamic>> getAssetJsonMap(String path) async {
    final js = await getAssetJson(path);
    if (js is Map) {
      return js;
    }
    return {};
  }

  /// 获取asset中的json数据
  static Future<dynamic> getAssetJson(String path) async {
    final obj = await rootBundle.load(path);
    final data = obj.buffer.asUint8List();
    final jsStr = utf8.decode(data);
    final js = jsonDecode(jsStr);
    return js;
  }
}
