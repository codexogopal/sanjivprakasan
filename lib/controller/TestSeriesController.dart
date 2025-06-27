
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sanjivprkashan/model/books/ChildCategoryModel.dart';
import 'package:sanjivprkashan/model/books/ProductModel.dart';
import 'package:sanjivprkashan/model/testSeries/AllTestCourseListModel.dart';
import 'package:sanjivprkashan/model/myCourse/UserCourseListModel.dart';
import 'package:sanjivprkashan/model/testSeries/MyTestSeriesListModel.dart';
import 'package:sanjivprkashan/model/testSeries/TSMainCatModel.dart';
import 'package:sanjivprkashan/utils/styleUtil.dart';

import '../../Constant.dart';
import '../../session/SessionManager.dart';
import '../model/books/MainCategoryModel.dart';
import '../ui/cart/ThankyouScreen.dart';
import 'HomeController.dart';


class TestSeriesController extends GetxController{
  var isLoading = false.obs;
  var isProductAdding = false.obs;


  var isTestCourse = false.obs;
  RxList<RxBool> isTimeUpList = <RxBool>[].obs;
  RxList<RxBool> isResultTimeUpList = <RxBool>[].obs;

  @override
  void onInit() {
    super.onInit();
    isTestCourse = false.obs;
    getMyCourseList();
  }

  RxList<int> expandedSubjectIds = <int>[].obs;
  var catImageUrl = "".obs;
  RxList<TSMainCatModel> allTsCatList = RxList<TSMainCatModel>();
  Future<void> getAllTsCatList() async {
    isLoading.value = true;
    allTsCatList.clear();

    try {
      var response = await http.get(Uri.parse(Constant.testSeriesCourseCategories),
        // body: userData,
        headers: Constant().userHeader,
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);

        debugPrint("dataaa123 ${data["image_url"]} $data   ${Constant().userHeader}");
        if (data['status'] == "success") {
          imageUrl.value = data["image_url"];
          /*allTsCatList.addAll((data["allCourses"] as List)
              .map((e) => AllTestCourseListModel.fromJson(e))
              .toList());*/
          List mList = data["courseCategoryData"];
          allTsCatList.addAll(mList.map((json) => TSMainCatModel.fromJson(json)).toList());
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


  var imageUrl = "".obs;
  RxList<AllTestCourseListModel> allCourseList = RxList<AllTestCourseListModel>();
  RxList<AllTestCourseListModel> allSubCatCourseList = RxList<AllTestCourseListModel>();
  Future<void> getAllTestSeriesCourseList(String catId, String type) async {
    isLoading.value = true;
    isTestCourse = false.obs;
    if(type == "subCat"){
      allSubCatCourseList.clear();
    }else{
      allCourseList.clear();
    }

    try {
      var response = await http.post(Uri.parse(Constant.allTestSeriesCourses),
        body: {"course_category_id": catId},
        headers: Constant().userHeader,
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);

        debugPrint("dataaa ${data["image_url"]}   ${Constant().userHeader}");
        if (data['status'] == "success") {
          imageUrl.value = data["image_url"];

          if(type == "subCat"){
            allSubCatCourseList.addAll((data["allCourses"] as List)
                .map((e) => AllTestCourseListModel.fromJson(e))
                .toList());
          }else{
            isTestCourse = true.obs;
            allCourseList.addAll((data["allCourses"] as List)
                .map((e) => AllTestCourseListModel.fromJson(e))
                .toList());
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

  RxList<UserCourseListModel> myeCourseList = RxList<UserCourseListModel>();
  Future<void> getMyCourseList() async {
    isLoading.value = true;
    myeCourseList.clear();
    try {
      var response = await http.get(Uri.parse(Constant.myTestSeriesCourses),
        // body: userData,
        headers: Constant().userHeader,
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);

        debugPrint("dataaa ${data["image_url"]}   ${Constant().userHeader}");
        if (data['status'] == "success") {
          imageUrl.value = data["image_url"];
          myeCourseList.addAll((data["allCourses"] as List)
              .map((e) => UserCourseListModel.fromJson(e))
              .toList());
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




  /*var isBuying = false.obs;
  Future<void> buyCourse(Map<String, String> userData) async {
    isBuying.value = true;
    myeCourseList.clear();

    try {
      var response = await http.post(Uri.parse(Constant.createCourseTempOrder),
        body: userData,
        headers: Constant().userHeader,
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);

        debugPrint("dataaa $data   ${Constant().userHeader}");
        if (data['status'] == "success") {
          showGreenSnackbar("Success!", data["message"]);
          Get.offAll(() => ThankyouScreen(), transition: Transition.rightToLeft, duration: Duration(milliseconds: 600));
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
  }*/



  var userTestSeries = {}.obs;
  RxList<MyTestSeriesListModel> myTestSeriesListData = RxList<MyTestSeriesListModel>();
  Future<void> getMyTestSeriesList(Map<String, String> courseData) async {
    isLoading.value = true;
    myTestSeriesListData.clear();
    try {
      var response = await http.post(Uri.parse(Constant.courseWiseTestSeriesData),
        body: courseData,
        headers: Constant().userHeader,
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);

        debugPrint("dataaaMy ${data}   ${Constant().userHeader}");
        if (data['status'] == "success") {
          myTestSeriesListData.addAll((data["data"] as List)
              .map((e) => MyTestSeriesListModel.fromJson(e))
              .toList());
          isTimeUpList.value = List.generate(myTestSeriesListData.length, (_) => false.obs);
          isResultTimeUpList.value = List.generate(myTestSeriesListData.length, (_) => false.obs);
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