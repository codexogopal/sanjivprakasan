import '../books/ProductModel.dart';

class CartItemModel {
  final int cartId;
  final int cartUserId;
  final int cartProductId;
  final int cartProductType;
  final int cartPvId;
  final int cartQty;
  final String cartDiscount;
  final String cartDiscountPer;
  final String cartMrpPrice;
  final String cartSellPrice;
  final String updatedAt;
  final String createdAt;
  final ProductModel product;

  CartItemModel({
    required this.cartId,
    required this.cartUserId,
    required this.cartProductId,
    required this.cartProductType,
    required this.cartPvId,
    required this.cartQty,
    required this.cartDiscount,
    required this.cartDiscountPer,
    required this.cartMrpPrice,
    required this.cartSellPrice,
    required this.updatedAt,
    required this.createdAt,
    required this.product,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      cartId: json['cart_id'] ?? 0,
      cartUserId: json['cart_user_id'] ?? 0,
      cartProductId: json['cart_product_id'] ?? 0,
      cartProductType: json['cart_product_type'] ?? 0,
      cartPvId: json['cart_pv_id'] ?? 0,
      cartQty: json['cart_qty'] ?? 0,
      cartDiscount: json['cart_discount'] ?? "",
      cartDiscountPer: json['cart_discount_per'] ?? "",
      cartMrpPrice: json['cart_mrp_price'] ?? "",
      cartSellPrice: json['cart_sell_price'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      createdAt: json['created_at'] ?? "",
      product: ProductModel.fromJson(json["product"])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cart_id': cartId,
      'cart_user_id': cartUserId,
      'cart_product_id': cartProductId,
      'cart_product_type': cartProductType,
      'cart_pv_id': cartPvId,
      'cart_qty': cartQty,
      'cart_discount': cartDiscount,
      'cart_discount_per': cartDiscountPer,
      'cart_mrp_price': cartMrpPrice,
      'cart_sell_price': cartSellPrice,
      'updated_at': updatedAt,
      'created_at': createdAt,
      'product': product,
    };
  }
}
