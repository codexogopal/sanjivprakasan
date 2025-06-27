import 'CsSubjects.dart';
import 'CsTestSeriesQuestions.dart';

class CsTestSubjectDetails {
  int testId;
  int testSubject;
  String testTopic;
  int testTotalQuestion;
  int testExamId;
  String createdAt;
  String updatedAt;
  List<CsTestSeriesQuestions>? hasManyCsTestSeriesQuestions;
  CsSubjects? belongsToCsSubjects;

  CsTestSubjectDetails({
    required this.testId,
    required this.testSubject,
    required this.testTopic,
    required this.testTotalQuestion,
    required this.testExamId,
    required this.createdAt,
    required this.updatedAt,
    this.hasManyCsTestSeriesQuestions,
    this.belongsToCsSubjects,
  });

  factory CsTestSubjectDetails.fromJson(Map<String, dynamic> json) {
    return CsTestSubjectDetails(
      testId: _parseInt(json['test_id']) ?? 0,
      testSubject: _parseInt(json['test_subject']) ?? 0,
      testTopic: json['test_topic']?.toString() ?? "",
      testTotalQuestion: _parseInt(json['test_total_question']) ?? 0,
      testExamId: _parseInt(json['test_exam_id']) ?? 0,
      createdAt: json['created_at']?.toString() ?? "",
      updatedAt: json['updated_at']?.toString() ?? "",
      hasManyCsTestSeriesQuestions: json['has_many_cs_test_series_questions'] != null
          ? (json['has_many_cs_test_series_questions'] as List)
          .map((i) => CsTestSeriesQuestions.fromJson(i))
          .toList()
          : null,
      belongsToCsSubjects: json['belongs_to_cs_subjects'] != null
          ? CsSubjects.fromJson(json['belongs_to_cs_subjects'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['test_id'] = testId;
    data['test_subject'] = testSubject;
    data['test_topic'] = testTopic;
    data['test_total_question'] = testTotalQuestion;
    data['test_exam_id'] = testExamId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (hasManyCsTestSeriesQuestions != null) {
      data['has_many_cs_test_series_questions'] =
          hasManyCsTestSeriesQuestions!.map((v) => v.toJson()).toList();
    }
    if (belongsToCsSubjects != null) {
      data['belongs_to_cs_subjects'] = belongsToCsSubjects!.toJson();
    }
    return data;
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}


/*
import 'CsSubjects.dart';
import 'CsTestSeriesQuestions.dart';

class CsTestSubjectDetails {
  int testId;
  int testSubject;
  dynamic testTopic;
  int testTotalQuestion;
  int testExamId;
  String createdAt;
  String updatedAt;
  List<CsTestSeriesQuestions>? hasManyCsTestSeriesQuestions;
  CsSubjects? belongsToCsSubjects;

  CsTestSubjectDetails({
    required this.testId,
    required this.testSubject,
    this.testTopic,
    required this.testTotalQuestion,
    required this.testExamId,
    required this.createdAt,
    required this.updatedAt,
    this.hasManyCsTestSeriesQuestions,
    this.belongsToCsSubjects,
  });

  factory CsTestSubjectDetails.fromJson(Map<String, dynamic> json) {
    return CsTestSubjectDetails(
      testId: json['test_id'] ?? 0,
      testSubject: json['test_subject'] ?? 0,
      testTopic: json['test_topic'] ?? "",
      testTotalQuestion: json['test_total_question'],
      testExamId: json['test_exam_id'] ?? 0,
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      hasManyCsTestSeriesQuestions:
      json['has_many_cs_test_series_questions'] != null
          ? (json['has_many_cs_test_series_questions'] as List)
          .map((i) => CsTestSeriesQuestions.fromJson(i))
          .toList()
          : null,
      belongsToCsSubjects: json['belongs_to_cs_subjects'] != null
          ? CsSubjects.fromJson(json['belongs_to_cs_subjects'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['test_id'] = testId;
    data['test_subject'] = testSubject;
    data['test_topic'] = testTopic;
    data['test_total_question'] = testTotalQuestion;
    data['test_exam_id'] = testExamId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (hasManyCsTestSeriesQuestions != null) {
      data['has_many_cs_test_series_questions'] =
          hasManyCsTestSeriesQuestions!.map((v) => v.toJson()).toList();
    }
    if (belongsToCsSubjects != null) {
      data['belongs_to_cs_subjects'] = belongsToCsSubjects!.toJson();
    }
    return data;
  }
}*/
