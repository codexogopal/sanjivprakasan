import '../course/NewCourseListModel.dart';
import '../course/NewMyCourseModel.dart';
import '../testSeries/AllTestCourseListModel.dart';

class CourseHistroyCTModel {
  final String transId;
  final String transCourseId;
  final String transCourseType;
  final String transCourseName;
  final String transEbookInvoice;
  final String transPhyInvoice;
  final String? transTrackingId;
  final String? transTrackingUrl;
  final String transDatetime;
  final String transOrderNumber;
  final String transUserEmail;
  final String transUserId;
  final String transAmt;
  final String transShippingAmount;
  final String transStatus;
  final String transMethod;
  final String? transBillingAddress;
  final String? transCity;
  final String? transState;
  final String? transPincode;
  final String transPaymentStatus;
  final String transRefId;
  final String transDiscountAmount;
  final String transCouponId;
  final String? transDeliveryDate;
  final String? transDeliveryAddress;
  final String transDeliveryAmount;
  final String transRating;
  final String? transComment;
  final String? transReviewDatetime;
  final String transRedeemAmount;
  final String transCashbackAmount;
  final String? invoicePdfFile;
  final String transUserName;
  final String transUserMobile;
  final String? transCouponCode;
  final String? transCouponDisAmt;
  final String? transTipAmount;
  final String? transCartTotal;
  final String? transCancelReason;
  final String? deliveryType;
  final String? transRatingOrder;
  final String? transCommentOrder;
  final String? transCancellationCharge;
  final String? transCancelPaidstatus;
  final String? transNoreview;
  final String? transCancellationPaid;
  final String? transAddressId;
  final String transCurrency;
  final String? transCancellationDate;
  final String? transReturnReason;
  final String? transReturnDate;
  final String? transExchangeDate;
  final String? transExchangeStatus;
  final String transNotRead;
  final String transGstAmt;
  final String transType;
  final String createdAt;
  final String updatedAt;
  AllTestCourseListModel? belongsToCsTest;
  NewCourseListModel? belongsToCsCourses;

  CourseHistroyCTModel({
    required this.transId,
    required this.transCourseId,
    required this.transCourseType,
    required this.transCourseName,
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
    this.transBillingAddress,
    this.transCity,
    this.transState,
    this.transPincode,
    required this.transPaymentStatus,
    required this.transRefId,
    required this.transDiscountAmount,
    required this.transCouponId,
    this.transDeliveryDate,
    this.transDeliveryAddress,
    required this.transDeliveryAmount,
    required this.transRating,
    this.transComment,
    this.transReviewDatetime,
    required this.transRedeemAmount,
    required this.transCashbackAmount,
    this.invoicePdfFile,
    required this.transUserName,
    required this.transUserMobile,
    this.transCouponCode,
    this.transCouponDisAmt,
    this.transTipAmount,
    this.transCartTotal,
    this.transCancelReason,
    this.deliveryType,
    this.transRatingOrder,
    this.transCommentOrder,
    this.transCancellationCharge,
    this.transCancelPaidstatus,
    this.transNoreview,
    this.transCancellationPaid,
    this.transAddressId,
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
    this.belongsToCsTest,
    this.belongsToCsCourses,
  });

