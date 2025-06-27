
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sanjivprkashan/ui/login/ChangePassword.dart';
import 'package:sanjivprkashan/ui/login/LoginPage.dart';
import 'package:sanjivprkashan/ui/login/VerifyOtp.dart';

import '../../Constant.dart';
import '../../session/SessionManager.dart';
import '../../utils/styleUtil.dart';

class LoginController extends GetxController{
  var isLoading = false.obs;
  var isShowPassword = false.obs;

  @override
  void onInit() {
    requestPermissions();
    super.onInit();
  }


  Future<void> userLogin(Map<String, String> userData) async {
    isLoading.value = true;
    try {
      var response = await http.post(Uri.parse(Constant.loginProcess),
          body: userData
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        debugPrint("dataaa $data");
        if (data['status'] == "success") {
          Get.to(() => VerifyOtp(mToken: data["user_token"], pType: "login",));
        }else{
          showSnackbar("Opps!", data["message"]);
        }
      } else {
        showSnackbar("Opps!", "Failed to fetch news");
      }
    } catch (e) {
      showSnackbar("Error!", e.toString());
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> registerProcess(Map<String, String> userData) async {
    isLoading.value = true;
    try {
      var response = await http.post(Uri.parse(Constant.registerProcess),
          body: userData
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        debugPrint("dataaa $data");
        if (data['status'] == "success") {
          Get.to(() => VerifyOtp(mToken: data["user_token"], pType: "login",));
        }else{
          showSnackbar("Opps!", data["message"]);
        }
      } else {
        showSnackbar("Opps!", "Failed to fetch news");
      }
    } catch (e) {
      showSnackbar("Error!", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changePassword(Map<String, String> userData, String userToken, String type) async {
    isLoading.value = true;
    try {
      var response = await http.post(Uri.parse(Constant.forgotChangePassword),
          body: userData,
        headers:  {
          "X-AUTH-TOKEN" : userToken ?? ""
        },
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        debugPrint("dataaa $data");
        if (data['status'] == "success") {
          showGreenSnackbar("Success", data["message"]);
          if(type == "login"){
            Get.offAll(() => LoginPage(), transition: Transition.rightToLeft, duration: Duration(milliseconds: 600));
          }
        }else{
          if(data["message"]  == "Session Expired"){
            SessionManager().logout();
          }
          showSnackbar("Opps!", data["message"]);
        }
      } else {
        showSnackbar("Opps!", "Failed to fetch news");
      }
    } catch (e) {
      showSnackbar("Error!", e.toString());
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> forgotPassword(Map<String, String> userData) async {
    isLoading.value = true;
    try {
      var response = await http.post(Uri.parse(Constant.sendForgotOtp),
          body: userData
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        debugPrint("dataaa $data");
        if (data['status'] == "success") {
          Get.to(() => VerifyOtp(mToken: data["user_token"], pType: "forgot",));
        }else{
          showSnackbar("Opps!", data["message"]);
        }
      } else {
        showSnackbar("Opps!", "Failed to fetch news");
      }
    } catch (e) {
      showSnackbar("Error!", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyUserOtp(Map<String, String> userData, String userToken, String pType) async {
    isLoading.value = true;
    try {
      var response = await http.post(Uri.parse(Constant.verifyOtp),
          body: userData,
        headers:  {
          "X-AUTH-TOKEN" : userToken ?? ""
        },
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        debugPrint("dataaa $data");
        if (data['status'] == "success") {
          if(pType == "forgot"){
            Get.to(()=> ChangePassword(mToken: userToken,));
          }else{
            SessionManager().saveUserData(data);
            showSnackbar("Great!", data["message"]);
          }

        }else{
          showSnackbar("Opps!", data["message"]);
        }
      } else {
        showSnackbar("Opps!", "Failed to fetch news");
      }
    } catch (e) {
      showSnackbar("Error!", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp(String userToken) async {
    isLoading.value = true;
    try {
      var response = await http.get(Uri.parse(Constant.resendOtp),
        headers:  {
          "X-AUTH-TOKEN" : userToken ?? ""
        },
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        debugPrint("dataaa $data");
        if (data['status'] == "success") {
          showSnackbar("Opps!", data["message"]);
        }else{
          showSnackbar("Opps!", data["message"]);
        }
      } else {
        showSnackbar("Opps!", "Failed to fetch news");
      }
    } catch (e) {
      showSnackbar("Error!", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

}