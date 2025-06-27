class GetQuestionOptionsModel {
  final int id;
  final int qoId;
  final int queNo;
  final int testQuestion;
  final int qoQuestionId;
  final int testId;
  final int subjectId;
  final int topicId;
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

  GetQuestionOptionsModel({
    required this.id,
    required this.qoId,
    required this.queNo,
    required this.testQuestion,
    required this.qoQuestionId,
    required this.testId,
    required this.subjectId,
    required this.topicId,
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

  factory GetQuestionOptionsModel.fromMap(Map<String, dynamic> map) {
    return GetQuestionOptionsModel(
      id: _parseInt(map['id']) ?? 0,
      qoId: _parseInt(map['qo_id']) ?? 0,
      queNo: _parseInt(map['que_no']) ?? 0,
      testQuestion: _parseInt(map['test_question']) ?? 0,
      qoQuestionId: _parseInt(map['qo_question_id']) ?? 0,
      testId: _parseInt(map['test_id']) ?? 0,
      subjectId: _parseInt(map['subject_id']) ?? 0,
      topicId: _parseInt(map['topic_id']) ?? 0,
      qoOptions: map['qo_options']?.toString() ?? "",
      qoOptionsSec: map['qo_options_sec']?.toString() ?? "",
      qoCorrectAns: map['qo_correct_ans']?.toString() ?? "",
      qoText: map['qo_text']?.toString() ?? "",
      qoTextSec: map['qo_text_sec']?.toString() ?? "",
      qoLang: _parseInt(map['qo_lang']) ?? 0,
      qoEditor: _parseInt(map['qo_editor']) ?? 0,
      qoSelectedAns: map['qo_selected_ans']?.toString() ?? "",
      qoIsSelectedOrNot: _parseInt(map['qoIsSecletedOrNot']) ?? 0,
      createdAt: map['created_at']?.toString() ?? "",
      updatedAt: map['updated_at']?.toString() ?? "",
      deletedAt: map['deleted_at']?.toString() ?? "",
      hindiQoOptions: map['hindi_qo_options']?.toString() ?? "",
      hindiQoText: map['hindi_qo_text']?.toString() ?? "",
      hindiQoTextSec: map['hindi_qo_text_sec']?.toString() ?? "",
      hindiQoSelectedAns: map['hindi_qo_selected_ans']?.toString() ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'qo_id': qoId,
      'que_no': queNo,
      'test_question': testQuestion,
      'qo_question_id': qoQuestionId,
      'test_id': testId,
      'subject_id': subjectId,
      'topic_id': topicId,
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
class GetQuestionOptionsModel {
  final int? id;
  final int? qoId;
  final int? queNo;
  final int? testQuestion;
  final int? qoQuestionId;
  final int? testId;
  final int? subjectId;
  final int? topicId;
  final String? qoOptions;
  final String? qoOptionsSec;
  final String? qoCorrectAns;
  final String? qoText;
  final String? qoTextSec;
  final int? qoLang;
  final int? qoEditor;
  final String? qoSelectedAns;
  final int? qoIsSelectedOrNot;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final String? hindiQoOptions;
  final String? hindiQoText;
  final String? hindiQoTextSec;
  final String? hindiQoSelectedAns;

  GetQuestionOptionsModel({
    this.id,
    this.qoId,
    this.queNo,
    this.testQuestion,
    this.qoQuestionId,
    this.testId,
    this.subjectId,
    this.topicId,
    this.qoOptions,
    this.qoOptionsSec,
    this.qoCorrectAns,
    this.qoText,
    this.qoTextSec,
    this.qoLang,
    this.qoEditor,
    this.qoSelectedAns,
    this.qoIsSelectedOrNot,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.hindiQoOptions,
    this.hindiQoText,
    this.hindiQoTextSec,
    this.hindiQoSelectedAns,
  });

  factory GetQuestionOptionsModel.fromMap(Map<String, dynamic> map) {
    return GetQuestionOptionsModel(
      id: map['id'],
      qoId: map['qo_id'],
      queNo: map['que_no'],
      testQuestion: map['test_question'],
      qoQuestionId: map['qo_question_id'],
      testId: map['test_id'],
      subjectId: map['subject_id'],
      topicId: map['topic_id'],
      qoOptions: map['qo_options'],
      qoOptionsSec: map['qo_options_sec'],
      qoCorrectAns: map['qo_correct_ans'],
      qoText: map['qo_text'],
      qoTextSec: map['qo_text_sec'],
      qoLang: map['qo_lang'],
      qoEditor: map['qo_editor'],
      qoSelectedAns: map['qo_selected_ans'],
      qoIsSelectedOrNot: map['qoIsSecletedOrNot'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
      deletedAt: map['deleted_at'],
      hindiQoOptions: map['hindi_qo_options'],
      hindiQoText: map['hindi_qo_text'],
      hindiQoTextSec: map['hindi_qo_text_sec'],
      hindiQoSelectedAns: map['hindi_qo_selected_ans'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'qo_id': qoId,
      'que_no': queNo,
      'test_question': testQuestion,
      'qo_question_id': qoQuestionId,
      'test_id': testId,
      'subject_id': subjectId,
      'topic_id': topicId,
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
