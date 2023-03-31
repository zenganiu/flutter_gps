# flutter_gps
[![License](https://img.shields.io/github/license/mashape/apistatus.svg)](https://github.com/zenganiu/flutter_gps)
## **Flutter定位插件**
* 现如今几乎每一个 App 都存在定位的逻辑，方便更好的推荐产品或服务，获取当前设备的经纬度、所在城市几乎是必备的功能了！iOS定位经纬度及反向地理编码原生均能很好实现。然而Android由于系统原因，反向地理编码获取地址信息需要使用谷歌服务。大多需要依赖高德/百度三方定位库实现该功能。
* 本项目是Flutter定位插件，支持获取经纬度及经纬度、ip反向地理编码获取地址信息(省、市、区)，，纯原生获取GPS定位信息。反向地理编码获取地址信息均来自本地，没有并发限制、次数限制且无收费。 
* 这里尤其感谢[pikaz-18](https://github.com/pikaz-18)大佬的数据源。js定位大家可使用[pikaz-location](https://github.com/pikaz-18/pikaz-location)。
* 请大佬们多多指教，给个 Star，你的支持就是我不断前进的动力，谢谢。

## 特性
* 单次获取经纬度信息
* 经纬度、ip反向地理编码获取地址信息(省、市、区)

## 安装
在 `pubspec.yaml` 中添加
```yaml
dependencies:
  # 最新版本
  flutter_dmcb_alibc:
    git: https://github.com/zenganiu/flutter_gps.git
```

## Android端配置

在`AndroidManifest.xml`文件中添加定位权限
```xml
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
```
## iOS端配置
在`info.plist`文件中添加定位权限
```xml 
<!-- 在使用期间访问位置 -->
<key>NSLocationWhenInUseUsageDescription</key>
<string>App需要您的同意, APP才能在使用期间访问位置</string>
```
## 使用
详细使用请参考项目`example`用例，下面只列出常用方法
```dart
import 'package:flutter_gps/gps.dart';
import 'package:permission_handler/permission_handler.dart';

// 获取GPS定位经纬度
final res1 = await FlutterGps().getGps();

// 经纬度反向地理编码获取地址信息(省、市、区)
final res2 = await GeocodeUtil.geocodeGPS(res1.latitude, res1.longitude);

// 经纬度反向地理编码获取地址信息(省、市、区)
 final res3 = await IpUtil.getIpAddress('183.6.24.203');

```
