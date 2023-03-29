import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_gps_platform_interface.dart';

/// An implementation of [FlutterGpsPlatform] that uses method channels.
class MethodChannelFlutterGps extends FlutterGpsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_gps');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<Map<dynamic, dynamic>> getGps() async {
    final res = await methodChannel.invokeMethod<Map<dynamic, dynamic>>('gps');
    return res ?? {};
  }
}
