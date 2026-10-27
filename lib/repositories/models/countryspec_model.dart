class CountrySpecModel {
  final bool? success;
  final List<CountrySpecData>? data;

  const CountrySpecModel({this.success, this.data});

  factory CountrySpecModel.fromJson(Map<String, dynamic> json) {
    return CountrySpecModel(
      success: json['success'] as bool?,
      data: (json['data'] as List?)
          ?.whereType<Map>()
          .map(
            (item) => CountrySpecData.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.map((item) => item.toJson()).toList(),
    };
  }
}

class CountrySpecData {
  final String? id;
  final String? name;
  final String? code;
  final String? description;

  const CountrySpecData({this.id, this.name, this.code, this.description});

  factory CountrySpecData.fromJson(Map<String, dynamic> json) {
    String? readString(List<String> keys) {
      for (final key in keys) {
        final value = json[key];

        if (value != null && value.toString().trim().isNotEmpty) {
          return value.toString().trim();
        }
      }

      return null;
    }

    return CountrySpecData(
      id: readString(['_id', 'id', 'country_spec_id', 'countrySpecId']),
      name: readString([
        'name',
        'country_spec',
        'country_spec_name',
        'countrySpecName',
        'title',
        'label',
      ]),
      code: readString(['code', 'country_code', 'countryCode']),
      description: readString(['description', 'details']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'code': code, 'description': description};
  }
}
