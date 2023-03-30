import 'package:maps_toolkit/maps_toolkit.dart';

import 'common_util.dart';

String _pathHead = 'assets/';

class GeocodeUtil {
  GeocodeUtil._();

  static Future<GeocodeEntity> geocodeGPS(double lat, double lon, {String pathHead = 'assets/'}) async {
    _pathHead = pathHead;
    var data = const GeocodeEntity(province: '', city: '', district: '', provinceId: '', cityId: '', districtId: '');
    final province = await _getProvince(lat, lon);
    data = data.copyWith(province: province.name, provinceId: province.id);

    final city = await _getCity(lat, lon, data.provinceId);
    data = data.copyWith(city: city.name, cityId: city.id);

    final district = await _getDistrict(lat, lon, data.cityId);
    data = data.copyWith(district: district.name, districtId: district.id);

    return data;
  }

  static Future<ParseResult> _getDistrict(double lat, double lon, String id) async {
    if (id.isEmpty) {
      return const ParseResult(name: '', id: '');
    }
    final jsList = await CommonUtil.getAssetJsonList('${_pathHead}district/$id.json');
    if (jsList.isEmpty) {
      return const ParseResult(name: '', id: '');
    }
    for (final js in jsList) {
      if (js is Map) {
        final status = GeocodeUtil.containsLocation(LatLng(lat, lon), js['polygon']);
        if (status) {
          final name = js['name'] != null ? js['name'].toString() : '';
          final id = js['id'] != null ? js['id'].toString() : '';
          return ParseResult(name: name, id: id);
        }
      }
    }
    return const ParseResult(name: '', id: '');
  }

  /// 获取城市
  static Future<ParseResult> _getCity(double lat, double lon, String id) async {
    if (id.isEmpty) {
      return const ParseResult(name: '', id: '');
    }
    final jsList = await CommonUtil.getAssetJsonList('${_pathHead}city/$id.json');
    if (jsList.isEmpty) {
      return const ParseResult(name: '', id: '');
    }
    for (final js in jsList) {
      if (js is Map) {
        final status = GeocodeUtil.containsLocation(LatLng(lat, lon), js['polygon']);
        if (status) {
          final name = js['name'] != null ? js['name'].toString() : '';
          final id = js['id'] != null ? js['id'].toString() : '';
          return ParseResult(name: name, id: id);
        }
      }
    }
    return const ParseResult(name: '', id: '');
  }

  /// 获取省
  static Future<ParseResult> _getProvince(double lat, double lon) async {
    final map = await CommonUtil.getAssetJsonList('${_pathHead}province/short.json');
    List<String> ids = [];
    for (final item in map) {
      if (item is Map) {
        final status = GeocodeUtil.containsLocation(LatLng(lat, lon), item['polygon']);
        if (status) {
          ids.add(item['id'].toString());
        }
      }
    }

    if (ids.isEmpty) {
      return const ParseResult(name: '', id: '');
    }
    if (ids.length == 1) {
      final pMap = await CommonUtil.getAssetJsonMap('${_pathHead}province/${ids[0]}.json');
      final name = pMap['name'] != null ? pMap['name'].toString() : '';
      return ParseResult(name: name, id: ids[0]);
    }

    for (final id in ids) {
      final iMap = await CommonUtil.getAssetJsonMap('${_pathHead}province/$id.json');
      final status = containsLocation(LatLng(lat, lon), iMap['polygon']);
      if (status) {
        final name = iMap['name'] != null ? iMap['name'].toString() : '';
        return ParseResult(name: name, id: id);
      }
    }
    return const ParseResult(name: '', id: '');
  }

  /// 判断点是否在多边形内
  static bool containsLocation(LatLng point, dynamic polygon) {
    if (polygon is List) {
      for (final poly in polygon) {
        if (poly is List) {
          List<double> p = [];
          for (final e in poly) {
            final v = num.tryParse(e.toString())?.toDouble();
            if (v != null) {
              p.add(v);
            }
          }
          final len = (p.length / 2).floor();
          final ply = List.generate(len, (index) => index).map((e) => LatLng(p[2 * e + 1], p[2 * e])).toList();
          final status = PolygonUtil.containsLocation(point, ply, true);
          if (status) return true;
        }
      }
    }
    return false;
  }
}

class ParseResult {
  final String name;
  final String id;
  const ParseResult({
    required this.name,
    required this.id,
  });
}

/// 地理编码模型
class GeocodeEntity {
  /// 省
  final String province;

  ///
  final String provinceId;

  /// 市
  final String city;

  ///
  final String cityId;

  /// 区
  final String district;

  ///
  final String districtId;

//<editor-fold desc="Data Methods">
  const GeocodeEntity({
    required this.province,
    required this.provinceId,
    required this.city,
    required this.cityId,
    required this.district,
    required this.districtId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GeocodeEntity &&
          runtimeType == other.runtimeType &&
          province == other.province &&
          provinceId == other.provinceId &&
          city == other.city &&
          cityId == other.cityId &&
          district == other.district &&
          districtId == other.districtId);

  @override
  int get hashCode =>
      province.hashCode ^
      provinceId.hashCode ^
      city.hashCode ^
      cityId.hashCode ^
      district.hashCode ^
      districtId.hashCode;

  @override
  String toString() {
    return 'GeocodeEntity{ province: $province, provinceId: $provinceId, city: $city, cityId: $cityId, district: $district, districtId: $districtId,}';
  }

  GeocodeEntity copyWith({
    String? province,
    String? provinceId,
    String? city,
    String? cityId,
    String? district,
    String? districtId,
  }) {
    return GeocodeEntity(
      province: province ?? this.province,
      provinceId: provinceId ?? this.provinceId,
      city: city ?? this.city,
      cityId: cityId ?? this.cityId,
      district: district ?? this.district,
      districtId: districtId ?? this.districtId,
    );
  }

//</editor-fold>
}
