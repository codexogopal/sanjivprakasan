class OrderHistoryModel {
  final int transId;
  final int transEbookInvoice;
  final int transPhyInvoice;
  final String? transTrackingId;
  final String? transTrackingUrl;
  final String transDatetime;
  final String transOrderNumber;
  final String transUserEmail;
  final int transUserId;
  final String transAmt;
  final int transShippingAmount;
  final int transStatus;
  final String transMethod;
  final String transBillingAddress;
  final String transCity;
  final String transState;
  final int transPincode;
  final int transPaymentStatus;
  final String transRefId;
  final String transDiscountAmount;
  final String transCouponId;
  final String? transDeliveryDate;
  final String transDeliveryAddress;
  final String transDeliveryAmount;
  final String transRating;
  final String? transComment;
  final String? transReviewDatetime;
  final String transRedeemAmount;
  final String transCashbackAmount;
  final String? invoicePdfFile;
  final String transUserName;
  final String transUserMobile;
  final String transCouponCode;
  final String transCouponDisAmt;
  final String? transTipAmount;
  final String? transCartTotal;
  final String? transCancelReason;
  final String? deliveryType;
  final String? transRatingOrder;
  final String? transCommentOrder;
  final String? transCancellationCharge;
  final String? transCancelPaidStatus;
  final String? transNoReview;
  final String? transCancellationPaid;
  final int transAddressId;
  final String transCurrency;
  final String? transCancellationDate;
  final String? transReturnReason;
  final String? transReturnDate;
  final String? transExchangeDate;
  final String? transExchangeStatus;
  final int transNotRead;
  final String transGstAmt;
  final int transType;
  final String createdAt;
  final String updatedAt;
  final String orderStatus;
  final int itemsCount;

  OrderHistoryModel({
    required this.transId,
    required this.transEbookInvoice,
    required this.transPhyInvoice,
    this.transTrackingId,
    this.transTrackingUrl,
    required this.transDatetime,
    required this.transOrderNumber,
    required this.transUserEmail,
    required this.transUserId,
    required this.transAmt,
    required this.transShippingAmount,
    required this.transStatus,
    required this.transMethod,
    required this.transBillingAddress,
    required this.transCity,
    required this.transState,
    required this.transPincode,
    required this.transPaymentStatus,
    required this.transRefId,
    required this.transDiscountAmount,
    required this.transCouponId,
    this.transDeliveryDate,
    required this.transDeliveryAddress,
    required this.transDeliveryAmount,
    required this.transRating,
    this.transComment,
    this.transReviewDatetime,
    required this.transRedeemAmount,
    required this.transCashbackAmount,
    this.invoicePdfFile,
    required this.transUserName,
    required this.transUserMobile,
    required this.transCouponCode,
    required this.transCouponDisAmt,
    this.transTipAmount,
    this.transCartTotal,
    this.transCancelReason,
    this.deliveryType,
    this.transRatingOrder,
    this.transCommentOrder,
    this.transCancellationCharge,
    this.transCancelPaidStatus,
    this.transNoReview,
    this.transCancellationPaid,
    required this.transAddressId,
    required this.transCurrency,
    this.transCancellationDate,
    this.transReturnReason,
    this.transReturnDate,
    this.transExchangeDate,
    this.transExchangeStatus,
    required this.transNotRead,
    required this.transGstAmt,
    required this.transType,
    required this.createdAt,
    required this.updatedAt,
    required this.orderStatus,
    required this.itemsCount,
  });

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) {
    return OrderHistoryModel(
      transId: json['trans_id'] ?? 0,
      transEbookInvoice: json['trans_ebook_invoice'] ?? 0,
      transPhyInvoice: json['trans_phy_invoice'] ?? 0,
      transTrackingId: json['trans_tracking_id'] ?? "",
      transTrackingUrl: json['trans_tracking_url'] ?? "",
      transDatetime: json['trans_datetime'] ?? "",
      transOrderNumber: json['trans_order_number'] ?? "",
      transUserEmail: json['trans_user_email'] ?? "",
      transUserId: json['trans_user_id'] ?? 0,
      transAmt: json['trans_amt'] ?? "0.00",
      transShippingAmount: json['trans_shipping_amount'] ?? 0,
      transStatus: json['trans_status'] ?? 0,
      transMethod: json['trans_method'] ?? "",
      transBillingAddress: json['trans_billing_address'] ?? "",
      transCity: json['trans_city'] ?? "",
      transState: json['trans_state'] ?? "",
      transPincode: json['trans_pincode'] ?? "",
      transPaymentStatus: json['trans_payment_status'] ?? 0,
      transRefId: json['trans_ref_id'] ?? "",
      transDiscountAmount: json['trans_discount_amount'] ?? "",
      transCouponId: json['trans_coupon_id'] ?? "",
      transDeliveryDate: json['trans_delivery_date'] ?? "",
      transDeliveryAddress: json['trans_delivery_address'] ?? "",
      transDeliveryAmount: json['trans_delivery_amount'] ?? "",
      transRating: json['trans_rating'] ?? "",
      transComment: json['trans_comment'] ?? "",
      transReviewDatetime: json['trans_review_datetime'] ?? "",
      transRedeemAmount: json['trans_redeem_amount'] ?? "",
      transCashbackAmount: json['trans_cashback_amount'] ?? "",
      invoicePdfFile: json['invoice_pdf_file'] ?? "",
      transUserName: json['trans_user_name'] ?? "",
      transUserMobile: json['trans_user_mobile'] ?? "",
      transCouponCode: json['trans_coupon_code'] ?? "",
      transCouponDisAmt: json['trans_coupon_dis_amt'] ?? "",
      transTipAmount: json['trans_tip_amount'] ?? "",
      transCartTotal: json['trans_cart_total'] ?? "",
      transCancelReason: json['trans_cancel_reason'],
      deliveryType: json['delivery_type'] ?? "",
      transRatingOrder: json['trans_rating_order'] ?? "",
      transCommentOrder: json['trans_comment_order'] ?? "",
      transCancellationCharge: json['trans_cancallation_charge'] ?? "",
      transCancelPaidStatus: json['trans_cancel_paidstatus'] ?? "",
      transNoReview: json['trans_noreview'] ?? "",
      transCancellationPaid: json['trans_cancellation_paid'] ?? "",
      transAddressId: json['trans_address_id'] ?? 0,
      transCurrency: json['trans_currency'] ?? "",
      transCancellationDate: json['trans_cancellation_date'] ?? "",
      transReturnReason: json['trans_return_reason'] ?? "",
      transReturnDate: json['trans_return_date'] ?? "",
      transExchangeDate: json['trans_exchange_date'] ?? "",
      transExchangeStatus: json['trans_exchange_status'] ?? "",
      transNotRead: json['trans_not_read'] ?? 0,
      transGstAmt: json['trans_gst_amt'] ?? "",
      transType: json['trans_type'] ?? 0,
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      orderStatus: json['orderstatus'] ?? "",
      itemsCount: json['itemscount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trans_id': transId,
      'trans_ebook_invoice': transEbookInvoice,
      'trans_phy_invoice': transPhyInvoice,
      'trans_tracking_id': transTrackingId,
      'trans_tracking_url': transTrackingUrl,
      'trans_datetime': transDatetime,
      'trans_order_number': transOrderNumber,
      'trans_user_email': transUserEmail,
      'trans_user_id': transUserId,
      'trans_amt': transAmt,
      'trans_shipping_amount': transShippingAmount,
      'trans_status': transStatus,
      'trans_method': transMethod,
      'trans_billing_address': transBillingAddress,
      'trans_city': transCity,
      'trans_state': transState,
      'trans_pincode': transPincode,
      'trans_payment_status': transPaymentStatus,
      'trans_ref_id': transRefId,
      'trans_discount_amount': transDiscountAmount,
      'trans_coupon_id': transCouponId,
      'trans_delivery_date': transDeliveryDate,
      'trans_delivery_address': transDeliveryAddress,
      'trans_delivery_amount': transDeliveryAmount,
      'trans_rating': transRating,
      'trans_comment': transComment,
      'trans_review_datetime': transReviewDatetime,
      'trans_redeem_amount': transRedeemAmount,
      'trans_cashback_amount': transCashbackAmount,
      'invoice_pdf_file': invoicePdfFile,
      'trans_user_name': transUserName,
      'trans_user_mobile': transUserMobile,
      'trans_coupon_code': transCouponCode,
      'trans_coupon_dis_amt': transCouponDisAmt,
      'trans_tip_amount': transTipAmount,
      'trans_cart_total': transCartTotal,
      'trans_cancel_reason': transCancelReason,
      'delivery_type': deliveryType,
      'trans_rating_order': transRatingOrder,
      'trans_comment_order': transCommentOrder,
      'trans_cancallation_charge': transCancellationCharge,
      'trans_cancel_paidstatus': transCancelPaidStatus,
      'trans_noreview': transNoReview,
      'trans_cancellation_paid': transCancellationPaid,
      'trans_address_id': transAddressId,
      'trans_currency': transCurrency,
      'trans_cancellation_date': transCancellationDate,
      'trans_return_reason': transReturnReason,
      'trans_return_date': transReturnDate,
      'trans_exchange_date': transExchangeDate,
      'trans_exchange_status': transExchangeStatus,
      'trans_not_read': transNotRead,
      'trans_gst_amt': transGstAmt,
      'trans_type': transType,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'orderstatus': orderStatus,
      'itemscount': itemsCount,
    };
  }
}
