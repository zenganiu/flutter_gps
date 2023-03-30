import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_gps/common_util.dart';
import 'package:flutter_gps/flutter_gps.dart';
import 'package:flutter_gps/geocode_util.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:maps_toolkit/maps_toolkit.dart';

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
  final _flutterGpsPlugin = FlutterGps();

  double latitude = 0;
  double longitude = 0;
  String geocodeStr = '';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _flutterGpsPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
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
                    final res = await FlutterGps().getGps();
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
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> decodeGPS() async {
    final res = await GeocodeUtil.geocodeGPS(latitude, longitude);
    print(res);
    setState(() {
      geocodeStr = '${res.province}-${res.city}-${res.district}';
    });
  }
}
