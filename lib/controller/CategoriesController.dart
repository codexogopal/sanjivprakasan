
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sanjivprkashan/model/books/ChildCategoryModel.dart';
import 'package:sanjivprkashan/model/books/ProductModel.dart';
import 'package:sanjivprkashan/utils/styleUtil.dart';

import '../../Constant.dart';
import '../../session/SessionManager.dart';
import '../model/books/MainCategoryModel.dart';
import 'HomeController.dart';


class CategoriesController extends GetxController{
  var isLoading = false.obs;
  var isProductAdding = false.obs;



  @override
  void onInit() {
    super.onInit();
    getAllCategory();
  }




  RxList<ChildCategoryModel> childCatList = <ChildCategoryModel>[].obs;
  Future<void> getChildCat(Map<String, String> userData) async {
    isLoading.value = true;
    try {
      var response = await http.post(Uri.parse(Constant.childCategories),
        body: userData,
        headers: Constant().userHeader,
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);

        debugPrint("dataaa $data   ${Constant().userHeader}");
        if (data['status'] == "success") {
          childCatList.value = (data["categoryData"] as List)
              .map((e) => ChildCategoryModel.fromJson(e))
              .toList();
          debugPrint("categoryListData   ${childCatList.length}");
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


  Rxn<ProductModel> productDetail = Rxn<ProductModel>();
  var product_fav = 0.obs;
  RxList<ProductModel> productListData = <ProductModel>[].obs;
  Future<void> getProductDetail(String userData, {bool isLoadAgain = false}) async {
    if(!isLoadAgain)isLoading.value = true;
    Map<String, String> pData = {"product_id": userData};
    try {
      var response = await http.post(Uri.parse(Constant.productDetail),
        body: pData,
        headers: Constant().userHeader,
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);

        debugPrint("dataaa $data   ${Constant().userHeader}");
        if (data['status'] == "success") {
          productDetail.value = ProductModel.fromJson(data["product_details"]);
          product_fav.value = data["product_fav"];
          productListData.value = (data["relatedProducts"] as List)
              .map((e) => ProductModel.fromJson(e))
              .toList();
          debugPrint("categoryListData   ${product_fav.value}");
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


  RxList<MainCategoryModel> categoryListData = <MainCategoryModel>[].obs;
  Future<void> getAllCategory() async {
    isProductAdding.value = true;
    try {
      var response = await http.get(Uri.parse(Constant.allCategories),
        // body: userData,
        headers: Constant().userHeader,
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        debugPrint("dataaa   $data   ${Constant().userHeader}");
        if (data['status'] == "success") {
          categoryListData.value = (data["categoryData"] as List)
              .map((e) => MainCategoryModel.fromJson(e))
              .toList();
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

  var noMoreData = false.obs;
  RxList<ProductModel> allProductList = RxList<ProductModel>();

  Future<void> getAllProductList(String cPageNo) async {
    if(cPageNo == "1"){
      isLoading.value = true;
      noMoreData.value = false;
    }

    try {
      var response = await http.get(Uri.parse("${Constant.productList}?page=$cPageNo"),
        // body: userData,
        headers: Constant().userHeader,
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);

        debugPrint("dataaa $data   ${Constant().userHeader}");
        if (data['status'] == "success") {
          Map products = data["products"];
          noMoreData.value = products["current_page"] == products["last_page"] ? true : false;

          if (cPageNo == "1") {
            allProductList.clear();
          }

          allProductList.addAll((products["data"] as List)
              .map((e) => ProductModel.fromJson(e))
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

  Future<void> getMyWishlistList() async {
      isLoading.value = true;
      allProductList.clear();

    try {
      var response = await http.get(Uri.parse(Constant.wishList),
        // body: userData,
        headers: Constant().userHeader,
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);

        debugPrint("dataaa $data   ${Constant().userHeader}");
        if (data['status'] == "success") {

          allProductList.addAll((data["data"] as List)
              .map((e) => ProductModel.fromJson(e))
              .toList());
          debugPrint("allProductListData   ${allProductList.length} ");
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

  RxList<ProductModel> myeBooksList = RxList<ProductModel>();
  var ebookBaseUrl = "".obs;
  Future<void> getMyEBookList() async {
      isLoading.value = true;
      myeBooksList.clear();

    try {
      var response = await http.get(Uri.parse(Constant.userEbooks),
        // body: userData,
        headers: Constant().userHeader,
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);

        debugPrint("dataaa $data   ${Constant().userHeader}");
        if (data['status'] == "success") {
          ebookBaseUrl.value = data["route"];
          myeBooksList.addAll((data["data"] as List)
              .map((e) => ProductModel.fromJson(e))
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

  var addFav = false.obs;
  Future<void> addRemoveWishlist(String pId) async {
    addFav.value = true;
      noMoreData.value = false;
      Map<String, String> userData = {
        "product_id" : pId,
      };
    try {
      var response = await http.post(Uri.parse(Constant.addRemoveWishlist),
        body: userData,
        headers: Constant().userHeader,
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);

        debugPrint("dataaaFav $data   ${Constant().userHeader}");
        if (data['status'] == "success") {
          getProductDetail(pId, isLoadAgain: true);
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
      addFav.value = false;
    }
  }


}