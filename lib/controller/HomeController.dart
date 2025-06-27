
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sanjivprkashan/model/UserModel.dart';
import 'package:sanjivprkashan/model/books/MainCategoryModel.dart';
import 'package:sanjivprkashan/model/books/ProductModel.dart';

import '../../Constant.dart';
import '../../session/SessionManager.dart';
import '../../utils/styleUtil.dart';


class HomeController extends GetxController{
  var isLoading = false.obs;
  var isShowPassword = false.obs;
  var bottomTabIndex = 0.obs; // Use observable
  void changeTabIndex(int index) {
    bottomTabIndex.value = index;
    /*if(index == 2){
      bottomTabIndex.value = 0;
    }*/
  }

  String getFormattedDate() {
    DateTime now = DateTime.now();
    return DateFormat("MMM d, yyyy").format(now);
  }


  @override
  void onInit() {
    super.onInit();
    getUserData();
    getDashboardData();
    requestPermissions();
    _initPackageInfo();
  }



  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    _packageInfo = info;
  }

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  var cartItemCount = "".obs;

  Rx<User?> userData = Rx<User?>(null);
  Future<void> getUserData() async {
    isLoading.value = true;
    try {
      var response = await http.post(Uri.parse(Constant.getUserData),
        // body: userData,
        headers: Constant().userHeader,
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);

        debugPrint("dataaa $data   ${Constant().userHeader}");
        if (data['status'] == "success") {
          userData.value = User.fromJson(data["user_data"]);
          if(userData.value?.userStatus != 1){
            SessionManager().logout();
          }
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
      isLoading.value = false;
    }
  }

  Future<void> updateUserName(Map<String, String> mdata) async {
    isLoading.value = true;
    try {
      var response = await http.post(Uri.parse(Constant.updateProfile),
        body: mdata,
        headers: Constant().userHeader,
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);

        debugPrint("dataaa $data   ${Constant().userHeader}");
        if (data['status'] == "success") {
          userData.value = User.fromJson(data["user_data"]);
          showGreenSnackbar("Great!", "Profile updated successfully");
          if(userData.value?.userStatus != 1){
            SessionManager().logout();
          }
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
      isLoading.value = false;
    }
  }

  var sliderImagePath = "".obs;
  RxList sliderItemListData = [].obs;
  RxList<MainCategoryModel> categoryListData = <MainCategoryModel>[].obs;
  RxList<ProductModel> productListData = <ProductModel>[].obs;
  Future<void> getDashboardData() async {
    isLoading.value = true;
    try {
      var response = await http.get(Uri.parse(Constant.dashboard),
        // body: userData,
        headers: Constant().userHeader,
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);

        debugPrint("dataaa $data   ${Constant().userHeader}");
        if (data['status'] == "success") {
          sliderImagePath.value = data["sliderImagePath"];
          sliderItemListData.value = data["appTopSliderData"];
          // Set category list
          categoryListData.value = (data["resCategoryData"] as List)
              .map((e) => MainCategoryModel.fromJson(e))
              .toList();
          productListData.value = (data["featuredProducts"] as List)
              .map((e) => ProductModel.fromJson(e))
              .toList();
          cartItemCount.value = data["countCartData"] == null ? "0" : data["countCartData"].toString();
          debugPrint("categoryListData   ${categoryListData.length}");
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
      isLoading.value = false;
    }
  }


}