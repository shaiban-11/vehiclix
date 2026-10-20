class HomeStatsModel {
  bool? success;
  String? message;
  HomeStatsData? data;

  HomeStatsModel({this.success, this.message, this.data});

  factory HomeStatsModel.fromJson(Map<String, dynamic> json) {
    return HomeStatsModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? HomeStatsData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data?.toJson()};
  }
}

class HomeStatsData {
  int? today;
  int? completed;
  int? failed;

  HomeStatsData({this.today, this.completed, this.failed});

  factory HomeStatsData.fromJson(Map<String, dynamic> json) {
    return HomeStatsData(
      today: json['today'],
      completed: json['completed'],
      failed: json['failed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'today': today, 'completed': completed, 'failed': failed};
  }
}
