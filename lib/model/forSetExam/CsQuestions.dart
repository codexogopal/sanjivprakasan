import 'QuestionOptions.dart';
import 'QuestionOptionsHindi.dart';

class CsQuestions {
  int questionId;
  int questionSubjectId;
  int questionTopic;
  int questionType;
  dynamic questionCorrectAns;
  int questionDifficultyType;
  String questionEng;
  String questionEngSolution;
  String questionHindi;
  String questionHindiSolution;
  int questionStatus;
  int spendTime;
  String ustqaSelectedAns;
  int ustqaAnsStatus;
  int ustqaReviewStatus;
  int ustqaVisitStatus;
  String createdAt;
  String updatedAt;
  String deletedAt;
  List<QuestionOptions>? hasManyEnglishOptions;
  List<QuestionOptionsHindi>? hasManyHindiOptions;

  CsQuestions({
    required this.questionId,
    required this.questionSubjectId,
    required this.questionTopic,
    required this.questionType,
    this.questionCorrectAns,
    required this.questionDifficultyType,
    required this.questionEng,
    required this.questionEngSolution,
    required this.questionHindi,
    required this.questionHindiSolution,
    required this.questionStatus,
    required this.spendTime,
    required this.ustqaSelectedAns,
    required this.ustqaAnsStatus,
    required this.ustqaReviewStatus,
    required this.ustqaVisitStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    this.hasManyEnglishOptions,
    this.hasManyHindiOptions,
  });

