library flutter_gps;

export 'flutter_gps.dart';
export 'gps_entity.dart';
export 'common_util.dart';
export 'geocode_entity.dart';

import 'package:flutter_gps/geocode_entity.dart';
import 'package:flutter_gps/geocode_util.dart';
import 'package:flutter_gps/ip_util.dart';
import 'package:flutter_gps/permission_entity.dart';

import 'flutter_gps_platform_interface.dart';
import 'gps_entity.dart';

class FlutterGps {
  FlutterGps._();

  ///
  static Future<String?> getPlatformVersion() {
    return FlutterGpsPlatform.instance.getPlatformVersion();
  }

  /// gps获取经纬度
  static Future<GpsEntity> getGps() async {
    final json = await FlutterGpsPlatform.instance.getGps();
    final data = GpsEntity.fromMap(json);
    return data;
  }

  /// 经纬度地理反编码
  static Future<GeocodeEntity> geocodeGPS(double lat, double lon, {String pathHead = 'assets/'}) async {
    final res = await GeocodeUtil.geocodeGPS(lat, lon, pathHead: pathHead);
    return res;
  }

  /// 获取ip所在地理信息
  ///
  /// [ip] ip地址
  /// [pathHead] 资源头目录
  /// [hasGetCoordinate] 是否获取经纬度
  static Future<GeocodeEntity> getIpAddress(
    String ip, {
    String pathHead = 'assets/',
    bool hasGetCoordinate = false,
  }) async {
    final res = await IpUtil.getIpAddress(ip, pathHead: pathHead, hasGetCoordinate: hasGetCoordinate);
    return res;
  }

  @Deprecated('推荐使用`permission_handler`插件来获取权限')
  static Future<PermissionEntity> requestPermission() async {
    final json = await FlutterGpsPlatform.instance.requestPermission();
    final data = PermissionEntity.fromMap(json);
    return data;
  }
}
