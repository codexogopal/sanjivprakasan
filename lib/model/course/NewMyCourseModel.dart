class NewMyCourseModel {
  int? ucId;
  int? ucUserId;
  int? ucCourseId;
  String? ucCourseName;
  int? ucCourseValidity;
  String? createdAt;
  String? updatedAt;
  bool? courseExpired;
  BelongsToCsCourses? belongsToCsCourses;

  NewMyCourseModel({
    this.ucId,
    this.ucUserId,
    this.ucCourseId,
    this.ucCourseName,
    this.ucCourseValidity,
    this.createdAt,
    this.updatedAt,
    this.courseExpired,
    this.belongsToCsCourses,
  });

  factory NewMyCourseModel.fromJson(Map<String, dynamic> json) {
    return NewMyCourseModel(
      ucId: json['uc_id'],
      ucUserId: json['uc_user_id'],
      ucCourseId: json['uc_course_id'],
      ucCourseName: json['uc_course_name'],
      ucCourseValidity: json['uc_course_validity'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      courseExpired: json['course_expired'],
      belongsToCsCourses: json['belongs_to_cs_courses'] != null
          ? BelongsToCsCourses.fromJson(json['belongs_to_cs_courses'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uc_id': ucId,
      'uc_user_id': ucUserId,
      'uc_course_id': ucCourseId,
      'uc_course_name': ucCourseName,
      'uc_course_validity': ucCourseValidity,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'course_expired': courseExpired,
      'belongs_to_cs_courses': belongsToCsCourses?.toJson(),
    };
  }
}

class BelongsToCsCourses {
  int? coursesId;
  String? coursesName;
  String? coursesDescription;
  dynamic courseType;
  dynamic coursesClassSize;
  dynamic coursesTimeDuration;
  String? coursesImage;
  int? coursesStatus;
  int? coursesFeatured;
  dynamic coursesLogoImage;
  String? coursesShortDescription;
  dynamic classTimeDuration;
  String? coursesCategories;
  dynamic coursesSlug;
  dynamic coursesMeta;
  dynamic coursesMetaDesc;
  dynamic coursesMetaKeyword;
  String? coursesPrice;
  String? courseDiscountPrice;
  String? courseActualPrice;
  String? courseValidity;
  String? coursePdf;
  String? createdAt;
  String? updatedAt;

  BelongsToCsCourses({
    this.coursesId,
    this.coursesName,
    this.coursesDescription,
    this.courseType,
    this.coursesClassSize,
    this.coursesTimeDuration,
    this.coursesImage,
    this.coursesStatus,
    this.coursesFeatured,
    this.coursesLogoImage,
    this.coursesShortDescription,
    this.classTimeDuration,
    this.coursesCategories,
    this.coursesSlug,
    this.coursesMeta,
    this.coursesMetaDesc,
    this.coursesMetaKeyword,
    this.coursesPrice,
    this.courseDiscountPrice,
    this.courseActualPrice,
    this.courseValidity,
    this.coursePdf,
    this.createdAt,
    this.updatedAt,
  });

  factory BelongsToCsCourses.fromJson(Map<String, dynamic> json) {
    return BelongsToCsCourses(
      coursesId: json['courses_id'],
      coursesName: json['courses_name'],
      coursesDescription: json['courses_description'],
      courseType: json['course_type'],
      coursesClassSize: json['courses_class_size'],
      coursesTimeDuration: json['courses_time_duration'],
      coursesImage: json['courses_image'],
      coursesStatus: json['courses_status'],
      coursesFeatured: json['courses_featured'],
      coursesLogoImage: json['courses_logo_image'],
      coursesShortDescription: json['courses_short_description'],
      classTimeDuration: json['class_time_duration'],
      coursesCategories: json['courses_categories'],
      coursesSlug: json['courses_slug'],
      coursesMeta: json['courses_meta'],
      coursesMetaDesc: json['courses_meta_desc'],
      coursesMetaKeyword: json['courses_meta_keyword'],
      coursesPrice: json['courses_price'],
      courseDiscountPrice: json['course_discount_price'],
      courseActualPrice: json['course_actual_price'],
      courseValidity: json['course_validity'],
      coursePdf: json['course_pdf'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courses_id': coursesId,
      'courses_name': coursesName,
      'courses_description': coursesDescription,
      'course_type': courseType,
      'courses_class_size': coursesClassSize,
      'courses_time_duration': coursesTimeDuration,
      'courses_image': coursesImage,
      'courses_status': coursesStatus,
      'courses_featured': coursesFeatured,
      'courses_logo_image': coursesLogoImage,
      'courses_short_description': coursesShortDescription,
      'class_time_duration': classTimeDuration,
      'courses_categories': coursesCategories,
      'courses_slug': coursesSlug,
      'courses_meta': coursesMeta,
      'courses_meta_desc': coursesMetaDesc,
      'courses_meta_keyword': coursesMetaKeyword,
      'courses_price': coursesPrice,
      'course_discount_price': courseDiscountPrice,
      'course_actual_price': courseActualPrice,
      'course_validity': courseValidity,
      'course_pdf': coursePdf,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}