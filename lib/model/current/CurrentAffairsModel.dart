class CurrentAffairsModel {
  final int currentAffairsId;
  final String currentAffairsName;
  final String currentAffairsPdf;
  final int currentAffairsStatus;
  final int currentAffairsOrder;
  final String createdAt;
  final String updatedAt;

  CurrentAffairsModel({
    required this.currentAffairsId,
    required this.currentAffairsName,
    required this.currentAffairsPdf,
    required this.currentAffairsStatus,
    required this.currentAffairsOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CurrentAffairsModel.fromJson(Map<String, dynamic> json) {
    return CurrentAffairsModel(
      currentAffairsId: json['current_affairs_id'] ?? 0,
      currentAffairsName: json['current_affairs_name'] ?? "",
      currentAffairsPdf: json['current_affairs_pdf'] ?? "",
      currentAffairsStatus: json['current_affairs_status'] ?? 0,
      currentAffairsOrder: json['current_affairs_order'] ?? 0,
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_affairs_id': currentAffairsId,
      'current_affairs_name': currentAffairsName,
      'current_affairs_pdf': currentAffairsPdf,
      'current_affairs_status': currentAffairsStatus,
      'current_affairs_order': currentAffairsOrder,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
