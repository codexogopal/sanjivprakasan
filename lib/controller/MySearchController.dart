
import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sanjivprkashan/model/books/ProductModel.dart';
import 'package:sanjivprkashan/utils/styleUtil.dart';

import '../../Constant.dart';
import '../../session/SessionManager.dart';


class MySearchController extends GetxController{
  var isLoading = false.obs;

  var searchedValue = "".obs;
  @override
  void onInit() {
    super.onInit();
  }

  RxList<ProductModel> searchProductList = RxList<ProductModel>();
  Future<void> getSearchData(String searchStr) async {
    isLoading.value = true;
    try {
      var response = await http.post(Uri.parse(Constant.getProductsBySearch),
        body: {"str": searchStr.toString()},
        headers: Constant().userHeader,
      );
      if (response.statusCode == 200) {
        Map mData = json.decode(response.body);

        debugPrint("dataaa ${mData}  ${Constant().userHeader}");
        if (mData['status'] == "success") {
          searchProductList.addAll((mData["data"] as List)
              .map((e) => ProductModel.fromJson(e))
              .toList());

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