  factory CourseHistroyCTModel.fromJson(Map<String, dynamic> json) {
    return CourseHistroyCTModel(
      transId: json['trans_id']?.toString() ?? "",
      transCourseId: json['trans_course_id']?.toString() ?? "",
      transCourseType: json['trans_course_type']?.toString() ?? "",
      transCourseName: json['trans_course_name']?.toString() ?? "",
      transEbookInvoice: json['trans_ebook_invoice']?.toString() ?? "",
      transPhyInvoice: json['trans_phy_invoice']?.toString() ?? "",
      transTrackingId: json['trans_tracking_id']?.toString(),
      transTrackingUrl: json['trans_tracking_url']?.toString(),
      transDatetime: json['trans_datetime']?.toString() ?? "",
      transOrderNumber: json['trans_order_number']?.toString() ?? "",
      transUserEmail: json['trans_user_email']?.toString() ?? "",
      transUserId: json['trans_user_id']?.toString() ?? "",
      transAmt: json['trans_amt']?.toString() ?? "",
      transShippingAmount: json['trans_shipping_amount']?.toString() ?? "",
      transStatus: json['trans_status']?.toString() ?? "",
      transMethod: json['trans_method']?.toString() ?? "",
      transBillingAddress: json['trans_billing_address']?.toString(),
      transCity: json['trans_city']?.toString(),
      transState: json['trans_state']?.toString(),
      transPincode: json['trans_pincode']?.toString(),
      transPaymentStatus: json['trans_payment_status']?.toString() ?? "",
      transRefId: json['trans_ref_id']?.toString() ?? "",
      transDiscountAmount: json['trans_discount_amount']?.toString() ?? "",
      transCouponId: json['trans_coupon_id']?.toString() ?? "",
      transDeliveryDate: json['trans_delivery_date']?.toString(),
      transDeliveryAddress: json['trans_delivery_address']?.toString(),
      transDeliveryAmount: json['trans_delivery_amount']?.toString() ?? "",
      transRating: json['trans_rating']?.toString() ?? "",
      transComment: json['trans_comment']?.toString(),
      transReviewDatetime: json['trans_review_datetime']?.toString(),
      transRedeemAmount: json['trans_redeem_amount']?.toString() ?? "",
      transCashbackAmount: json['trans_cashback_amount']?.toString() ?? "",
      invoicePdfFile: json['invoice_pdf_file']?.toString(),
      transUserName: json['trans_user_name']?.toString() ?? "",
      transUserMobile: json['trans_user_mobile']?.toString() ?? "",
      transCouponCode: json['trans_coupon_code']?.toString(),
      transCouponDisAmt: json['trans_coupon_dis_amt']?.toString(),
      transTipAmount: json['trans_tip_amount']?.toString(),
      transCartTotal: json['trans_cart_total']?.toString(),
      transCancelReason: json['trans_cancel_reason']?.toString(),
      deliveryType: json['delivery_type']?.toString(),
      transRatingOrder: json['trans_rating_order']?.toString(),
      transCommentOrder: json['trans_comment_order']?.toString(),
      transCancellationCharge: json['trans_cancallation_charge']?.toString(),
      transCancelPaidstatus: json['trans_cancel_paidstatus']?.toString(),
      transNoreview: json['trans_noreview']?.toString(),
      transCancellationPaid: json['trans_cancellation_paid']?.toString(),
      transAddressId: json['trans_address_id']?.toString(),
      transCurrency: json['trans_currency']?.toString() ?? "",
      transCancellationDate: json['trans_cancellation_date']?.toString(),
      transReturnReason: json['trans_return_reason']?.toString(),
      transReturnDate: json['trans_return_date']?.toString(),
      transExchangeDate: json['trans_exchange_date']?.toString(),
      transExchangeStatus: json['trans_exchange_status']?.toString(),
      transNotRead: json['trans_not_read']?.toString() ?? "",
      transGstAmt: json['trans_gst_amt']?.toString() ?? "",
      transType: json['trans_type']?.toString() ?? "",
      createdAt: json['created_at']?.toString() ?? "",
      updatedAt: json['updated_at']?.toString() ?? "",
      belongsToCsTest: json.containsKey("belongs_to_cs_package") ? (json['belongs_to_cs_package'] != null
          ? AllTestCourseListModel.fromJson(json['belongs_to_cs_package'])
          : null) : null,
      belongsToCsCourses: json.containsKey("belongs_to_cs_courses") ? (json['belongs_to_cs_courses'] != null
          ? NewCourseListModel.fromJson(json['belongs_to_cs_courses'])
          : null) : null,
    );
  }
}



