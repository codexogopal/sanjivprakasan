class TSMainCatModel {
  final int courseCategoryId;
  final String courseCategoryName;
  final int courseCategoryParent;
  final dynamic courseCategoryOrder;
  final String? courseCategoryImage;
  final int courseCategoryFeatured;
  final int courseCategoryLevel;
  final int courseCategoryStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ChildCategory> children;

  TSMainCatModel({
    required this.courseCategoryId,
    required this.courseCategoryName,
    required this.courseCategoryParent,
    required this.courseCategoryOrder,
    this.courseCategoryImage,
    required this.courseCategoryFeatured,
    required this.courseCategoryLevel,
    required this.courseCategoryStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.children,
  });

  factory TSMainCatModel.fromJson(Map<String, dynamic> json) {
    return TSMainCatModel(
      courseCategoryId: json['course_category_id'],
      courseCategoryName: json['course_category_name'],
      courseCategoryParent: json['course_category_parent'],
      courseCategoryOrder: json['course_category_order'],
      courseCategoryImage: json['course_category_image'],
      courseCategoryFeatured: json['course_category_featured'],
      courseCategoryLevel: json['course_category_level'],
      courseCategoryStatus: json['course_category_status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      children: (json['children'] as List<dynamic>)
          .map((child) => ChildCategory.fromJson(child))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'course_category_id': courseCategoryId,
      'course_category_name': courseCategoryName,
      'course_category_parent': courseCategoryParent,
      'course_category_order': courseCategoryOrder,
      'course_category_image': courseCategoryImage,
      'course_category_featured': courseCategoryFeatured,
      'course_category_level': courseCategoryLevel,
      'course_category_status': courseCategoryStatus,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'children': children.map((child) => child.toJson()).toList(),
    };
  }
}

class ChildCategory {
  final int courseCategoryId;
  final String courseCategoryName;
  final int courseCategoryParent;
  final dynamic courseCategoryOrder;
  final String? courseCategoryImage;
  final int courseCategoryFeatured;
  final int courseCategoryLevel;
  final int courseCategoryStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<SubChildCategory> subchildren;

  ChildCategory({
    required this.courseCategoryId,
    required this.courseCategoryName,
    required this.courseCategoryParent,
    required this.courseCategoryOrder,
    this.courseCategoryImage,
    required this.courseCategoryFeatured,
    required this.courseCategoryLevel,
    required this.courseCategoryStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.subchildren,
  });

  factory ChildCategory.fromJson(Map<String, dynamic> json) {
    return ChildCategory(
      courseCategoryId: json['course_category_id'],
      courseCategoryName: json['course_category_name'],
      courseCategoryParent: json['course_category_parent'],
      courseCategoryOrder: json['course_category_order'],
      courseCategoryImage: json['course_category_image'],
      courseCategoryFeatured: json['course_category_featured'],
      courseCategoryLevel: json['course_category_level'],
      courseCategoryStatus: json['course_category_status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      subchildren: (json['subchildren'] as List<dynamic>)
          .map((subchild) => SubChildCategory.fromJson(subchild))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'course_category_id': courseCategoryId,
      'course_category_name': courseCategoryName,
      'course_category_parent': courseCategoryParent,
      'course_category_order': courseCategoryOrder,
      'course_category_image': courseCategoryImage,
      'course_category_featured': courseCategoryFeatured,
      'course_category_level': courseCategoryLevel,
      'course_category_status': courseCategoryStatus,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'subchildren': subchildren.map((subchild) => subchild.toJson()).toList(),
    };
  }
}

class SubChildCategory {
  final int courseCategoryId;
  final String courseCategoryName;
  final int courseCategoryParent;
  final dynamic courseCategoryOrder;
  final String? courseCategoryImage;
  final int courseCategoryFeatured;
  final int courseCategoryLevel;
  final int courseCategoryStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  SubChildCategory({
    required this.courseCategoryId,
    required this.courseCategoryName,
    required this.courseCategoryParent,
    required this.courseCategoryOrder,
    this.courseCategoryImage,
    required this.courseCategoryFeatured,
    required this.courseCategoryLevel,
    required this.courseCategoryStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubChildCategory.fromJson(Map<String, dynamic> json) {
    return SubChildCategory(
      courseCategoryId: json['course_category_id'],
      courseCategoryName: json['course_category_name'],
      courseCategoryParent: json['course_category_parent'],
      courseCategoryOrder: json['course_category_order'],
      courseCategoryImage: json['course_category_image'],
      courseCategoryFeatured: json['course_category_featured'],
      courseCategoryLevel: json['course_category_level'],
      courseCategoryStatus: json['course_category_status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'course_category_id': courseCategoryId,
      'course_category_name': courseCategoryName,
      'course_category_parent': courseCategoryParent,
      'course_category_order': courseCategoryOrder,
      'course_category_image': courseCategoryImage,
      'course_category_featured': courseCategoryFeatured,
      'course_category_level': courseCategoryLevel,
      'course_category_status': courseCategoryStatus,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}