class UserCourseListModel {
  final int ucId;
  final int ucUserId;
  final int ucCourseId;
  final String ucCourseName;
  final String createdAt;
  final String updatedAt;
  final BelongsToCSPackage? belongsToCSPackage;

  UserCourseListModel({
    required this.ucId,
    required this.ucUserId,
    required this.ucCourseId,
    required this.ucCourseName,
    required this.createdAt,
    required this.updatedAt,
    this.belongsToCSPackage,
  });

  factory UserCourseListModel.fromJson(Map<String, dynamic> json) {
    return UserCourseListModel(
      ucId: json['utsc_id'],
      ucUserId: json['utsc_user_id'],
      ucCourseId: json['utsc_course_id'],
      ucCourseName: json['utsc_course_name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      belongsToCSPackage: json['belongs_to_cs_package'] != null
          ? BelongsToCSPackage.fromJson(json['belongs_to_cs_package'])
          : BelongsToCSPackage.fromJson(
          {
            "sub_pack_id": 0,
            "sub_pack_title": "",
            "sub_pack_price": "0.00",
            "sub_pack_no_test": "0",
            "sub_pack_validity": "0",
            "created_at": "2025-04-25T06:53:30.000000Z",
            "sub_pack_image": "",
            "sub_pack_status": 0,
            "sub_pack_dept": null,
            "sub_pack_et": null,
            "sub_pack_vcat_id": null,
            "sub_pack_smcat_id": "0",
            "sub_pack_series": null,
            "sub_pack_short_desc": "",
            "sub_pack_desc": "<p></p>",
            "sub_actual_price": "0.00",
            "sub_total_minutes": null,
            "sub_total_question": null,
            "course_category_name": null,
            "sub_pack_background": null,
            "course_highlight": "",
            "sub_pack_no_video": 0,
            "course_categories": null,
            "course_discount_price": "0",
            "sub_popular": null,
            "no_of_pdf": "10",
            "package_detail": "<p></p>",
            "sub_type": null,
            "sub_pack_featured": 1,
            "sub_pack_type": null,
            "sub_pack_bgimage": "",
            "sub_pack_order": 0,
            "sub_pack_slug": null,
            "sub_pack_refamount": null,
            "sub_pack_refcashback": null,
            "updated_at": "2025-05-12T08:09:28.000000Z"
          }
      ),
    );
  }
}

class BelongsToCSPackage {
  final int subPackId;
  final String subPackTitle;
  final String subPackPrice;
  final String subPackNoTest;
  final String subPackValidity;
  final String createdAt;
  final String subPackImage;
  final int subPackStatus;
  final String? subPackDept;
  final String? subPackEt;
  final String? subPackVcatId;
  final String? subPackSmcatId;
  final String? subPackSeries;
  final String subPackShortDesc;
  final String subPackDesc;
  final String subActualPrice;
  final String? subTotalMinutes;
  final String? subTotalQuestion;
  final String? courseCategoryName;
  final String? subPackBackground;
  final String courseHighlight;
  final int? subPackNoVideo;
  final String? courseCategories;
  final String courseDiscountPrice;
  final String? subPopular;
  final String? noOfPdf;
  final String? packageDetail;
  final int? subType;
  final int subPackFeatured;
  final int subPackType;
  final String subPackBgimage;
  final int subPackOrder;
  final String? subPackSlug;
  final String? subPackRefamount;
  final String? subPackRefcashback;
  final String updatedAt;

  BelongsToCSPackage({
    required this.subPackId,
    required this.subPackTitle,
    required this.subPackPrice,
    required this.subPackNoTest,
    required this.subPackValidity,
    required this.createdAt,
    required this.subPackImage,
    required this.subPackStatus,
    this.subPackDept,
    this.subPackEt,
    this.subPackVcatId,
    this.subPackSmcatId,
    this.subPackSeries,
    required this.subPackShortDesc,
    required this.subPackDesc,
    required this.subActualPrice,
    this.subTotalMinutes,
    this.subTotalQuestion,
    this.courseCategoryName,
    this.subPackBackground,
    required this.courseHighlight,
    this.subPackNoVideo,
    this.courseCategories,
    required this.courseDiscountPrice,
    this.subPopular,
    this.noOfPdf,
    this.packageDetail,
    this.subType,
    required this.subPackFeatured,
    required this.subPackType,
    required this.subPackBgimage,
    required this.subPackOrder,
    this.subPackSlug,
    this.subPackRefamount,
    this.subPackRefcashback,
    required this.updatedAt,
  });

  factory BelongsToCSPackage.fromJson(Map<String, dynamic> json) {
    return BelongsToCSPackage(
      subPackId: json['sub_pack_id'] ?? 0,
      subPackTitle: json['sub_pack_title'] ?? "",
      subPackPrice: json['sub_pack_price'] ?? "",
      subPackNoTest: json['sub_pack_no_test'] ?? "",
      subPackValidity: json['sub_pack_validity'] ?? "",
      createdAt: json['created_at'] ?? "",
      subPackImage: json['sub_pack_image'] ?? "",
      subPackStatus: json['sub_pack_status'] ?? 0,
      subPackDept: json['sub_pack_dept'] ?? "",
      subPackEt: json['sub_pack_et'] ?? "",
      subPackVcatId: json['sub_pack_vcat_id'] ?? "",
      subPackSmcatId: json['sub_pack_smcat_id'] ?? "",
      subPackSeries: json['sub_pack_series'] ?? "",
      subPackShortDesc: json['sub_pack_short_desc'] ?? "",
      subPackDesc: json['sub_pack_desc'] ?? "",
      subActualPrice: json['sub_actual_price'] ?? "",
      subTotalMinutes: json['sub_total_minutes'] ?? "",
      subTotalQuestion: json['sub_total_question'] ?? "",
      courseCategoryName: json['course_category_name'] ?? "",
      subPackBackground: json['sub_pack_background'] ?? "",
      courseHighlight: json['course_highlight'] ?? "",
      subPackNoVideo: json['sub_pack_no_video'] ?? 0,
      courseCategories: json['course_categories'] ?? "",
      courseDiscountPrice: json['course_discount_price'] ?? "",
      subPopular: json['sub_popular'] ?? "",
      noOfPdf: json['no_of_pdf'] ?? "",
      packageDetail: json['package_detail'] ?? "",
      subType: json['sub_type'] ?? 0,
      subPackFeatured: json['sub_pack_featured'] ?? 0,
      subPackType: json['sub_pack_type'] ?? 0,
      subPackBgimage: json['sub_pack_bgimage'] ?? "",
      subPackOrder: json['sub_pack_order'] ?? 0,
      subPackSlug: json['sub_pack_slug'] ?? "",
      subPackRefamount: json['sub_pack_refamount'] ?? "",
      subPackRefcashback: json['sub_pack_refcashback'] ?? "",
      updatedAt: json['updated_at'] ?? "",
    );
  }
}
