class UserTestSeriesData {
  final int utsId;
  final int utsCourseId;
  final int utsTestId;
  final int utsUserId;
  final int utsStatus;
  final String createdAt;
  final String updatedAt;

  UserTestSeriesData({
    required this.utsId,
    required this.utsCourseId,
    required this.utsTestId,
    required this.utsUserId,
    required this.utsStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserTestSeriesData.fromJson(Map<String, dynamic> json) {
    return UserTestSeriesData(
      utsId: _parseInt(json['uts_id']) ?? 0,
      utsCourseId: _parseInt(json['uts_course_id']) ?? 0,
      utsTestId: _parseInt(json['uts_test_id']) ?? 0,
      utsUserId: _parseInt(json['uts_user_id']) ?? 0,
      utsStatus: _parseInt(json['uts_status']) ?? 0,
      createdAt: json['created_at']?.toString() ?? "",
      updatedAt: json['updated_at']?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uts_id': utsId,
      'uts_course_id': utsCourseId,
      'uts_test_id': utsTestId,
      'uts_user_id': utsUserId,
      'uts_status': utsStatus,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}



/*
class UserTestSeriesData {
  int? utsId;
  int? utsCourseId;
  int? utsTestId;
  int? utsUserId;
  int? utsStatus;
  String? createdAt;
  String? updatedAt;

  UserTestSeriesData({
    this.utsId,
    this.utsCourseId,
    this.utsTestId,
    this.utsUserId,
    this.utsStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory UserTestSeriesData.fromJson(Map<String, dynamic> json) {
    return UserTestSeriesData(
      utsId: json['uts_id'],
      utsCourseId: json['uts_course_id'],
      utsTestId: json['uts_test_id'],
      utsUserId: json['uts_user_id'],
      utsStatus: json['uts_status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uts_id'] = utsId;
    data['uts_course_id'] = utsCourseId;
    data['uts_test_id'] = utsTestId;
    data['uts_user_id'] = utsUserId;
    data['uts_status'] = utsStatus;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}*/
