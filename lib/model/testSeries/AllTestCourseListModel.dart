class AllTestCourseListModel {
  final int subPackId;
  final String subPackTitle;
  final int subType;
  final int subPackType;
  final int subPackOrder;
  final String subPackSmcatId;
  final String subPackValidity;
  final int? subPackRefamount;
  final int? subPackRefcashback;
  final String subPackDesc;
  final String? subPackShortDesc;
  final String subPackPrice;
  final String courseDiscountPrice;
  final String subActualPrice;
  final String subPackNoTest;
  final int subPackStatus;
  final String subPackImage;
  final String subPackBgimage;
  final String createdAt;

  AllTestCourseListModel({
    required this.subPackId,
    required this.subPackTitle,
    required this.subType,
    required this.subPackType,
    required this.subPackOrder,
    required this.subPackSmcatId,
    required this.subPackValidity,
    this.subPackRefamount,
    this.subPackRefcashback,
    required this.subPackDesc,
    this.subPackShortDesc,
    required this.subPackPrice,
    required this.courseDiscountPrice,
    required this.subActualPrice,
    required this.subPackNoTest,
    required this.subPackStatus,
    required this.subPackImage,
    required this.subPackBgimage,
    required this.createdAt,
  });

  factory AllTestCourseListModel.fromJson(Map<String, dynamic> json) {
    return AllTestCourseListModel(
      subPackId: json['sub_pack_id'],
      subPackTitle: json['sub_pack_title'] ?? "",
      subType: json['sub_type'] ?? 0,
      subPackType: json['sub_pack_type'] ?? 0,
      subPackOrder: json['sub_pack_order'] ?? 0,
      subPackSmcatId: json['sub_pack_smcat_id'] ?? "",
      subPackValidity: json['sub_pack_validity'] ?? "",
      subPackRefamount: json['sub_pack_refamount'] ?? 0,
      subPackRefcashback: json['sub_pack_refcashback'] ?? 0,
      subPackDesc: json['sub_pack_desc'] ?? "",
      subPackShortDesc: json['sub_pack_short_desc'] ?? "",
      subPackPrice: json['sub_pack_price'] ?? "",
      courseDiscountPrice: json['course_discount_price'] ?? "",
      subActualPrice: json['sub_actual_price'] ?? "",
      subPackNoTest: json['sub_pack_no_test'] ?? "",
      subPackStatus: json['sub_pack_status'] ?? 0,
      subPackImage: json['sub_pack_image'] ?? "",
      subPackBgimage: json['sub_pack_bgimage'] ?? "",
      createdAt: json['created_at'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sub_pack_id': subPackId,
      'sub_pack_title': subPackTitle,
      'sub_type': subType,
      'sub_pack_type': subPackType,
      'sub_pack_order': subPackOrder,
      'sub_pack_smcat_id': subPackSmcatId,
      'sub_pack_validity': subPackValidity,
      'sub_pack_refamount': subPackRefamount,
      'sub_pack_refcashback': subPackRefcashback,
      'sub_pack_desc': subPackDesc,
      'sub_pack_short_desc': subPackShortDesc,
      'sub_pack_price': subPackPrice,
      'course_discount_price': courseDiscountPrice,
      'sub_actual_price': subActualPrice,
      'sub_pack_no_test': subPackNoTest,
      'sub_pack_status': subPackStatus,
      'sub_pack_image': subPackImage,
      'sub_pack_bgimage': subPackBgimage,
      'created_at': createdAt,
    };
  }
}
