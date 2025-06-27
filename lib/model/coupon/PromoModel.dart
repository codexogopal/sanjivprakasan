class PromoModel {
  final int promoId;
  final String promoName;
  final String promoCouponCode;
  final String promoValidFrom;
  final String promoValidTo;
  final String promoDiscountType;
  final String promoDiscountIn;
  final String promoAmount;
  final String promoDescription;
  final String promoUsageLimit;
  final String promoUsageUserLimit;
  final String promoMinimumPurchase;
  final int promoStatus;
  final String createdAt;
  final String updatedAt;

  PromoModel({
    required this.promoId,
    required this.promoName,
    required this.promoCouponCode,
    required this.promoValidFrom,
    required this.promoValidTo,
    required this.promoDiscountType,
    required this.promoDiscountIn,
    required this.promoAmount,
    required this.promoDescription,
    required this.promoUsageLimit,
    required this.promoUsageUserLimit,
    required this.promoMinimumPurchase,
    required this.promoStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PromoModel.fromJson(Map<String, dynamic> json) {
    return PromoModel(
      promoId: json['promo_id'] ?? 0,
      promoName: json['promo_name'] ?? "",
      promoCouponCode: json['promo_coupon_code'] ?? "",
      promoValidFrom: json['promo_valid_from'] ?? "",
      promoValidTo: json['promo_valid_to'] ?? "",
      promoDiscountType: json['promo_discount_type'] ?? "",
      promoDiscountIn: json['promo_discount_in'] ?? "",
      promoAmount: json['promo_amount'] ?? "",
      promoDescription: json['promo_description'] ?? "",
      promoUsageLimit: json['promo_usage_limit'] ?? "",
      promoUsageUserLimit: json['promo_usage_user_limit'] ?? "",
      promoMinimumPurchase: json['promo_minimum_purchase'] ?? "",
      promoStatus: json['promo_status'] ?? 0,
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'promo_id': promoId,
      'promo_name': promoName,
      'promo_coupon_code': promoCouponCode,
      'promo_valid_from': promoValidFrom,
      'promo_valid_to': promoValidTo,
      'promo_discount_type': promoDiscountType,
      'promo_discount_in': promoDiscountIn,
      'promo_amount': promoAmount,
      'promo_description': promoDescription,
      'promo_usage_limit': promoUsageLimit,
      'promo_usage_user_limit': promoUsageUserLimit,
      'promo_minimum_purchase': promoMinimumPurchase,
      'promo_status': promoStatus,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
