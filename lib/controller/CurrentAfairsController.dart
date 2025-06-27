
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sanjivprkashan/model/current/CurrentAffairsModel.dart';
import 'package:sanjivprkashan/ui/login/ChangePassword.dart';
import 'package:sanjivprkashan/ui/login/LoginPage.dart';
import 'package:sanjivprkashan/ui/login/VerifyOtp.dart';

import '../../Constant.dart';
import '../../session/SessionManager.dart';
import '../../utils/styleUtil.dart';

class CurrentAfairsController extends GetxController{
  var isLoading = false.obs;
  var isShowPassword = false.obs;

  @override
  void onInit() {
    super.onInit();
    getCurrentAffairsList("1");
  }

  var noMoreData = false.obs;
  RxList<CurrentAffairsModel> allProductList = RxList<CurrentAffairsModel>();
  var pdfWebBashUrl = "".obs;
  Future<void> getCurrentAffairsList(String cPageNo) async {
    if(cPageNo == "1"){
      isLoading.value = true;
      noMoreData.value = false;
    }

    try {
      var response = await http.get(Uri.parse("${Constant.currentAffairs}?page=$cPageNo"),
        // body: userData,
        headers: Constant().userHeader,
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);

        debugPrint("dataaa $data   ${Constant().userHeader}");
        if (data['status'] == "success") {
          pdfWebBashUrl.value = data["route"];
          Map products = data["currentaffairdata"];
          noMoreData.value = products["current_page"] == products["last_page"] ? true : false;

          if (cPageNo == "1") {
            allProductList.clear();
          }

          allProductList.addAll((products["data"] as List)
              .map((e) => CurrentAffairsModel.fromJson(e))
              .toList());
          debugPrint("allProductListData   ${allProductList.length}  ${products["current_page"]}");
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