import 'CsQuestions.dart';

class CsTestSeriesQuestions {
  int questionId;
  int questionQueId;
  int questionTest;
  int questionTopic;
  int questionSubject;
  String createdAt;
  String updatedAt;
  CsQuestions? belongsToCsQuestions;

  CsTestSeriesQuestions({
    required this.questionId,
    required this.questionQueId,
    required this.questionTest,
    required this.questionTopic,
    required this.questionSubject,
    required this.createdAt,
    required this.updatedAt,
    this.belongsToCsQuestions,
  });

  factory CsTestSeriesQuestions.fromJson(Map<String, dynamic> json) {
    return CsTestSeriesQuestions(
      questionId: _parseInt(json['question_id']) ?? 0,
      questionQueId: _parseInt(json['question_que_id']) ?? 0,
      questionTest: _parseInt(json['question_test']) ?? 0,
      questionTopic: _parseInt(json['question_topic']) ?? 0,
      questionSubject: _parseInt(json['question_subject']) ?? 0,
      createdAt: json['created_at']?.toString() ?? "",
      updatedAt: json['updated_at']?.toString() ?? "",
      belongsToCsQuestions: json['belongs_to_cs_questions'] != null
          ? CsQuestions.fromJson(json['belongs_to_cs_questions'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question_id'] = questionId;
    data['question_que_id'] = questionQueId;
    data['question_test'] = questionTest;
    data['question_topic'] = questionTopic;
    data['question_subject'] = questionSubject;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (belongsToCsQuestions != null) {
      data['belongs_to_cs_questions'] = belongsToCsQuestions!.toJson();
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
import 'CsQuestions.dart';

class CsTestSeriesQuestions {
  int? questionId;
  int? questionQueId;
  int? questionTest;
  int? questionTopic;
  int? questionSubject;
  String? createdAt;
  String? updatedAt;
  CsQuestions? belongsToCsQuestions;

  CsTestSeriesQuestions({
    this.questionId,
    this.questionQueId,
    this.questionTest,
    this.questionTopic,
    this.questionSubject,
    this.createdAt,
    this.updatedAt,
    this.belongsToCsQuestions,
  });

  factory CsTestSeriesQuestions.fromJson(Map<String, dynamic> json) {
    return CsTestSeriesQuestions(
      questionId: json['question_id'],
      questionQueId: json['question_que_id'],
      questionTest: json['question_test'],
      questionTopic: json['question_topic'],
      questionSubject: json['question_subject'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      belongsToCsQuestions: json['belongs_to_cs_questions'] != null
          ? CsQuestions.fromJson(json['belongs_to_cs_questions'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question_id'] = questionId;
    data['question_que_id'] = questionQueId;
    data['question_test'] = questionTest;
    data['question_topic'] = questionTopic;
    data['question_subject'] = questionSubject;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (belongsToCsQuestions != null) {
      data['belongs_to_cs_questions'] = belongsToCsQuestions!.toJson();
    }
    return data;
  }
}*/
