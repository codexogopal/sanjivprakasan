import 'GetTestQuestionByTidQidModel.dart';

class GetSubjectWithQuestionsModel {
  final int id;
  final int testId;
  final int subjectId;
  final String subjectName;
  final int testTopic;
  final int testTotalQuestion;
  final String createdAt;
  final String updatedAt;
  final List<GetTestQuestionByTidQidModel> questions;
  bool isExpanded;

  GetSubjectWithQuestionsModel({
    required this.id,
    required this.testId,
    required this.subjectId,
    required this.subjectName,
    required this.testTopic,
    required this.testTotalQuestion,
    required this.createdAt,
    required this.updatedAt,
    required this.questions,
    this.isExpanded = true,
  });

  factory GetSubjectWithQuestionsModel.fromMap(
      Map<String, dynamic> map, List<GetTestQuestionByTidQidModel> questions) {
    return GetSubjectWithQuestionsModel(
      id: _parseInt(map['id']) ?? 0,
      testId: _parseInt(map['test_id']) ?? 0,
      subjectId: _parseInt(map['subject_id']) ?? 0,
      subjectName: map['subject_name']?.toString() ?? "",
      testTopic: _parseInt(map['test_topic']) ?? 0,
      testTotalQuestion: _parseInt(map['test_total_question']) ?? 0,
      createdAt: map['created_at']?.toString() ?? "",
      updatedAt: map['updated_at']?.toString() ?? "",
      questions: questions,
    );
  }

  factory GetSubjectWithQuestionsModel.fromMapNew(Map<String, dynamic> map) {
    return GetSubjectWithQuestionsModel(
      id: _parseInt(map['id']) ?? 0,
      testId: _parseInt(map['test_id']) ?? 0,
      subjectId: _parseInt(map['subject_id']) ?? 0,
      subjectName: map['subject_name']?.toString() ?? "",
      testTopic: _parseInt(map['test_topic']) ?? 0,
      testTotalQuestion: _parseInt(map['test_total_question']) ?? 0,
      createdAt: map['created_at']?.toString() ?? "",
      updatedAt: map['updated_at']?.toString() ?? "",
      questions: [],
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}



/*
import 'GetTestQuestionByTidQidModel.dart';

class GetSubjectWithQuestionsModel {
  final int id;
  final int testId;
  final int subjectId;
  final String subjectName;
  final int testTopic;
  final int testTotalQuestion;
  final String createdAt;
  final String updatedAt;
  final List<GetTestQuestionByTidQidModel> questions;
  bool isExpanded;

  GetSubjectWithQuestionsModel({
    required this.id,
    required this.testId,
    required this.subjectId,
    required this.subjectName,
    required this.testTopic,
    required this.testTotalQuestion,
    required this.createdAt,
    required this.updatedAt,
    required this.questions,
    this.isExpanded = true,
  });

  factory GetSubjectWithQuestionsModel.fromMap(Map<String, dynamic> map, List<GetTestQuestionByTidQidModel> questions) {
    return GetSubjectWithQuestionsModel(
      id: map['id'] ?? 0,
      testId: map['test_id'] ?? 0,
      subjectId: map['subject_id'] ?? 0,
      subjectName: map['subject_name'] ?? "",
      testTopic: map['test_topic'] ?? 0,
      testTotalQuestion: map['test_total_question'] ?? 0,
      createdAt: map['created_at'] ?? "",
      updatedAt: map['updated_at'] ?? "",
      questions: questions,
    );
  }

  factory GetSubjectWithQuestionsModel.fromMapNew(Map<String, dynamic> map,) {
    return GetSubjectWithQuestionsModel(
      id: map['id'] ?? 0,
      testId: map['test_id'] ?? 0,
      subjectId: map['subject_id'] ?? 0,
      subjectName: map['subject_name'] ?? "",
      testTopic: map['test_topic'] ?? 0,
      testTotalQuestion: map['test_total_question'] ?? 0,
      createdAt: map['created_at'] ?? "",
      updatedAt: map['updated_at'] ?? "",
      questions: [],
    );
  }
}
*/
