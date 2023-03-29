import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_gps_method_channel.dart';

abstract class FlutterGpsPlatform extends PlatformInterface {
  /// Constructs a FlutterGpsPlatform.
  FlutterGpsPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterGpsPlatform _instance = MethodChannelFlutterGps();

  /// The default instance of [FlutterGpsPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterGps].
  static FlutterGpsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterGpsPlatform] when
  /// they register themselves.
  static set instance(FlutterGpsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<Map<dynamic, dynamic>> getGps() {
    throw UnimplementedError('getGps() has not been implemented.');
  }
}
