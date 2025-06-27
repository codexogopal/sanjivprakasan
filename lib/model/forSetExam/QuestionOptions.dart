class QuestionOptions {
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
  final String hindiQoOptions;
  final String hindiQoText;
  final String hindiQoTextSec;
  final String hindiQoSelectedAns;

  QuestionOptions({
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
    required this.hindiQoOptions,
    required this.hindiQoText,
    required this.hindiQoTextSec,
    required this.hindiQoSelectedAns,
  });

  factory QuestionOptions.fromJson(Map<String, dynamic> json) {
    return QuestionOptions(
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
      hindiQoOptions: json['hindi_qo_options']?.toString() ?? "",
      hindiQoText: json['hindi_qo_text']?.toString() ?? "",
      hindiQoTextSec: json['hindi_qo_text_sec']?.toString() ?? "",
      hindiQoSelectedAns: json['hindi_qo_selected_ans']?.toString() ?? "",
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
      'hindi_qo_options': hindiQoOptions,
      'hindi_qo_text': hindiQoText,
      'hindi_qo_text_sec': hindiQoTextSec,
      'hindi_qo_selected_ans': hindiQoSelectedAns,
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
class QuestionOptions {
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
  final String hindiQoOptions;
  final String hindiQoText;
  final String hindiQoTextSec;
  final String hindiQoSelectedAns;

  QuestionOptions({
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
    required this.hindiQoOptions,
    required this.hindiQoText,
    required this.hindiQoTextSec,
    required this.hindiQoSelectedAns,
  });

  factory QuestionOptions.fromJson(Map<String, dynamic> json) {
    return QuestionOptions(
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
      hindiQoOptions: json['hindi_qo_options'] ?? "",
      hindiQoText: json['hindi_qo_text'] ?? "",
      hindiQoTextSec: json['hindi_qo_text_sec'] ?? "",
      hindiQoSelectedAns: json['hindi_qo_selected_ans'] ?? "",
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
      'hindi_qo_options': hindiQoOptions,
      'hindi_qo_text': hindiQoText,
      'hindi_qo_text_sec': hindiQoTextSec,
      'hindi_qo_selected_ans': hindiQoSelectedAns,
    };
  }
}


*/
