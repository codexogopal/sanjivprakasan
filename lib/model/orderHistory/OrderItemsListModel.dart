class OrderItemsListModel {
  final int tdId;
  final int tdTransId;
  final int tdItemId;
  final String? tdItemUnit;
  final String? tdItemImg;
  final String? tdItemColor;
  final String tdItemTitle;
  final String tdItemImage;
  final String tdItemNetPrice;
  final String tdItemSelllingPrice;
  final String tdItemQty;
  final String tdItemTotal;
  final String? tdItemWeight;
  final String tdGst;
  final int? tdGstId;
  final int? tdItemType;
  final String? tdShippingAmt;
  final String? createdAt;
  final String? updatedAt;

  OrderItemsListModel({
    required this.tdId,
    required this.tdTransId,
    required this.tdItemId,
    this.tdItemUnit,
    this.tdItemImg,
    this.tdItemColor,
    required this.tdItemTitle,
    required this.tdItemImage,
    required this.tdItemNetPrice,
    required this.tdItemSelllingPrice,
    required this.tdItemQty,
    required this.tdItemTotal,
    this.tdItemWeight,
    required this.tdGst,
    this.tdGstId,
    this.tdItemType,
    this.tdShippingAmt,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderItemsListModel.fromJson(Map<String, dynamic> json) {
    return OrderItemsListModel(
      tdId: json['td_id'] ?? 0,
      tdTransId: json['td_trans_id'] ?? 0,
      tdItemId: json['td_item_id'] ?? 0,
      tdItemUnit: json['td_item_unit'] ?? "",
      tdItemImg: json['td_item_img'] ?? "",
      tdItemColor: json['td_item_color'] ?? "",
      tdItemTitle: json['td_item_title'] ?? "",
      tdItemImage: json['td_item_image'] ?? "",
      tdItemNetPrice: json['td_item_net_price'] ?? "",
      tdItemSelllingPrice: json['td_item_sellling_price'] ?? "",
      tdItemQty: json['td_item_qty'] ?? "",
      tdItemTotal: json['td_item_total'] ?? "",
      tdItemWeight: json['td_item_weight'] ?? "",
      tdGst: json['td_gst'] ?? 0,
      tdGstId: json['td_gst_id'] ?? 0,
      tdItemType: json['td_item_type'] ?? "",
      tdShippingAmt: json['td_shipping_amt'] ?? "",
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'td_id': tdId,
      'td_trans_id': tdTransId,
      'td_item_id': tdItemId,
      'td_item_unit': tdItemUnit,
      'td_item_img': tdItemImg,
      'td_item_color': tdItemColor,
      'td_item_title': tdItemTitle,
      'td_item_image': tdItemImage,
      'td_item_net_price': tdItemNetPrice,
      'td_item_sellling_price': tdItemSelllingPrice,
      'td_item_qty': tdItemQty,
      'td_item_total': tdItemTotal,
      'td_item_weight': tdItemWeight,
      'td_gst': tdGst,
      'td_gst_id': tdGstId,
      'td_item_type': tdItemType,
      'td_shipping_amt': tdShippingAmt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
