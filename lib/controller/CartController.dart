
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:paytmpayments_allinonesdk/paytmpayments_allinonesdk.dart';
import 'package:sanjivprkashan/controller/AddressController.dart';

import 'package:sanjivprkashan/model/cart/CartItemModel.dart';
import 'package:sanjivprkashan/model/coupon/PromoModel.dart';
import 'package:sanjivprkashan/model/orderHistory/OrderHistoryModel.dart';
import 'package:sanjivprkashan/model/orderHistory/OrderItemsListModel.dart';
import 'package:sanjivprkashan/ui/cart/FailedScreen.dart';
import 'package:sanjivprkashan/ui/cart/ThankyouScreen.dart';
import 'package:sanjivprkashan/utils/styleUtil.dart';

import '../../Constant.dart';
import '../../session/SessionManager.dart';
import '../model/orderhistoryCourse/CourseHistroyCTModel.dart';
import 'HomeController.dart';


class CartController extends GetxController{
  var isLoading = false.obs;
  var isProductAdding = false.obs;
  var isProductRemoving = false.obs;




  @override
  void onInit() {
    super.onInit();
  }



  var cartSummary = {}.obs;
  var cartItemList = <CartItemModel>[].obs;
  Future<void> getCartList({bool isLoadAgain = false}) async {
    final HomeController homeController = Get.put(HomeController());
    if(!isLoadAgain)isLoading.value = true;
    try {
      var response = await http.get(Uri.parse(Constant.cartList),
        // body: userData,
        headers: Constant().userHeader,
      );
      if (response.statusCode == 200) {
        Map mData = json.decode(response.body);

        debugPrint("dataaa ${mData["data"]}  ${Constant().userHeader}");
        if (mData['status'] == "success") {
          // productDetail.value = CartItemModel.fromJson(data["product_details"]);
          cartSummary.value = mData["cart_summary"];
          cartItemList.value = (mData["data"] as List)
              .map((e) => CartItemModel.fromJson(e))
              .toList();

          homeController.cartItemCount.value = cartItemList.length.toString();
          // debugPrint("dataaa ${cartItemList.length}");
        }else{
          if(mData["message"] == "Session Expired"){
            SessionManager().logout();
          }
          showSnackbar("Opps!", mData["message"]);
        }
      } else {
        showSnackbar("Error", "Failed to fetch getting response Code : ${response.statusCode}");
      }
    } catch (e) {
      showSnackbar("Error", e.toString());
      debugPrint("error ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addItemToCart(Map<String, String> userData) async {
    final HomeController homeController = Get.put(HomeController());
    isProductAdding.value = true;
    try {
      var response = await http.post(Uri.parse(Constant.addToCart),
        body: userData,
        headers: Constant().userHeader,
      );
      if (response.statusCode == 200) {
        Map mData = json.decode(response.body);
        Map data = mData["data"];
        debugPrint("dataaa  $userData  $mData   ${Constant().userHeader}");
        if (data['status'] == "success") {
          showGreenSnackbar("Success!", data["message"]);
          homeController.cartItemCount.value = data["cartcount"] == null ? "0" : data["cartcount"].toString();
            getCartList(isLoadAgain: true);
        }else{
          if(data["message"] == "Session Expired"){
            SessionManager().logout();
          }
          showSnackbar("Opps!", data["message"]);
        }
      } else {
        showSnackbar("Error", "Failed to fetch getting response Code : ${response.statusCode}");
      }
    } catch (e) {
      showSnackbar("Error", e.toString());
      debugPrint("error ${e.toString()}");
    } finally {
      isProductAdding.value = false;
    }
  }

  Future<void> removeCartItem(Map<String, String> userData) async {
    isProductRemoving.value = true;
    try {
      var response = await http.post(Uri.parse(Constant.minusToCart),
        body: userData,
        headers: Constant().userHeader,
      );
      if (response.statusCode == 200) {
        Map mData = json.decode(response.body);
        Map data = mData["data"];
        debugPrint("dataaa  $userData  $mData   ${Constant().userHeader}");
        if (data['status'] == "success") {
          showGreenSnackbar("Success!", data["message"]);
          getCartList(isLoadAgain: true);
        }else{
          if(data["message"] == "Session Expired"){
            SessionManager().logout();
          }
          showSnackbar("Opps!", data["message"]);
        }
      } else {
        showSnackbar("Error", "Failed to fetch getting response Code : ${response.statusCode}");
      }
    } catch (e) {
      showSnackbar("Error", e.toString());
      debugPrint("error ${e.toString()}");
    } finally {
      isProductRemoving.value = false;
    }
  }


  var promoList = <PromoModel>[].obs;
  Future<void> getPromoList(String pType) async {
    isLoading.value = true;
    try {
      var response = await http.post(Uri.parse(Constant.couponList),
        body: ({"promo_applicable_for": pType}),
        headers: Constant().userHeader,
      );
      if (response.statusCode == 200) {
        Map mData = json.decode(response.body);

        // appliedPromo.value = null;
        debugPrint("dataaa ${mData["data"]}  ${Constant().userHeader}");
        if (mData['status'] == "success") {
          promoList.value = (mData["data"] as List)
              .map((e) => PromoModel.fromJson(e))
              .toList();
        }else{
          if(mData["message"] == "Session Expired"){
            SessionManager().logout();
          }
          showSnackbar("Opps!", mData["message"]);
        }
      } else {
        showSnackbar("Error", "Failed to fetch getting response Code : ${response.statusCode}");
      }
    } catch (e) {
      showSnackbar("Error", e.toString());
      debugPrint("error ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }



  var appliedPromo = {}.obs;
  Future<void> applyPromoCode(Map<String, String> userData) async {
    isLoading.value = true;
    try {
      var response = await http.post(Uri.parse(Constant.applyCoupon),
        body: userData,
        headers: Constant().userHeader,
      );
      if (response.statusCode == 200) {
        Map mData = json.decode(response.body);
        debugPrint("dataaa ${mData["data"]}  ${Constant().userHeader}");
        if (mData['data']['status'] == "success") {
          appliedPromo.value = mData["data"];
          Get.back();
          showGreenSnackbar("Successfully!", mData['data']["message"]);
        }else{
          if(mData['data']["message"] == "Session Expired"){
            SessionManager().logout();
          }
          showSnackbar("Opps!", mData['data']["message"]);
        }
      } else {
        debugPrint("dataaa 222");
        showSnackbar("Error", "Failed to fetch getting response Code : ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("dataaa 333");
      showSnackbar("Error", e.toString());
      debugPrint("error ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  var rowTempTrans = {}.obs;
  var tempTxnId = "".obs;
  var mTxnToken = "".obs;
  Future<void> updateTampOrder(Map<String, String> userData) async {
    try {
      var response = await http.post(Uri.parse(Constant.reponsePaytm),
        body: userData,
        headers: Constant().userHeader,
      );
      if (response.statusCode == 200) {
        Map mData = json.decode(response.body);
        debugPrint("dataaaPay ${mData}  ${Constant().userHeader}");
        if (mData['status'] == "success") {
          Get.offAll(() => ThankyouScreen(), transition: Transition.rightToLeft, duration: Duration(milliseconds: 600));
          // showGreenSnackbar("Successfully!", mData["message"]);

        }else{
          if(mData['data']["message"] == "Session Expired"){
            SessionManager().logout();
          }
          showSnackbar("Opps!", mData['data']["message"]);
        }
      } else {
        debugPrint("dataaa 222");
        showSnackbar("Error", "Failed to fetch getting response Code : ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("dataaa 333");
      showSnackbar("Error", e.toString());
      debugPrint("error ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> createTampOrder(Map<String, String> userData) async {
    isLoading.value = true;
    tempTxnId.value = "";
    mTxnToken.value = "";
    final CartController caCtrl = Get.put(CartController());
    final AddressController addressCtrl = Get.put(AddressController());
    try {
      var response = await http.post(Uri.parse(Constant.createTempOrder),
        body: userData,
        headers: Constant().userHeader,
      );
      if (response.statusCode == 200) {
        Map mData = json.decode(response.body);
        debugPrint("dataaa ${mData}  ${userData}");
        if (mData['status'] == "success") {
          rowTempTrans.value = mData["row_temp_trans"];
          tempTxnId.value = rowTempTrans["temp_trans_order_id"];
          mTxnToken.value = rowTempTrans["temp_razorpay_order_id"];
          // showGreenSnackbar("Successfully!", mData["message"]);
          startTransaction();
        }else{
          if(mData['data']["message"] == "Session Expired"){
            SessionManager().logout();
          }
          showSnackbar("Opps!", mData['data']["message"]);
        }
      } else {
        debugPrint("dataaa 222");
        showSnackbar("Error", "Failed to fetch getting response Code : ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("dataaa 333");
      showSnackbar("Error", e.toString());
      debugPrint("error ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> startTransaction() async {
    // Validate required fields first
    final validationError = _validateTransactionFields();
    if (validationError != null) {
      showSnackbar('Validation Error', validationError);
      return;
    }

    try {
      final response = await PaytmPaymentsAllinonesdk().startTransaction(
        Constant().paytmMid,
        tempTxnId.value.toString(),
        // rowTempTrans["temp_trans_amt"].toString(),
        "1",
        mTxnToken.value,
        'https://sanjivprakashan.com/', // callbackUrl
        false, // isStaging
        false, // restrictAppInvoke
        true, // enableAssist
      );

      _handleTransactionResponse(response);
    } on PlatformException catch (e) {
      _handlePlatformException(e);
    } catch (e) {
      _handleGenericError(e);
    }
  }

  String? _validateTransactionFields() {
    if (Constant().paytmMid.isEmpty) return 'MID Field is Empty';
    if (tempTxnId.value.toString().isEmpty) return 'OrderID Field is Empty';
    return null;
  }

  void _handleTransactionResponse(dynamic response) {
    final CartController caCtrl = Get.put(CartController());
    final AddressController addressCtrl = Get.put(AddressController());
    final result = response;
    debugPrint('payResponse1: $result');
    if(result["STATUS"] == "TXN_SUCCESS"){
      debugPrint('payResponse10: $result');
      Map<String, String> userData = {
        "STATUS" : result["STATUS"] ?? "",
        "promo_id" : caCtrl.appliedPromo["promo_id"] ?? "",
        "ORDERID" : rowTempTrans["temp_trans_order_id"] ?? "",
        "ua_id" : addressCtrl.selectedAddress.value ?? "",
        "TXNAMOUNT" : rowTempTrans["temp_trans_amt"] ?? "",
        "TXNID" : mTxnToken.value ?? "",
        "PAYMENTMODE" : result["PAYMENTMODE"]
      };
      debugPrint("finalRes $userData");
      updateTampOrder(userData);
    }else{
      Get.offAll(() => FailedScreen(), transition: Transition.rightToLeft, duration: Duration(milliseconds: 600));
    }
  }

  void _handlePlatformException(PlatformException e) {
    final errorMessage = '${e.message}';
    showSnackbar('Platform Error', errorMessage);
    debugPrint('PlatformError1: $errorMessage');
    Get.offAll(() => FailedScreen(errorMsg: errorMessage,), transition: Transition.rightToLeft, duration: Duration(milliseconds: 600));
  }

  void _handleGenericError(dynamic error) {
    final errorMessage = error.toString();
    // showSnackbar('Unexpected Error', errorMessage);
    // debugPrint('GenericError1: $errorMessage');
    Get.offAll(() => FailedScreen(errorMsg: errorMessage,), transition: Transition.rightToLeft, duration: Duration(milliseconds: 600));
  }


  var isBuying = false.obs;
  Future<void> createTampCourseOrder(Map<String, String> userData, String type) async {
    isBuying.value = true;
    isLoading.value = true;
    tempTxnId.value = "";
    mTxnToken.value = "";

    try {
      var response = await http.post(Uri.parse(Constant.createCourseTempOrder),
        body: userData,
        headers: Constant().userHeader,
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);

        debugPrint("dataaa123 $data   ${Constant().userHeader}");
        if (data['status'] == "success") {
          rowTempTrans.value = data["row_temp_trans"];
          tempTxnId.value = rowTempTrans["temp_trans_order_id"];
          mTxnToken.value = rowTempTrans["temp_razorpay_order_id"];
          Map<String, String> userData = {
            "STATUS" : "TXN_SUCCESS",
            "promo_id" : appliedPromo["promo_id"].toString() ?? "",
            "ORDERID" : rowTempTrans["temp_trans_order_id"] ?? "",
            "TXNAMOUNT" : rowTempTrans["temp_trans_amt"] ?? "",
            "TXNID" : mTxnToken.value ?? "",
            "PAYMENTMODE" : "UPI"
          };
          updateTampCourseOrder(userData);
        }else{
          if(data["message"] == "Session Expired"){
            SessionManager().logout();
          }
          showSnackbar("Opps!", data["message"]);
        }
      } else {
        showSnackbar("Error", "Failed to fetch getting response Code : ${response.statusCode}");
      }
    } catch (e) {
      showSnackbar("Error", e.toString());
      debugPrint("error ${e.toString()}");
    } finally {
      isBuying.value = false;
    }
  }


  Future<void> updateTampCourseOrder(Map<String, String> userData) async {
    isBuying.value = true;
    try {
      var response = await http.post(Uri.parse(Constant.courseReponsePaytm),
        body: userData,
        headers: Constant().userHeader,
      );
      if (response.statusCode == 200) {
        Map mData = json.decode(response.body);
        debugPrint("dataaaPay ${mData}  ${Constant().userHeader}");
        if (mData['status'] == "success") {
          Get.offAll(() => ThankyouScreen(), transition: Transition.rightToLeft, duration: Duration(milliseconds: 600));
          // showGreenSnackbar("Successfully!", mData["message"]);

        }else{
          if(mData['data']["message"] == "Session Expired"){
            SessionManager().logout();
          }
          showSnackbar("Opps!", mData['data']["message"]);
        }
      } else {
        debugPrint("dataaa 222");
        showSnackbar("Error", "Failed to fetch getting response Code : ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("dataaa 333");
      showSnackbar("Error", e.toString());
      debugPrint("error ${e.toString()}");
    } finally {
      isBuying.value = false;
    }
  }


  var orderList = <OrderHistoryModel>[].obs;
  Future<void> getOrderHistoryList() async {
    isLoading.value = true;
    try {
      var response = await http.get(Uri.parse(Constant.myOrdersList),
        // body: userData,
        headers: Constant().userHeader,
      );
      if (response.statusCode == 200) {
        Map mData = json.decode(response.body);

        // appliedPromo.value = null;
        debugPrint("dataaa ${mData["data"]}  ${Constant().userHeader}");
        if (mData['status'] == "success") {
          orderList.value = (mData["order_list"] as List)
              .map((e) => OrderHistoryModel.fromJson(e))
              .toList();
        }else{
          if(mData["message"] == "Session Expired"){
            SessionManager().logout();
          }
          showSnackbar("Opps!", mData["message"]);
        }
      } else {
        showSnackbar("Error", "Failed to fetch getting response Code : ${response.statusCode}");
      }
    } catch (e) {
      showSnackbar("Error", e.toString());
      debugPrint("error ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  var cImageUrl = "".obs;
  var courseOrderList = <CourseHistroyCTModel>[].obs;
  Future<void> getCourseOrderHistoryList(String cType) async {
    isLoading.value = true;
    try {
      var response = await http.post(Uri.parse(Constant.userCoursesTransactions),
        body: ({"trans_course_type":cType == "t" ? "0" : "1"}),
        headers: Constant().userHeader,
      );
      if (response.statusCode == 200) {
        Map mData = json.decode(response.body);

        // appliedPromo.value = null;
        debugPrint("dataaa123 ${mData["data"]}  ${Constant().userHeader}");
        if (mData['status'] == "success") {
          cImageUrl.value = mData["image_url"];
          courseOrderList.value = (mData["order_list"] as List)
              .map((e) => CourseHistroyCTModel.fromJson(e))
              .toList();
        }else{
          if(mData["message"] == "Session Expired"){
            SessionManager().logout();
          }
          showSnackbar("Opps!", mData["message"]);
        }
      } else {
        showSnackbar("Error", "Failed to fetch getting response Code : ${response.statusCode}");
      }
    } catch (e) {
      showSnackbar("Error", e.toString());
      debugPrint("error ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }


  Rx<OrderHistoryModel?> orderData = Rx<OrderHistoryModel?>(null);

  var orderItemCartSummary = {}.obs;
  var orderedItemList = <OrderItemsListModel>[].obs;
  Future<void> getOrderOrderDetails(Map<String, String> userdata) async {
    isLoading.value = true;
    try {
      var response = await http.post(Uri.parse(Constant.orderDetails),
        body: userdata,
        headers: Constant().userHeader,
      );
      if (response.statusCode == 200) {
        Map mData = json.decode(response.body);

        // appliedPromo.value = null;
        debugPrint("dataaa ${mData["data"]}  ${Constant().userHeader}");
        if (mData['status'] == "success") {
          orderData.value = OrderHistoryModel.fromJson(mData["order_detail"]);
          orderItemCartSummary.value = mData["order_summary"];
          orderedItemList.value = (mData["order_detail"]["items"] as List)
              .map((e) => OrderItemsListModel.fromJson(e))
              .toList();
        }else{
          if(mData["message"] == "Session Expired"){
            SessionManager().logout();
          }
          showSnackbar("Opps!", mData["message"]);
        }
      } else {
        showSnackbar("Error", "Failed to fetch getting response Code : ${response.statusCode}");
      }
    } catch (e) {
      showSnackbar("Error", e.toString());
      debugPrint("error ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }
}