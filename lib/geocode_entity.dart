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

  /// 地址
  String get address {
    final res = [province, city, district].where((element) => element.isNotEmpty).join('-');
    return res;
  }

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
