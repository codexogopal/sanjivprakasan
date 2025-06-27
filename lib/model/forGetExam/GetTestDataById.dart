class GetTestDataById {
  final int id;
  final int testId;
  final String testType;
  final String testTypeName;
  final int testExamType;
  final String testCategoryId;
  final String testQuizCategoryId;
  final String textLang;
  final String testTitle;
  final String testCourse;
  final String testDescription;
  final int testTotalNoOfQues;
  final int testPauseOnQueNum;
  final int testTotalMarks;
  final String testDuration;
  final String testTime;
  final String testScheduleDate;
  final String testAnnouncementDate;
  final String testNegativeMarking;
  final String testPaperPdf;
  final String testSolution;
  final String testImage;
  final int testMarksPerQuestion;
  final int testAttemptCount;
  final int testStatus;
  final String examPauseTime;
  final String testMetaTitle;
  final String testMetaKeyword;
  final String testMetaDesc;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  GetTestDataById({
    required this.id,
    required this.testId,
    required this.testType,
    required this.testTypeName,
    required this.testExamType,
    required this.testCategoryId,
    required this.testQuizCategoryId,
    required this.textLang,
    required this.testTitle,
    required this.testCourse,
    required this.testDescription,
    required this.testTotalNoOfQues,
    required this.testPauseOnQueNum,
    required this.testTotalMarks,
    required this.testDuration,
    required this.testTime,
    required this.testScheduleDate,
    required this.testAnnouncementDate,
    required this.testNegativeMarking,
    required this.testPaperPdf,
    required this.testSolution,
    required this.testImage,
    required this.testMarksPerQuestion,
    required this.testAttemptCount,
    required this.testStatus,
    required this.examPauseTime,
    required this.testMetaTitle,
    required this.testMetaKeyword,
    required this.testMetaDesc,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory GetTestDataById.fromMap(Map<String, dynamic> map) {
    return GetTestDataById(
      id: _parseInt(map['id']) ?? 0,
      testId: _parseInt(map['test_id']) ?? 0,
      testType: map['test_type'] ?? "",
      testTypeName: map['test_type_name'] ?? "",
      testExamType: _parseInt(map['test_exam_type']) ?? 0,
      testCategoryId: map['test_category_id'] ?? "",
      testQuizCategoryId: map['test_quiz_category_id'] ?? "",
      textLang: map['text_lang'] ?? "",
      testTitle: map['test_title'] ?? "",
      testCourse: map['test_course'] ?? "",
      testDescription: map['test_description'] ?? "",
      testTotalNoOfQues: _parseInt(map['test_total_no_of_ques']) ?? 0,
      testPauseOnQueNum: _parseInt(map['test_pause_on_que_num']) ?? 0,
      testTotalMarks: _parseInt(map['test_total_marks']) ?? 0,
      testDuration: map['test_duration'] ?? "",
      testTime: map['test_time'] ?? "",
      testScheduleDate: map['test_schedule_date'] ?? "",
      testAnnouncementDate: map['test_announcement_date'] ?? "",
      testNegativeMarking: map['test_negative_marking'] ?? "",
      testPaperPdf: map['test_paperpdf'] ?? "",
      testSolution: map['test_solution'] ?? "",
      testImage: map['test_image'] ?? "",
      testMarksPerQuestion: _parseInt(map['test_marks_perquestion']) ?? 0,
      testAttemptCount: _parseInt(map['test_attempt_count']) ?? 0,
      testStatus: _parseInt(map['test_status']) ?? 0,
      examPauseTime: map['exam_pause_time'] ?? "",
      testMetaTitle: map['test_meta_title'] ?? "",
      testMetaKeyword: map['test_meta_keyword'] ?? "",
      testMetaDesc: map['test_meta_desc'] ?? "",
      createdAt: map['created_at'] ?? "",
      updatedAt: map['updated_at'] ?? "",
      deletedAt: map['deleted_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'test_id': testId,
      'test_type': testType,
      'test_type_name': testTypeName,
      'test_exam_type': testExamType,
      'test_category_id': testCategoryId,
      'test_quiz_category_id': testQuizCategoryId,
      'text_lang': textLang,
      'test_title': testTitle,
      'test_course': testCourse,
      'test_description': testDescription,
      'test_total_no_of_ques': testTotalNoOfQues,
      'test_pause_on_que_num': testPauseOnQueNum,
      'test_total_marks': testTotalMarks,
      'test_duration': testDuration,
      'test_time': testTime,
      'test_schedule_date': testScheduleDate,
      'test_announcement_date': testAnnouncementDate,
      'test_negative_marking': testNegativeMarking,
      'test_paperpdf': testPaperPdf,
      'test_solution': testSolution,
      'test_image': testImage,
      'test_marks_perquestion': testMarksPerQuestion,
      'test_attempt_count': testAttemptCount,
      'test_status': testStatus,
      'exam_pause_time': examPauseTime,
      'test_meta_title': testMetaTitle,
      'test_meta_keyword': testMetaKeyword,
      'test_meta_desc': testMetaDesc,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }

  @override
  String toString() {
    return 'GetTestDataById{id: $id, testTitle: $testTitle, testDescription: $testDescription}';
  }
}

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  return null;
}


/*
class GetTestDataById {
  final int id;
  final int testId;
  final String testType;
  final String testTypeName;
  final int testExamType;
  final String testCategoryId;
  final String testQuizCategoryId;
  final String textLang;
  final String testTitle;
  final String testCourse;
  final String testDescription;
  final int testTotalNoOfQues;
  final int testPauseOnQueNum;
  final int testTotalMarks;
  final String testDuration;
  final String testTime;
  final String testScheduleDate;
  final String testAnnouncementDate;
  final String testNegativeMarking;
  final String testPaperPdf;
  final String testSolution;
  final String testImage;
  final int testMarksPerQuestion;
  final int testAttemptCount;
  final int testStatus;
  final String examPauseTime;
  final String testMetaTitle;
  final String testMetaKeyword;
  final String testMetaDesc;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  GetTestDataById({
    required this.id,
    required this.testId,
    required this.testType,
    required this.testTypeName,
    required this.testExamType,
    required this.testCategoryId,
    required this.testQuizCategoryId,
    required this.textLang,
    required this.testTitle,
    required this.testCourse,
    required this.testDescription,
    required this.testTotalNoOfQues,
    required this.testPauseOnQueNum,
    required this.testTotalMarks,
    required this.testDuration,
    required this.testTime,
    required this.testScheduleDate,
    required this.testAnnouncementDate,
    required this.testNegativeMarking,
    required this.testPaperPdf,
    required this.testSolution,
    required this.testImage,
    required this.testMarksPerQuestion,
    required this.testAttemptCount,
    required this.testStatus,
    required this.examPauseTime,
    required this.testMetaTitle,
    required this.testMetaKeyword,
    required this.testMetaDesc,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory GetTestDataById.fromMap(Map<String, dynamic> map) {
    return GetTestDataById(
      id: map['id'] ?? 0,
      testId: map['test_id'] ?? 0,
      testType: map['test_type'] ?? "",
      testTypeName: map['test_type_name'] ?? "",
      testExamType: map['test_exam_type']?? 0,
      testCategoryId: map['test_category_id'] ?? "",
      testQuizCategoryId: map['test_quiz_category_id'] ?? "",
      textLang: map['text_lang'] ?? "",
      testTitle: map['test_title'] ?? "",
      testCourse: map['test_course'] ?? "",
      testDescription: map['test_description'] ?? "",
      testTotalNoOfQues: map['test_total_no_of_ques']?? 0,
      testPauseOnQueNum: map['test_pause_on_que_num']?? 0,
      testTotalMarks: map['test_total_marks']?? 0,
      testDuration: map['test_duration'] ?? "",
      testTime: map['test_time'] ?? "",
      testScheduleDate: map['test_schedule_date'] ?? "",
      testAnnouncementDate: map['test_announcement_date'] ?? "",
      testNegativeMarking: map['test_negative_marking'] ?? "",
      testPaperPdf: map['test_paperpdf'] ?? "",
      testSolution: map['test_solution'] ?? "",
      testImage: map['test_image'] ?? "",
      testMarksPerQuestion: map['test_marks_perquestion']?? 0,
      testAttemptCount: map['test_attempt_count']?? 0,
      testStatus: map['test_status']?? 0,
      examPauseTime: map['exam_pause_time'] ?? "",
      testMetaTitle: map['test_meta_title'] ?? "",
      testMetaKeyword: map['test_meta_keyword'] ?? "",
      testMetaDesc: map['test_meta_desc'] ?? "",
      createdAt: map['created_at'] ?? "",
      updatedAt: map['updated_at'] ?? "",
      deletedAt: map['deleted_at'] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'test_id': testId,
      'test_type': testType,
      'test_type_name': testTypeName,
      'test_exam_type': testExamType,
      'test_category_id': testCategoryId,
      'test_quiz_category_id': testQuizCategoryId,
      'text_lang': textLang,
      'test_title': testTitle,
      'test_course': testCourse,
      'test_description': testDescription,
      'test_total_no_of_ques': testTotalNoOfQues,
      'test_pause_on_que_num': testPauseOnQueNum,
      'test_total_marks': testTotalMarks,
      'test_duration': testDuration,
      'test_time': testTime,
      'test_schedule_date': testScheduleDate,
      'test_announcement_date': testAnnouncementDate,
      'test_negative_marking': testNegativeMarking,
      'test_paperpdf': testPaperPdf,
      'test_solution': testSolution,
      'test_image': testImage,
      'test_marks_perquestion': testMarksPerQuestion,
      'test_attempt_count': testAttemptCount,
      'test_status': testStatus,
      'exam_pause_time': examPauseTime,
      'test_meta_title': testMetaTitle,
      'test_meta_keyword': testMetaKeyword,
      'test_meta_desc': testMetaDesc,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }

  @override
  String toString() {
    return 'GetTestDataById{id: $id, testTitle: $testTitle, testDescription: $testDescription}';
  }
}*/
