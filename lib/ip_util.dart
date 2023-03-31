import 'common_util.dart';
import 'geocode_entity.dart';

String _pathHead = 'assets/';

class IpUtil {
  IpUtil._();

  static Future<GeocodeEntity> getIpAddress(String ip, {String pathHead = 'assets/'}) async {
    try {
      final id = await _getGeocodeByIp(ip, pathHead: pathHead);
      return _getGeocode(id);
    } catch (e) {
      return const GeocodeEntity(province: '', city: '', district: '', provinceId: '', cityId: '', districtId: '');
    }
  }

  static Future<GeocodeEntity> _getGeocode(String id) async {
    var data = const GeocodeEntity(province: '', city: '', district: '', provinceId: '', cityId: '', districtId: '');
    if (id.isNotEmpty) {
      final jsList = await CommonUtil.getAssetJsonList('${_pathHead}areaList/index.json');
      for (final provinceJs in jsList) {
        if (provinceJs is Map) {
          // 省
          final provinceId = provinceJs['id'] != null ? provinceJs['id'].toString() : '';
          final provinceName = provinceJs['name'] != null ? provinceJs['name'].toString() : '';
          if (provinceId.isNotEmpty && provinceId == id) {
            data = data.copyWith(province: provinceName, provinceId: provinceId);
            return data;
          }
          // 市
          if (provinceJs['children'] is List) {
            final cityList = provinceJs['children'] as List;
            for (final cityJs in cityList) {
              if (cityJs is Map) {
                // 省
                final cityId = cityJs['id'] != null ? cityJs['id'].toString() : '';
                final cityName = cityJs['name'] != null ? cityJs['name'].toString() : '';
                if (cityId.isNotEmpty && cityId == id) {
                  data = data.copyWith(province: provinceName, provinceId: provinceId, cityId: cityId, city: cityName);
                  return data;
                }
                if (cityJs['children'] is List) {
                  final districtList = cityJs['children'] as List;
                  for (final districtJs in districtList) {
                    // 区
                    final districtId = districtJs['id'] != null ? districtJs['id'].toString() : '';
                    final districtName = districtJs['name'] != null ? districtJs['name'].toString() : '';

                    if (districtId.isNotEmpty && districtId == id) {
                      data = data.copyWith(
                        provinceId: provinceId,
                        province: provinceName,
                        city: cityName,
                        cityId: cityId,
                        districtId: districtId,
                        district: districtName,
                      );
                      return data;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    return data;
  }

  /// 获取ip对应的地理编码
  static Future<String> _getGeocodeByIp(String ip, {String pathHead = 'assets/'}) async {
    final ipSlices = _getIpSlices(ip);
    if (ipSlices.isEmpty) {
      return '';
    }
    final jsList = await CommonUtil.getAssetJsonList('${_pathHead}ip/${ipSlices[0]}.${ipSlices[1]}.json');
    if (jsList.isEmpty) {
      return '';
    }
    for (final js in jsList) {
      if (js is Map) {
        final start = js['start'].toString();
        final end = js['end'].toString();
        final startSlices = _getIpSlices(start);
        final endSlices = _getIpSlices(end);
        if (startSlices.isNotEmpty && endSlices.isNotEmpty) {
          if (startSlices[2] <= ipSlices[2] &&
              endSlices[2] >= ipSlices[2] &&
              startSlices[3] <= ipSlices[3] &&
              endSlices[3] >= ipSlices[3]) {
            final id = js['id'].toString();
            return id;
          }
        }
      }
    }
    return '';
  }

  /// 获取ip区段int数组
  static List<int> _getIpSlices(String ip) {
    if (ip.isEmpty) {
      return [];
    }
    final ipList = ip.split('.');
    if (ipList.length < 4) {
      return [];
    }
    const int flag = 1000;
    final ipSlices =
        ipList.map((e) => int.tryParse(e) ?? flag).where((element) => element >= 0 && element <= 255).toList();
    if (ipSlices.length == 4) {
      return ipSlices;
    }
    return [];
  }
}
