
import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sanjivprkashan/model/books/ProductModel.dart';
import 'package:sanjivprkashan/model/studentDesk/StudentDeskModel.dart';
import 'package:sanjivprkashan/utils/styleUtil.dart';

import '../../Constant.dart';
import '../../session/SessionManager.dart';


class StudentDeskController extends GetxController{
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Rxn<StudentDeskModel> stDeskData = Rxn<StudentDeskModel>();
  Future<void> getStudentDeskData() async {
    isLoading.value = true;
    try {
      var response = await http.get(Uri.parse(Constant.studentInformationDeskData),
        // body: {"str": searchStr.toString()},
        headers: Constant().userHeader,
      );
      if (response.statusCode == 200) {
        Map mData = json.decode(response.body);

        debugPrint("dataaa ${mData}  ${Constant().userHeader}");
        if (mData['status'] == "success") {
          Map<String, dynamic> data = mData["data"];
          stDeskData.value = StudentDeskModel.fromJson(data);

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