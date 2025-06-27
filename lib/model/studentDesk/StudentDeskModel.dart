// student_desk_model.dart
class StudentDeskModel {
  final MenuItem menu;

  StudentDeskModel({required this.menu});

  factory StudentDeskModel.fromJson(Map<String, dynamic> json) {
    return StudentDeskModel(
      menu: MenuItem.fromJson(json),
    );
  }
}

class MenuItem {
  final int menuId;
  final String menuName;
  final String menuSlug;
  final int menuCategoryid;
  final int menuPageid;
  final String? menuCustomlink;
  final int menuParent;
  final int menuOrder;
  final int menuStatus;
  final String createdAt;
  final String updatedAt;
  final List<MenuItem>? children;
  final List<SubMenuItem>? subchildren;
  final PageModel? pages;

  MenuItem({
    required this.menuId,
    required this.menuName,
    required this.menuSlug,
    required this.menuCategoryid,
    required this.menuPageid,
    this.menuCustomlink,
    required this.menuParent,
    required this.menuOrder,
    required this.menuStatus,
    required this.createdAt,
    required this.updatedAt,
    this.children,
    this.subchildren,
    this.pages,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      menuId: json['menu_id'] ?? 0,
      menuName: json['menu_name'] ?? "",
      menuSlug: json['menu_slug'] ?? "",
      menuCategoryid: json['menu_categoryid'] ?? 0,
      menuPageid: json['menu_pageid'] ?? 0,
      menuCustomlink: json['menu_customlink'] ?? "",
      menuParent: json['menu_parent'] ?? 0,
      menuOrder: json['menu_order'] ?? 0,
      menuStatus: json['menu_status'] ?? 0,
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      children: json['children'] != null
          ? (json['children'] as List).map((child) => MenuItem.fromJson(child)).toList()
          : null,
      subchildren: json['subchildren'] != null
          ? (json['subchildren'] as List).map((subchild) => SubMenuItem.fromJson(subchild)).toList()
          : null,
      pages: json['pages'] != null ? PageModel.fromJson(json['pages']) : null,
    );
  }
}

class SubMenuItem extends MenuItem {
  SubMenuItem({
    required super.menuId,
    required super.menuName,
    required super.menuSlug,
    required super.menuCategoryid,
    required super.menuPageid,
    super.menuCustomlink,
    required super.menuParent,
    required super.menuOrder,
    required super.menuStatus,
    required super.createdAt,
    required super.updatedAt,
    super.children,
    super.subchildren,
    super.pages,
  });

  factory SubMenuItem.fromJson(Map<String, dynamic> json) {
    return SubMenuItem(
      menuId: json['menu_id'] ?? 0,
      menuName: json['menu_name'] ?? "",
      menuSlug: json['menu_slug'] ?? "",
      menuCategoryid: json['menu_categoryid'] ?? 0,
      menuPageid: json['menu_pageid'] ?? 0,
      menuCustomlink: json['menu_customlink'] ?? "",
      menuParent: json['menu_parent'] ?? 0,
      menuOrder: json['menu_order'] ?? 0,
      menuStatus: json['menu_status'] ?? 0,
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      pages: json['pages'] != null ? PageModel.fromJson(json['pages']) : null,
    );
  }
}

class PageModel {
  final int pageId;
  final String pageName;
  final String pageUrl;
  final int pageSidebar;
  final String pageContent;
  final String pageMetaTitle;
  final String? pageMetaDesc;
  final String? pageMetaKeyword;
  final int pageStatus;
  final String createdAt;
  final String updatedAt;

