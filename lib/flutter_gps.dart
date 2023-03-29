import 'package:flutter_gps/permission_entity.dart';

import 'flutter_gps_platform_interface.dart';
import 'gps_entity.dart';

class FlutterGps {
  Future<String?> getPlatformVersion() {
    return FlutterGpsPlatform.instance.getPlatformVersion();
  }

  Future<GpsEntity> getGps() async {
    final json = await FlutterGpsPlatform.instance.getGps();
    final data = GpsEntity.fromMap(json);
    return data;
  }

  Future<PermissionEntity> requestPermission() async {
    final json = await FlutterGpsPlatform.instance.requestPermission();
    final data = PermissionEntity.fromMap(json);
    return data;
  }
}
