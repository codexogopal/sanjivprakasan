import 'ProductModel.dart';

class ChildCategoryModel {
  final int catId;
  final String catUniqueId;
  final String catName;
  final int catParent;
  final int catOrder;
  final String createdAt;
  final String updatedAt;
  final int catStatus;
  final String? catImage;
  final String? catDesc;
  final String catMetaTitle;
  final String? catMetaKeyword;
  final String? catMetaDesc;
  final String catSlug;
  final int catShowOnAppHome;
  final int catShowOnHome;
  final int catFeatured;
  final String catShippingPrice;
  final String catFreePerBookShip;
  final List<ProductModel> products;

  ChildCategoryModel({
    required this.catId,
    required this.catUniqueId,
    required this.catName,
    required this.catParent,
    required this.catOrder,
    required this.createdAt,
    required this.updatedAt,
    required this.catStatus,
    this.catImage,
    this.catDesc,
    required this.catMetaTitle,
    this.catMetaKeyword,
    this.catMetaDesc,
    required this.catSlug,
    required this.catShowOnAppHome,
    required this.catShowOnHome,
    required this.catFeatured,
    required this.catShippingPrice,
    required this.catFreePerBookShip,
    required this.products,
  });

  factory ChildCategoryModel.fromJson(Map<String, dynamic> json) => ChildCategoryModel(
    catId: json["cat_id"] ?? 0,
    catUniqueId: json["cat_uniqueid"] ?? "",
    catName: json["cat_name"] ?? "",
    catParent: json["cat_parent"] ?? 0,
    catOrder: json["cat_order"] ?? 0,
    createdAt: json["created_at"] ?? "",
    updatedAt: json["updated_at"] ?? "",
    catStatus: json["cat_status"] ?? 0,
    catImage: json["cat_image"],
    catDesc: json["cat_desc"],
    catMetaTitle: json["cat_meta_title"] ?? "",
    catMetaKeyword: json["cat_meta_keyword"],
    catMetaDesc: json["cat_meta_desc"],
    catSlug: json["cat_slug"] ?? "",
    catShowOnAppHome: json["cat_show_on_app_home"] ?? 0,
    catShowOnHome: json["cat_show_on_home"] ?? 0,
    catFeatured: json["cat_featured"] ?? 0,
    catShippingPrice: json["cat_shippingprice"] ?? "",
    catFreePerBookShip: json["cat_freeperbook_ship"] ?? "",
    products: (json["products"] as List?)?.map((e) => ProductModel.fromJson(e)).toList() ?? [],
  );


/*  factory ChildCategoryModel.fromJson(Map<String, dynamic> json) => ChildCategoryModel(
    catId: json["cat_id"] ?? "",
    catUniqueId: json["cat_uniqueid"] ?? "",
    catName: json["cat_name"] ?? "",
    catParent: json["cat_parent"] ?? "",
    catOrder: json["cat_order"] ?? "",
    createdAt: json["created_at"] ?? "",
    updatedAt: json["updated_at"] ?? "",
    catStatus: json["cat_status"] ?? "",
    catImage: json["cat_image"] ?? "",
    catDesc: json["cat_desc"] ?? "",
    catMetaTitle: json["cat_meta_title"] ?? "",
    catMetaKeyword: json["cat_meta_keyword"] ?? "",
    catMetaDesc: json["cat_meta_desc"] ?? "",
    catSlug: json["cat_slug"] ?? "",
    catShowOnAppHome: json["cat_show_on_app_home"] ?? "",
    catShowOnHome: json["cat_show_on_home"] ?? "",
    catFeatured: json["cat_featured"] ?? "",
    catShippingPrice: json["cat_shippingprice"] ?? "",
    catFreePerBookShip: json["cat_freeperbook_ship"] ?? "",
    products: (json["products"] as List<dynamic>)
        .map((e) => ProductModel.fromJson(e))
        .toList(),
  );*/
}
