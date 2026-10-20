class CountrySpecModel {
  bool? success;
  List<CountrySpecData>? data;

  CountrySpecModel({this.success, this.data});

  factory CountrySpecModel.fromJson(Map<String, dynamic> json) {
    return CountrySpecModel(
      success: json['success'],
      data: (json['data'] as List?)
          ?.map(
            (item) => CountrySpecData.fromJson(item as Map<String, dynamic>),
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
  // Add country specification fields here
  // when the API returns a non-empty data list.

  CountrySpecData();

  factory CountrySpecData.fromJson(Map<String, dynamic> json) {
    return CountrySpecData();
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}
