class UserTestSeriesModel {
  final int utsId;
  final String utsCourseId;
  final int utsTestId;
  final int utsUserId;
  final int utsStatus;
  final String? utsDataJson;
  final String createdAt;
  final String updatedAt;

  UserTestSeriesModel({
    required this.utsId,
    required this.utsCourseId,
    required this.utsTestId,
    required this.utsUserId,
    required this.utsStatus,
    this.utsDataJson,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserTestSeriesModel.fromJson(Map<String, dynamic> json) {
    return UserTestSeriesModel(
      utsId: json['uts_id'] ?? 0,
      utsCourseId: json['uts_course_id'] ?? "",
      utsTestId: json['uts_test_id'] ?? 0,
      utsUserId: json['uts_user_id'] ?? 0,
      utsStatus: json['uts_status'] ?? 2,
      utsDataJson: json['uts_data_json'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
