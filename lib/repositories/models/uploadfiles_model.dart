class FileUploadModel {
  bool? success;
  String? message;
  FileUploadData? data;

  FileUploadModel({this.success, this.message, this.data});

  factory FileUploadModel.fromJson(Map<String, dynamic> json) {
    return FileUploadModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? FileUploadData.fromJson(Map<String, dynamic>.from(json['data']))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data?.toJson()};
  }
}

class FileUploadData {
  String? url;

  FileUploadData({this.url});

  factory FileUploadData.fromJson(Map<String, dynamic> json) {
    return FileUploadData(url: json['url']);
  }

  Map<String, dynamic> toJson() {
    return {'url': url};
  }
}
