class QuestionOptionsHindi {
  final int qoId;
  final int qoQuestionId;
  final String qoOptions;
  final String qoOptionsSec;
  final String qoCorrectAns;
  final String qoText;
  final String qoTextSec;
  final int qoLang;
  final int qoEditor;
  final String qoSelectedAns;
  final int qoIsSelectedOrNot;
  final String createdAt;
  final String updatedAt;
  final String deletedAt;

  QuestionOptionsHindi({
    required this.qoId,
    required this.qoQuestionId,
    required this.qoOptions,
    required this.qoOptionsSec,
    required this.qoCorrectAns,
    required this.qoText,
    required this.qoTextSec,
    required this.qoLang,
    required this.qoEditor,
    required this.qoSelectedAns,
    required this.qoIsSelectedOrNot,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory QuestionOptionsHindi.fromJson(Map<String, dynamic> json) {
    return QuestionOptionsHindi(
      qoId: _parseInt(json['qo_id']) ?? 0,
      qoQuestionId: _parseInt(json['qo_question_id']) ?? 0,
      qoOptions: json['qo_options']?.toString() ?? "",
      qoOptionsSec: json['qo_options_sec']?.toString() ?? "",
      qoCorrectAns: json['qo_correct_ans']?.toString() ?? "",
      qoText: json['qo_text']?.toString() ?? "",
      qoTextSec: json['qo_text_sec']?.toString() ?? "",
      qoLang: _parseInt(json['qo_lang']) ?? 0,
      qoEditor: _parseInt(json['qo_editor']) ?? 0,
      qoSelectedAns: json['qo_selected_ans']?.toString() ?? "",
      qoIsSelectedOrNot: _parseInt(json['qoIsSecletedOrNot']) ?? 0,
      createdAt: json['created_at']?.toString() ?? "",
      updatedAt: json['updated_at']?.toString() ?? "",
      deletedAt: json['deleted_at']?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'qo_id': qoId,
      'qo_question_id': qoQuestionId,
      'qo_options': qoOptions,
      'qo_options_sec': qoOptionsSec,
      'qo_correct_ans': qoCorrectAns,
      'qo_text': qoText,
      'qo_text_sec': qoTextSec,
      'qo_lang': qoLang,
      'qo_editor': qoEditor,
      'qo_selected_ans': qoSelectedAns,
      'qoIsSecletedOrNot': qoIsSelectedOrNot,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
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
class QuestionOptionsHindi {
  final int qoId;
  final int qoQuestionId;
  final String qoOptions;
  final String? qoOptionsSec;
  final String qoCorrectAns;
  final String qoText;
  final String? qoTextSec;
  final int qoLang;
  final int qoEditor;
  final String qoSelectedAns;
  final int qoIsSelectedOrNot;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  QuestionOptionsHindi({
    required this.qoId,
    required this.qoQuestionId,
    required this.qoOptions,
    this.qoOptionsSec,
    required this.qoCorrectAns,
    required this.qoText,
    this.qoTextSec,
    required this.qoLang,
    required this.qoEditor,
    required this.qoSelectedAns,
    required this.qoIsSelectedOrNot,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory QuestionOptionsHindi.fromJson(Map<String, dynamic> json) {
    return QuestionOptionsHindi(
      qoId: json['qo_id'] ?? 0,
      qoQuestionId: json['qo_question_id'] ?? 0,
      qoOptions: json['qo_options'] ?? "",
      qoOptionsSec: json['qo_options_sec'] ?? "",
      qoCorrectAns: json['qo_correct_ans'] ?? "",
      qoText: json['qo_text'] ?? "",
      qoTextSec: json['qo_text_sec'] ?? "",
      qoLang: json['qo_lang'] ?? 0,
      qoEditor: json['qo_editor'] ?? 0,
      qoSelectedAns: json['qo_selected_ans'] ?? "",
      qoIsSelectedOrNot: json['qoIsSecletedOrNot'] ?? 0,
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      deletedAt: json['deleted_at'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'qo_id': qoId,
      'qo_question_id': qoQuestionId,
      'qo_options': qoOptions,
      'qo_options_sec': qoOptionsSec,
      'qo_correct_ans': qoCorrectAns,
      'qo_text': qoText,
      'qo_text_sec': qoTextSec,
      'qo_lang': qoLang,
      'qo_editor': qoEditor,
      'qo_selected_ans': qoSelectedAns,
      'qoIsSecletedOrNot': qoIsSelectedOrNot,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
*/
