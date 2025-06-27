
import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sanjivprkashan/model/books/ChildCategoryModel.dart';
import 'package:sanjivprkashan/model/books/ProductModel.dart';
import 'package:sanjivprkashan/model/cart/CartItemModel.dart';
import 'package:sanjivprkashan/utils/styleUtil.dart';

import '../../Constant.dart';
import '../../session/SessionManager.dart';
import '../model/address/UserAddress.dart';
import 'HomeController.dart';


class AddressController extends GetxController{
  var isLoading = false.obs;
  var isProductAdding = false.obs;
  var selectedAddress = "".obs;


  @override
  void onInit() {
    super.onInit();
    getAddressList();
  }

  Map<String, dynamic> nullData = {
    "ua_id": 0,
    "ua_fname": "",
    "ua_lname": "",
    "ua_email": "",
    "ua_mobile": "",
    "ua_app_state_name": "",
    "ua_address_type": "",
    "ua_address_type_other": "",
    "ua_company_name": "",
    "ua_gst_number": "",
    "ua_ship_state": "",
    "ua_ship_city": "",
    "ua_app_ship_city": "",
    "ua_ship_house": "",
    "ua_ship_address": "",
    "ua_ship_pincode": "",
    "ua_user_id": 0,
    "ua_default_address": 0,
    "ua_country_id": 0,
    "ua_country_name": "",
    "ua_pin_id": 0,
    "created_at": "2025-04-14T05:08:01.000000Z",
    "updated_at": "2025-04-14T05:08:01.000000Z"
  };

  Rxn<UserAddress> defaultAddressItem = Rxn<UserAddress>();
  var myAddressList = <UserAddress>[].obs;
  Future<void> getAddressList() async {

    isLoading.value = true;
    try {
      var response = await http.get(Uri.parse(Constant.userAddressList),
        // body: userData,
        headers: Constant().userHeader,
      );
      if (response.statusCode == 200) {
        Map mData = json.decode(response.body);

        debugPrint("dataaaAdd ${mData}  ${Constant().userHeader}");
        if (mData['status'] == "success") {
          defaultAddressItem.value = UserAddress.fromJson(mData["row_default_address"] ?? nullData);
          myAddressList.value = (mData["user_address_list"] as List)
              .map((e) => UserAddress.fromJson(e))
              .toList();


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

  Future<void> addAddress(Map<String, String> userData) async {
    isLoading.value = true;
    try {
      var response = await http.post(Uri.parse(Constant.addUserAddress),
        body: userData,
        headers: Constant().userHeader,
      );
      if (response.statusCode == 200) {
        Map mData = json.decode(response.body);

        debugPrint("dataaa ${mData}  ${Constant().userHeader}");
        if (mData['status'] == "success") {

          defaultAddressItem.value = UserAddress.fromJson(mData["row_default_address"] ?? nullData);
          myAddressList.value = (mData["user_address_list"] as List)
              .map((e) => UserAddress.fromJson(e))
              .toList();
            Timer(Duration(milliseconds: 500), (){
              Get.back();
              showGreenSnackbar("Great!", mData["message"]);
            });
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


  Future<void> deleteAddress(Map<String, String> userData) async {
    isLoading.value = true;
    try {
      var response = await http.post(Uri.parse(Constant.removeAddress),
        body: userData,
        headers: Constant().userHeader,
      );
      if (response.statusCode == 200) {
        Map mData = json.decode(response.body);

        debugPrint("dataaa ${mData}  ${Constant().userHeader}");
        if (mData['status'] == "success") {
          defaultAddressItem.value = UserAddress.fromJson(mData["row_default_address"] ?? nullData);
          myAddressList.value = (mData["user_address_list"] as List)
              .map((e) => UserAddress.fromJson(e))
              .toList();
          showGreenSnackbar("Great!", "Address Deleted successfully");
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