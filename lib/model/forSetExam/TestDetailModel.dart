import 'CsTestSubjectDetails.dart';

class TestDetailModel {
  int testId;
  String testType;
  String testTypeName;
  int testExamType;
  String testCategoryId;
  String testQuizCategoryId;
  String testTitle;
  String testCourse;
  String testDescription;
  int testTotalNoOfQues;
  int testTotalMarks;
  String testDuration;
  String testTime;
  String testScheduleDate;
  String testAnnouncementDate;
  String testNegativeMarking;
  String testPaperpdf;
  String testSolution;
  String testImage;
  int testMarksPerquestion;
  String testAttemptCount;
  int testStatus;
  String examPauseTime;
  String testMetaTitle;
  String testMetaKeyword;
  String testMetaDesc;
  String createdAt;
  String updatedAt;
  String deletedAt;
  List<CsTestSubjectDetails> hasManyCsTestSubjectDetails;

  TestDetailModel({
    required this.testId,
    required this.testType,
    required this.testTypeName,
    required this.testExamType,
    required this.testCategoryId,
    required this.testQuizCategoryId,
    required this.testTitle,
    required this.testCourse,
    required this.testDescription,
    required this.testTotalNoOfQues,
    required this.testTotalMarks,
    required this.testDuration,
    required this.testTime,
    required this.testScheduleDate,
    required this.testAnnouncementDate,
    required this.testNegativeMarking,
    required this.testPaperpdf,
    required this.testSolution,
    required this.testImage,
    required this.testMarksPerquestion,
    required this.testAttemptCount,
    required this.testStatus,
    required this.examPauseTime,
    required this.testMetaTitle,
    required this.testMetaKeyword,
    required this.testMetaDesc,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.hasManyCsTestSubjectDetails,
  });

