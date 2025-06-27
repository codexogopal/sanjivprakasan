class CsSubjects {
  int subjectId;
  String subjectName;
  int subjectTopicId;
  String subjectTopicName;
  int subjectOrder;
  int subjectStatus;
  String subjectSlug;
  String createdAt;
  String updatedAt;

  CsSubjects({
    required this.subjectId,
    required this.subjectName,
    required this.subjectTopicId,
    required this.subjectTopicName,
    required this.subjectOrder,
    required this.subjectStatus,
    required this.subjectSlug,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CsSubjects.fromJson(Map<String, dynamic> json) {
    return CsSubjects(
      subjectId: _parseInt(json['subject_id']) ?? 0,
      subjectName: json['subject_name']?.toString() ?? "",
      subjectTopicId: _parseInt(json['subject_topic_id']) ?? 0,
      subjectTopicName: json['subject_topic_name']?.toString() ?? "",
      subjectOrder: _parseInt(json['subject_order']) ?? 0,
      subjectStatus: _parseInt(json['subject_status']) ?? 0,
      subjectSlug: json['subject_slug']?.toString() ?? "",
      createdAt: json['created_at']?.toString() ?? "",
      updatedAt: json['updated_at']?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subject_id'] = subjectId;
    data['subject_name'] = subjectName;
    data['subject_topic_id'] = subjectTopicId;
    data['subject_topic_name'] = subjectTopicName;
    data['subject_order'] = subjectOrder;
    data['subject_status'] = subjectStatus;
    data['subject_slug'] = subjectSlug;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
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
class CsSubjects {
  int subjectId;
  String subjectName;
  dynamic subjectTopicId;
  dynamic subjectTopicName;
  int subjectOrder;
  int subjectStatus;
  String subjectSlug;
  String createdAt;
  String updatedAt;

  CsSubjects({
    required this.subjectId,
    required this.subjectName,
    this.subjectTopicId,
    this.subjectTopicName,
    required this.subjectOrder,
    required this.subjectStatus,
    required this.subjectSlug,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CsSubjects.fromJson(Map<String, dynamic> json) {
    return CsSubjects(
      subjectId: json['subject_id'] ?? 0,
      subjectName: json['subject_name'] ?? "",
      subjectTopicId: json['subject_topic_id'] ?? 0,
      subjectTopicName: json['subject_topic_name'] ?? "",
      subjectOrder: json['subject_order'] ?? 0,
      subjectStatus: json['subject_status'] ?? 0,
      subjectSlug: json['subject_slug'] ?? "",
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subject_id'] = subjectId;
    data['subject_name'] = subjectName;
    data['subject_topic_id'] = subjectTopicId;
    data['subject_topic_name'] = subjectTopicName;
    data['subject_order'] = subjectOrder;
    data['subject_status'] = subjectStatus;
    data['subject_slug'] = subjectSlug;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}*/
