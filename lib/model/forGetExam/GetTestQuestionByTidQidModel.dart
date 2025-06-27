class GetTestQuestionByTidQidModel {
  final int? id;
  final int? questionId;
  final int? queNo;
  final int? testQuestion;
  final int? testId;
  final int? subjectId;
  final int? topicId;
  final int? type;
  final String? questionCorrectAns;
  final int? difficulty;
  final String? questionEng;
  final String? questionEngSolution;
  final String? questionHindi;
  final String? questionHindiSolution;
  final int? status;
  final int? spendTime;
  final String? selectedAns;
  final int? visitStatus;
  final int? ansStatus;
  final int? reviewStatus;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  GetTestQuestionByTidQidModel({
    this.id,
    this.questionId,
    this.queNo,
    this.testQuestion,
    this.testId,
    this.subjectId,
    this.topicId,
    this.type,
    this.questionCorrectAns,
    this.difficulty,
    this.questionEng,
    this.questionEngSolution,
    this.questionHindi,
    this.questionHindiSolution,
    this.status,
    this.spendTime,
    this.selectedAns,
    this.visitStatus,
    this.ansStatus,
    this.reviewStatus,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory GetTestQuestionByTidQidModel.fromMap(Map<String, dynamic> map) {
    return GetTestQuestionByTidQidModel(
      id: _parseInt(map['id']),
      questionId: _parseInt(map['question_id']),
      queNo: _parseInt(map['que_no']),
      testQuestion: _parseInt(map['test_question']),
      testId: _parseInt(map['test_id']),
      subjectId: _parseInt(map['subject_id']),
      topicId: _parseInt(map['topic_id']),
      type: _parseInt(map['type']),
      questionCorrectAns: map['question_correct_ans']?.toString(),
      difficulty: _parseInt(map['difficulty']),
      questionEng: map['question_eng']?.toString(),
      questionEngSolution: map['question_eng_solution']?.toString(),
      questionHindi: map['question_hindi']?.toString(),
      questionHindiSolution: map['question_hindi_solution']?.toString(),
      status: _parseInt(map['status']),
      spendTime: _parseInt(map['spend_time']),
      selectedAns: map['selected_ans']?.toString(),
      visitStatus: _parseInt(map['visit_status']),
      ansStatus: _parseInt(map['ans_status']),
      reviewStatus: _parseInt(map['review_status']),
      createdAt: map['created_at']?.toString(),
      updatedAt: map['updated_at']?.toString(),
      deletedAt: map['deleted_at']?.toString(),
    );
  }

// Helper function to parse int from dynamic value
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question_id': questionId,
      'que_no': queNo,
      'test_question': testQuestion,
      'test_id': testId,
      'subject_id': subjectId,
      'topic_id': topicId,
      'type': type,
      'question_correct_ans': questionCorrectAns,
      'difficulty': difficulty,
      'question_eng': questionEng,
      'question_eng_solution': questionEngSolution,
      'question_hindi': questionHindi,
      'question_hindi_solution': questionHindiSolution,
      'status': status,
      'spend_time': spendTime,
      'selected_ans': selectedAns,
      'visit_status': visitStatus,
      'ans_status': ansStatus,
      'review_status': reviewStatus,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
  /*factory GetTestQuestionByTidQidModel.fromMap(Map<String, dynamic> map) {
    return GetTestQuestionByTidQidModel(
      id: map['id'],
      questionId: map['question_id'],
      queNo: map['que_no'],
      testQuestion: map['test_question'],
      testId: map['test_id'],
      subjectId: map['subject_id'],
      topicId: map['topic_id'],
      type: map['type'],
      questionCorrectAns: map['question_correct_ans'],
      difficulty: map['difficulty'],
      questionEng: map['question_eng'],
      questionEngSolution: map['question_eng_solution'],
      questionHindi: map['question_hindi'],
      questionHindiSolution: map['question_hindi_solution'],
      status: map['status'],
      spendTime: map['spend_time'],
      selectedAns: map['selected_ans'],
      visitStatus: map['visit_status'],
      ansStatus: map['ans_status'],
      reviewStatus: map['review_status'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
      deletedAt: map['deleted_at'],
    );
  }
*/
 /* Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question_id': questionId,
      'que_no': queNo,
      'test_question': testQuestion,
      'test_id': testId,
      'subject_id': subjectId,
      'topic_id': topicId,
      'type': type,
      'question_correct_ans': questionCorrectAns,
      'difficulty': difficulty,
      'question_eng': questionEng,
      'question_eng_solution': questionEngSolution,
      'question_hindi': questionHindi,
      'question_hindi_solution': questionHindiSolution,
      'status': status,
      'spend_time': spendTime,
      'selected_ans': selectedAns,
      'visit_status': visitStatus,
      'ans_status': ansStatus,
      'review_status': reviewStatus,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }*/
}
