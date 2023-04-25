import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gps/flutter_gps.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  double latitude = 0;
  double longitude = 0;
  String geocodeStr = '';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await FlutterGps.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;
    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 12),
              Text('Running on: $_platformVersion\n'),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () async {
                  Permission.location.request().then((value) async {
                    final res = await FlutterGps.getGps();
                    debugPrint(res.toString());
                    setState(() {
                      latitude = res.latitude;
                      longitude = res.longitude;
                      decodeGPS();
                    });
                  });
                },
                child: const Text('getGps'),
              ),
              const SizedBox(height: 12),
              Text(
                'latitude: $latitude \nlongitude: $longitude \ngeocodeStr:$geocodeStr',
                style: const TextStyle(fontSize: 15, color: Colors.black),
              ),
              OutlinedButton(
                onPressed: () async {
                  final res = await FlutterGps.geocodeGPS(19.73968, 110.00701, pathHead: 'assets/');
                  if (kDebugMode) {
                    print(res);
                  }
                },
                child: const Text('geocode'),
              ),
              OutlinedButton(
                onPressed: () async {
                  final res = await FlutterGps.getIpAddress(
                    '183.6.24.203',
                    pathHead: 'assets/',
                    hasGetCoordinate: true,
                  );
                  debugPrint(res.toString());
                },
                child: const Text('ipAddr'),
              ),
              OutlinedButton(
                onPressed: () async {
                  var a = -1;
                  for (int i = 0; i < 10; i++) {
                    print('i=$i');
                    if (i % 2 == 0) {
                      print('ii=$i');
                      if (i == 6) {
                        a = i;
                        break;
                      }
                    }
                  }

                  print(a);
                },
                child: const Text('Test'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> decodeGPS() async {
    final res = await FlutterGps.geocodeGPS(latitude, longitude);
    if (kDebugMode) {
      print(res);
    }
    setState(() {
      geocodeStr = res.address;
    });
  }
}