  factory CsQuestions.fromJson(Map<String, dynamic> json) {
    return CsQuestions(
      questionId: _parseInt(json['question_id']) ?? 0,
      questionSubjectId: _parseInt(json['question_subject_id']) ?? 0,
      questionTopic: _parseInt(json['question_topic']) ?? 0,
      questionType: _parseInt(json['question_type']) ?? 0,
      questionCorrectAns: json['question_correct_ans']?.toString() ?? "",
      questionDifficultyType: _parseInt(json['question_difficulty_type']) ?? 0,
      questionEng: json['question_eng']?.toString() ?? "",
      questionEngSolution: json['question_eng_solution']?.toString() ?? "",
      questionHindi: json['question_hindi']?.toString() ?? "",
      questionHindiSolution: json['question_hindi_solution']?.toString() ?? "",
      questionStatus: _parseInt(json['question_status']) ?? 0,
      spendTime: _parseInt(json['spend_time']) ?? 0,
      ustqaSelectedAns: json['ustqa_selected_ans']?.toString() ?? "",
      ustqaAnsStatus: _parseInt(json['ustqa_ans_status']) ?? 0,
      ustqaReviewStatus: _parseInt(json['ustqa_review_status']) ?? 0,
      ustqaVisitStatus: _parseInt(json['ustqa_visit_status']) ?? 1,
      createdAt: json['created_at']?.toString() ?? "",
      updatedAt: json['updated_at']?.toString() ?? "",
      deletedAt: json['deleted_at']?.toString() ?? "",
      hasManyEnglishOptions: json['has_many_english_options'] != null
          ? (json['has_many_english_options'] as List)
          .map((i) => QuestionOptions.fromJson(i))
          .toList()
          : null,
      hasManyHindiOptions: json['has_many_hindi_options'] != null
          ? (json['has_many_hindi_options'] as List)
          .map((i) => QuestionOptionsHindi.fromJson(i))
          .toList()
          : null,
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question_id'] = questionId;
    data['question_subject_id'] = questionSubjectId;
    data['question_topic'] = questionTopic;
    data['question_type'] = questionType;
    data['question_correct_ans'] = questionCorrectAns;
    data['question_difficulty_type'] = questionDifficultyType;
    data['question_eng'] = questionEng;
    data['question_eng_solution'] = questionEngSolution;
    data['question_hindi'] = questionHindi;
    data['question_hindi_solution'] = questionHindiSolution;
    data['question_status'] = questionStatus;
    data['spend_time'] = spendTime;
    data['ustqa_selected_ans'] = ustqaSelectedAns;
    data['ustqa_ans_status'] = ustqaAnsStatus;
    data['ustqa_review_status'] = ustqaReviewStatus;
    data['ustqa_visit_status'] = ustqaVisitStatus;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (hasManyEnglishOptions != null) {
      data['has_many_english_options'] =
          hasManyEnglishOptions!.map((v) => v.toJson()).toList();
    }
    if (hasManyHindiOptions != null) {
      data['has_many_hindi_options'] =
          hasManyHindiOptions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

/*
import 'QuestionOptions.dart';
import 'QuestionOptionsHindi.dart';

class CsQuestions {
  int questionId;
  int questionSubjectId;
  int questionTopic;
  int questionType;
  dynamic questionCorrectAns;
  int questionDifficultyType;
  String questionEng;
  String questionEngSolution;
  String questionHindi;
  String questionHindiSolution;
  int questionStatus;
  int spendTime;
  String ustqaSelectedAns;
  int ustqaAnsStatus;
  int ustqaReviewStatus;
  int ustqaVisitStatus;
  String createdAt;
  String updatedAt;
  String deletedAt;
  List<QuestionOptions>? hasManyEnglishOptions;
  List<QuestionOptionsHindi>? hasManyHindiOptions;

  CsQuestions({
    required this.questionId,
    required this.questionSubjectId,
    required this.questionTopic,
    required this.questionType,
    this.questionCorrectAns,
    required this.questionDifficultyType,
    required this.questionEng,
    required this.questionEngSolution,
    required this.questionHindi,
    required this.questionHindiSolution,
    required this.questionStatus,
    required this.spendTime,
    required this.ustqaSelectedAns,
    required this.ustqaAnsStatus,
    required this.ustqaReviewStatus,
    required this.ustqaVisitStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    this.hasManyEnglishOptions,
    this.hasManyHindiOptions,
  });

  factory CsQuestions.fromJson(Map<String, dynamic> json) {
    return CsQuestions(
      questionId: json['question_id'] ?? 0,
      questionSubjectId: json['question_subject_id'] ?? 0,
      questionTopic: json['question_topic'] ?? 0,
      questionType: json['question_type'] ?? 0,
      questionCorrectAns: json['question_correct_ans'] ?? "",
      questionDifficultyType: json['question_difficulty_type'] ?? 0,
      questionEng: json['question_eng'] ?? "",
      questionEngSolution: json['question_eng_solution'] ?? "",
      questionHindi: json['question_hindi'] ?? "",
      questionHindiSolution: json['question_hindi_solution'] ?? "",
      questionStatus: json['question_status'] ?? 0,
      spendTime: json.containsKey("spend_time") ? json["spend_time"] : 0,
      ustqaSelectedAns: json['ustqa_selected_ans'] ?? "",
      ustqaAnsStatus: json['ustqa_ans_status'] ?? 0,
      ustqaReviewStatus: json['ustqa_review_status'] ?? "",
      ustqaVisitStatus: json.containsKey("ustqa_visit_status") ? json['ustqa_visit_status'] : 1,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      hasManyEnglishOptions: json['has_many_english_options'] != null
          ? (json['has_many_english_options'] as List)
          .map((i) => QuestionOptions.fromJson(i))
          .toList()
          : null,
      hasManyHindiOptions: json['has_many_hindi_options'] != null
          ? (json['has_many_hindi_options'] as List)
          .map((i) => QuestionOptionsHindi.fromJson(i))
          .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question_id'] = questionId;
    data['question_subject_id'] = questionSubjectId;
    data['question_topic'] = questionTopic;
    data['question_type'] = questionType;
    data['question_correct_ans'] = questionCorrectAns;
    data['question_difficulty_type'] = questionDifficultyType;
    data['question_eng'] = questionEng;
    data['question_eng_solution'] = questionEngSolution;
    data['question_hindi'] = questionHindi;
    data['question_hindi_solution'] = questionHindiSolution;
    data['question_status'] = questionStatus;
    data['spend_time'] = spendTime;
    data['ustqa_selected_ans'] = ustqaSelectedAns;
    data['ustqa_ans_status'] = ustqaAnsStatus;
    data['ustqa_review_status'] = ustqaReviewStatus;
    data['ustqa_visit_status'] = ustqaVisitStatus;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (hasManyEnglishOptions != null) {
      data['has_many_english_options'] =
          hasManyEnglishOptions!.map((v) => v.toJson()).toList();
    }
    if (hasManyHindiOptions != null) {
      data['has_many_hindi_options'] =
          hasManyHindiOptions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}*/
