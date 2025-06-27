import 'UserTestSeriesModel.dart';

class MyTestSeriesListModel {
  final int testId;
  final String? testType;
  final String? testTypeName;
  final int testExamType;
  final String testCategoryId;
  final String? testQuizCategoryId;
  final String testTitle;
  final String testCourse;
  final String testDescription;
  final int testTotalNoOfQues;
  final int testTotalMarks;
  final String testDuration;
  final String? testTime;
  final String? testScheduleDate;
  final String? testAnnouncementDate;
  final String testNegativeMarking;
  final String? testPaperpdf;
  final String? testSolution;
  final String? testImage;
  final int testMarksPerQuestion;
  final String? testAttemptCount;
  final int testStatus;
  final String examPauseTime;
  final String? testMetaTitle;
  final String? testMetaKeyword;
  final String? testMetaDesc;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final UserTestSeriesModel? userTestSeries;

  MyTestSeriesListModel({
    required this.testId,
    this.testType,
    this.testTypeName,
    required this.testExamType,
    required this.testCategoryId,
    this.testQuizCategoryId,
    required this.testTitle,
    required this.testCourse,
    required this.testDescription,
    required this.testTotalNoOfQues,
    required this.testTotalMarks,
    required this.testDuration,
    this.testTime,
    this.testScheduleDate,
    this.testAnnouncementDate,
    required this.testNegativeMarking,
    this.testPaperpdf,
    this.testSolution,
    this.testImage,
    required this.testMarksPerQuestion,
    this.testAttemptCount,
    required this.testStatus,
    required this.examPauseTime,
    this.testMetaTitle,
    this.testMetaKeyword,
    this.testMetaDesc,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.userTestSeries,
  });

  factory MyTestSeriesListModel.fromJson(Map<String, dynamic> json) {
    return MyTestSeriesListModel(
      testId: json['test_id'] ?? 0,
      testType: json['test_type'],
      testTypeName: json['test_type_name'],
      testExamType: json['test_exam_type'] ?? 0,
      testCategoryId: json['test_category_id'] ?? "",
      testQuizCategoryId: json['test_quiz_category_id'],
      testTitle: json['test_title'] ?? "",
      testCourse: json['test_course'] ?? "",
      testDescription: json['test_description'] ?? "",
      testTotalNoOfQues: json['test_total_no_of_ques'] ?? 0,
      testTotalMarks: json['test_total_marks'] ?? 0,
      testDuration: json['test_duration'] ?? "",
      testTime: json['test_time'],
      testScheduleDate: json['test_schedule_date'],
      testAnnouncementDate: json['test_announcement_date'],
      testNegativeMarking: json['test_negative_marking'] ?? "",
      testPaperpdf: json['test_paperpdf'],
      testSolution: json['test_solution'],
      testImage: json['test_image'],
      testMarksPerQuestion: json['test_marks_perquestion'] ?? 0,
      testAttemptCount: json['test_attempt_count'],
      testStatus: json['test_status'] ?? 0,
      examPauseTime: json['exam_pause_time'] ?? "",
      testMetaTitle: json['test_meta_title'],
      testMetaKeyword: json['test_meta_keyword'],
      testMetaDesc: json['test_meta_desc'],
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      deletedAt: json['deleted_at'],
      userTestSeries: json['user_test_series'] != null
          ? UserTestSeriesModel.fromJson(json['user_test_series'])
          : null,
    );
  }
}
