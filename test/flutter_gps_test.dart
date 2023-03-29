import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gps/flutter_gps.dart';
import 'package:flutter_gps/flutter_gps_platform_interface.dart';
import 'package:flutter_gps/flutter_gps_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockFlutterGpsPlatform
//     with MockPlatformInterfaceMixin
//     implements FlutterGpsPlatform {
//
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

void main() {
  final FlutterGpsPlatform initialPlatform = FlutterGpsPlatform.instance;

  test('$MethodChannelFlutterGps is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterGps>());
  });

  // test('getPlatformVersion', () async {
  //   FlutterGps flutterGpsPlugin = FlutterGps();
  //   MockFlutterGpsPlatform fakePlatform = MockFlutterGpsPlatform();
  //   FlutterGpsPlatform.instance = fakePlatform;
  //
  //   expect(await flutterGpsPlugin.getPlatformVersion(), '42');
  // });
}