  factory TestDetailModel.fromJson(Map<String, dynamic> json) {
    return TestDetailModel(
      testId: _parseInt(json['test_id']) ?? 0,
      testType: json['test_type']?.toString() ?? "",
      testTypeName: json['test_type_name']?.toString() ?? "",
      testExamType: _parseInt(json['test_exam_type']) ?? 0,
      testCategoryId: json['test_category_id']?.toString() ?? "",
      testQuizCategoryId: json['test_quiz_category_id']?.toString() ?? "",
      testTitle: json['test_title']?.toString() ?? "",
      testCourse: json['test_course']?.toString() ?? "",
      testDescription: json['test_description']?.toString() ?? "",
      testTotalNoOfQues: _parseInt(json['test_total_no_of_ques']) ?? 0,
      testTotalMarks: _parseInt(json['test_total_marks']) ?? 0,
      testDuration: json['test_duration']?.toString() ?? "",
      testTime: json['test_time']?.toString() ?? "",
      testScheduleDate: json['test_schedule_date']?.toString() ?? "",
      testAnnouncementDate: json['test_announcement_date']?.toString() ?? "",
      testNegativeMarking: json['test_negative_marking']?.toString() ?? "",
      testPaperpdf: json['test_paperpdf']?.toString() ?? "",
      testSolution: json['test_solution']?.toString() ?? "",
      testImage: json['test_image']?.toString() ?? "",
      testMarksPerquestion: _parseInt(json['test_marks_perquestion']) ?? 0,
      testAttemptCount: json['test_attempt_count']?.toString() ?? "",
      testStatus: _parseInt(json['test_status']) ?? 0,
      examPauseTime: json['exam_pause_time']?.toString() ?? "",
      testMetaTitle: json['test_meta_title']?.toString() ?? "",
      testMetaKeyword: json['test_meta_keyword']?.toString() ?? "",
      testMetaDesc: json['test_meta_desc']?.toString() ?? "",
      createdAt: json['created_at']?.toString() ?? "",
      updatedAt: json['updated_at']?.toString() ?? "",
      deletedAt: json['deleted_at']?.toString() ?? "",
      hasManyCsTestSubjectDetails: json['has_many_cs_test_subject_details'] != null
          ? (json['has_many_cs_test_subject_details'] as List)
          .map((e) => CsTestSubjectDetails.fromJson(e))
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'test_id': testId,
      'test_type': testType,
      'test_type_name': testTypeName,
      'test_exam_type': testExamType,
      'test_category_id': testCategoryId,
      'test_quiz_category_id': testQuizCategoryId,
      'test_title': testTitle,
      'test_course': testCourse,
      'test_description': testDescription,
      'test_total_no_of_ques': testTotalNoOfQues,
      'test_total_marks': testTotalMarks,
      'test_duration': testDuration,
      'test_time': testTime,
      'test_schedule_date': testScheduleDate,
      'test_announcement_date': testAnnouncementDate,
      'test_negative_marking': testNegativeMarking,
      'test_paperpdf': testPaperpdf,
      'test_solution': testSolution,
      'test_image': testImage,
      'test_marks_perquestion': testMarksPerquestion,
      'test_attempt_count': testAttemptCount,
      'test_status': testStatus,
      'exam_pause_time': examPauseTime,
      'test_meta_title': testMetaTitle,
      'test_meta_keyword': testMetaKeyword,
      'test_meta_desc': testMetaDesc,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'has_many_cs_test_subject_details':
      hasManyCsTestSubjectDetails.map((e) => e.toJson()).toList(),
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
import 'CsTestSubjectDetails.dart';

class TestDetailModel {
  int? testId;
  dynamic testType;
  dynamic testTypeName;
  int? testExamType;
  String? testCategoryId;
  dynamic testQuizCategoryId;
  String? testTitle;
  String? testCourse;
  String? testDescription;
  int? testTotalNoOfQues;
  int? testTotalMarks;
  String? testDuration;
  dynamic testTime;
  dynamic testScheduleDate;
  dynamic testAnnouncementDate;
  String? testNegativeMarking;
  dynamic testPaperpdf;
  dynamic testSolution;
  dynamic testImage;
  int? testMarksPerquestion;
  dynamic testAttemptCount;
  int? testStatus;
  String? examPauseTime;
  String? testMetaTitle;
  dynamic testMetaKeyword;
  dynamic testMetaDesc;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  List<CsTestSubjectDetails>? hasManyCsTestSubjectDetails;

  TestDetailModel({
    this.testId,
    this.testType,
    this.testTypeName,
    this.testExamType,
    this.testCategoryId,
    this.testQuizCategoryId,
    this.testTitle,
    this.testCourse,
    this.testDescription,
    this.testTotalNoOfQues,
    this.testTotalMarks,
    this.testDuration,
    this.testTime,
    this.testScheduleDate,
    this.testAnnouncementDate,
    this.testNegativeMarking,
    this.testPaperpdf,
    this.testSolution,
    this.testImage,
    this.testMarksPerquestion,
    this.testAttemptCount,
    this.testStatus,
    this.examPauseTime,
    this.testMetaTitle,
    this.testMetaKeyword,
    this.testMetaDesc,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.hasManyCsTestSubjectDetails,
  });

  factory TestDetailModel.fromJson(Map<String, dynamic> json) {
    return TestDetailModel(
      testId: json['test_id'],
      testType: json['test_type'],
      testTypeName: json['test_type_name'],
      testExamType: json['test_exam_type'],
      testCategoryId: json['test_category_id'],
      testQuizCategoryId: json['test_quiz_category_id'],
      testTitle: json['test_title'],
      testCourse: json['test_course'],
      testDescription: json['test_description'],
      testTotalNoOfQues: json['test_total_no_of_ques'],
      testTotalMarks: json['test_total_marks'],
      testDuration: json['test_duration'],
      testTime: json['test_time'],
      testScheduleDate: json['test_schedule_date'],
      testAnnouncementDate: json['test_announcement_date'],
      testNegativeMarking: json['test_negative_marking'],
      testPaperpdf: json['test_paperpdf'],
      testSolution: json['test_solution'],
      testImage: json['test_image'],
      testMarksPerquestion: json['test_marks_perquestion'],
      testAttemptCount: json['test_attempt_count'],
      testStatus: json['test_status'],
      examPauseTime: json['exam_pause_time'],
      testMetaTitle: json['test_meta_title'],
      testMetaKeyword: json['test_meta_keyword'],
      testMetaDesc: json['test_meta_desc'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      hasManyCsTestSubjectDetails: json['has_many_cs_test_subject_details'] != null
          ? (json['has_many_cs_test_subject_details'] as List)
          .map((i) => CsTestSubjectDetails.fromJson(i))
          .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['test_id'] = testId;
    data['test_type'] = testType;
    data['test_type_name'] = testTypeName;
    data['test_exam_type'] = testExamType;
    data['test_category_id'] = testCategoryId;
    data['test_quiz_category_id'] = testQuizCategoryId;
    data['test_title'] = testTitle;
    data['test_course'] = testCourse;
    data['test_description'] = testDescription;
    data['test_total_no_of_ques'] = testTotalNoOfQues;
    data['test_total_marks'] = testTotalMarks;
    data['test_duration'] = testDuration;
    data['test_time'] = testTime;
    data['test_schedule_date'] = testScheduleDate;
    data['test_announcement_date'] = testAnnouncementDate;
    data['test_negative_marking'] = testNegativeMarking;
    data['test_paperpdf'] = testPaperpdf;
    data['test_solution'] = testSolution;
    data['test_image'] = testImage;
    data['test_marks_perquestion'] = testMarksPerquestion;
    data['test_attempt_count'] = testAttemptCount;
    data['test_status'] = testStatus;
    data['exam_pause_time'] = examPauseTime;
    data['test_meta_title'] = testMetaTitle;
    data['test_meta_keyword'] = testMetaKeyword;
    data['test_meta_desc'] = testMetaDesc;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (hasManyCsTestSubjectDetails != null) {
      data['has_many_cs_test_subject_details'] =
          hasManyCsTestSubjectDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
*/