  PageModel({
    required this.pageId,
    required this.pageName,
    required this.pageUrl,
    required this.pageSidebar,
    required this.pageContent,
    required this.pageMetaTitle,
    this.pageMetaDesc,
    this.pageMetaKeyword,
    required this.pageStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PageModel.fromJson(Map<String, dynamic> json) {
    return PageModel(
      pageId: json['page_id'] ?? 0,
      pageName: json['page_name'] ?? "",
      pageUrl: json['page_url'] ?? "",
      pageSidebar: json['page_sidebar'] ?? 0,
      pageContent: json['page_content'] ?? "",
      pageMetaTitle: json['page_meta_title'] ?? "",
      pageMetaDesc: json['page_meta_desc'] ?? "",
      pageMetaKeyword: json['page_meta_keyword'] ?? "",
      pageStatus: json['page_status'] ?? 0,
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
    );
  }
}


/*
// student_desk_model.dart
class StudentDeskModel {
  final MenuItem menu;

  StudentDeskModel({required this.menu});

  factory StudentDeskModel.fromJson(Map<String, dynamic> json) {
    return StudentDeskModel(
      menu: MenuItem.fromJson(json),
    );
  }
}

class MenuItem {
  final int menuId;
  final String menuName;
  final String menuSlug;
  final int menuCategoryid;
  final int menuPageid;
  final String? menuCustomlink;
  final int menuParent;
  final int menuOrder;
  final int menuStatus;
  final String createdAt;
  final String updatedAt;
  final List<MenuItem>? children;

  MenuItem({
    required this.menuId,
    required this.menuName,
    required this.menuSlug,
    required this.menuCategoryid,
    required this.menuPageid,
    this.menuCustomlink,
    required this.menuParent,
    required this.menuOrder,
    required this.menuStatus,
    required this.createdAt,
    required this.updatedAt,
    this.children,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      menuId: json['menu_id'] ?? 0,
      menuName: json['menu_name'] ?? "",
      menuSlug: json['menu_slug'] ?? "",
      menuCategoryid: json['menu_categoryid'] ?? 0,
      menuPageid: json['menu_pageid'] ?? 0,
      menuCustomlink: json['menu_customlink'] ?? ""?,
      menuParent: json['menu_parent'] ?? 0,
      menuOrder: json['menu_order'] ?? 0,
      menuStatus: json['menu_status'] ?? 0,
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      children: json['children'] != null
          ? (json['children'] as List)
          .map((child) => MenuItem.fromJson(child))
          .toList()
          : null,
    );
  }
}

class SubMenuItem extends MenuItem {
  final List<MenuItem>? subchildren;
  final PageModel? pages;

  SubMenuItem({
    required super.menuId,
    required super.menuName,
    required super.menuSlug,
    required super.menuCategoryid,
    required super.menuPageid,
    super.menuCustomlink,
    required super.menuParent,
    required super.menuOrder,
    required super.menuStatus,
    required super.createdAt,
    required super.updatedAt,
    super.children,
    this.subchildren,
    this.pages,
  });

  factory SubMenuItem.fromJson(Map<String, dynamic> json) {
    return SubMenuItem(
      menuId: json['menu_id'] ?? 0,
      menuName: json['menu_name'] ?? "",
      menuSlug: json['menu_slug'] ?? "",
      menuCategoryid: json['menu_categoryid'] ?? 0,
      menuPageid: json['menu_pageid'] ?? 0,
      menuCustomlink: json['menu_customlink'] ?? ""?,
      menuParent: json['menu_parent'] ?? 0,
      menuOrder: json['menu_order'] ?? 0,
      menuStatus: json['menu_status'] ?? 0,
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      subchildren: json['subchildren'] != null
          ? (json['subchildren'] as List)
          .map((subchild) => SubMenuItem.fromJson(subchild))
          .toList()
          : null,
      pages: json['pages'] != null ? PageModel.fromJson(json['pages']) : null,
    );
  }
}

class PageModel {
  final int pageId;
  final String pageName;
  final String pageUrl;
  final int pageSidebar;
  final String pageContent;
  final String pageMetaTitle;
  final String? pageMetaDesc;
  final String? pageMetaKeyword;
  final int pageStatus;
  final String createdAt;
  final String updatedAt;

  PageModel({
    required this.pageId,
    required this.pageName,
    required this.pageUrl,
    required this.pageSidebar,
    required this.pageContent,
    required this.pageMetaTitle,
    this.pageMetaDesc,
    this.pageMetaKeyword,
    required this.pageStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PageModel.fromJson(Map<String, dynamic> json) {
    return PageModel(
      pageId: json['page_id'] ?? 0,
      pageName: json['page_name'] ?? "",
      pageUrl: json['page_url'] ?? "",
      pageSidebar: json['page_sidebar'] ?? 0,
      pageContent: json['page_content'] ?? "",
      pageMetaTitle: json['page_meta_title'] ?? "",
      pageMetaDesc: json['page_meta_desc'] ?? ""?,
      pageMetaKeyword: json['page_meta_keyword'] ?? ""?,
      pageStatus: json['page_status'] ?? 0,
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
    );
  }
}*/