/*class CourseHistroyCTModel {
  final int? transId;
  final int? transCourseId;
  final int? transCourseType;
  final String transCourseName;
  final int? transEbookInvoice;
  final int? transPhyInvoice;
  final String? transTrackingId;
  final String? transTrackingUrl;
  final String? transDatetime;
  final String? transOrderNumber;
  final String? transUserEmail;
  final int transUserId;
  final String? transAmt;
  final int? transShippingAmount;
  final int? transStatus;
  final String? transMethod;
  final String? transBillingAddress;
  final String? transCity;
  final String? transState;
  final String? transPincode;
  final int? transPaymentStatus;
  final String? transRefId;
  final String? transDiscountAmount;
  final String? transCouponId;
  final String? transDeliveryDate;
  final String? transDeliveryAddress;
  final String transDeliveryAmount;
  final String transRating;
  final String? transComment;
  final String? transReviewDatetime;
  final String transRedeemAmount;
  final String transCashbackAmount;
  final String? invoicePdfFile;
  final String transUserName;
  final String transUserMobile;
  final String? transCouponCode;
  final String? transCouponDisAmt;
  final String? transTipAmount;
  final String? transCartTotal;
  final String? transCancelReason;
  final String? deliveryType;
  final String? transRatingOrder;
  final String? transCommentOrder;
  final String? transCancellationCharge;
  final String? transCancelPaidstatus;
  final String? transNoreview;
  final String? transCancellationPaid;
  final String? transAddressId;
  final String transCurrency;
  final String? transCancellationDate;
  final String? transReturnReason;
  final String? transReturnDate;
  final String? transExchangeDate;
  final String? transExchangeStatus;
  final int? transNotRead;
  final String? transGstAmt;
  final int? transType;
  final String? createdAt;
  final String? updatedAt;
  AllTestCourseListModel? belongsToCsCourses;

  CourseHistroyCTModel({
    required this.transId,
    required this.transCourseId,
    required this.transCourseType,
    required this.transCourseName,
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
    this.transBillingAddress,
    this.transCity,
    this.transState,
    this.transPincode,
    required this.transPaymentStatus,
    required this.transRefId,
    required this.transDiscountAmount,
    required this.transCouponId,
    this.transDeliveryDate,
    this.transDeliveryAddress,
    required this.transDeliveryAmount,
    required this.transRating,
    this.transComment,
    this.transReviewDatetime,
    required this.transRedeemAmount,
    required this.transCashbackAmount,
    this.invoicePdfFile,
    required this.transUserName,
    required this.transUserMobile,
    this.transCouponCode,
    this.transCouponDisAmt,
    this.transTipAmount,
    this.transCartTotal,
    this.transCancelReason,
    this.deliveryType,
    this.transRatingOrder,
    this.transCommentOrder,
    this.transCancellationCharge,
    this.transCancelPaidstatus,
    this.transNoreview,
    this.transCancellationPaid,
    this.transAddressId,
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
    // this.belongsToCsCourses,
  });

  factory CourseHistroyCTModel.fromJson(Map<String, dynamic> json) {
    return CourseHistroyCTModel(
      transId: json['trans_id'] ?? 0,
      transCourseId: json['trans_course_id'] ?? 0,
      transCourseType: json['trans_course_type'] ?? 0,
      transCourseName: json['trans_course_name'] ?? "",
      transEbookInvoice: json['trans_ebook_invoice'] ?? 0,
      transPhyInvoice: json['trans_phy_invoice'] ?? 0,
      transTrackingId: json['trans_tracking_id'] ?? "",
      transTrackingUrl: json['trans_tracking_url'] ?? "",
      transDatetime: json['trans_datetime'] ?? "",
      transOrderNumber: json['trans_order_number'] ?? "",
      transUserEmail: json['trans_user_email'] ?? "",
      transUserId: json['trans_user_id'] ?? 0,
      transAmt: json['trans_amt'] ?? "",
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
      transCancelReason: json['trans_cancel_reason'] ?? "",
      deliveryType: json['delivery_type'] ?? "",
      transRatingOrder: json['trans_rating_order'] ?? "",
      transCommentOrder: json['trans_comment_order'] ?? "",
      transCancellationCharge: json['trans_cancallation_charge'] ?? "",
      transCancelPaidstatus: json['trans_cancel_paidstatus'] ?? "",
      transNoreview: json['trans_noreview'] ?? "",
      transCancellationPaid: json['trans_cancellation_paid'] ?? "",
      transAddressId: json['trans_address_id'] ?? "",
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
    );
  }

}*/
