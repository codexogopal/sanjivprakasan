
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ui/home/Dashboard.dart';
import '../ui/login/LoginPage.dart';



class SessionManager {
  static SharedPreferences? prefs;
  static Future init() async => prefs = await SharedPreferences.getInstance();
  String user_token = "";
  bool IsLoggedIn = true;
  bool isAppDarkThem = false;

  Future<void> saveUserData(Map userData) async {
    Map studentData = userData;

    user_token = studentData['user_token'].toString() ?? '';

    if (kDebugMode) {
      print("abc ${user_token.toString()}");
    }
    prefs?.setString('user_token', user_token);
    prefs?.setBool('IsLoggedIn', IsLoggedIn);

    if (kDebugMode) {
      print("def ${user_token.toString()}");
    }
    Get.offAll(() => Dashboard(), transition: Transition.rightToLeft, duration: Duration(milliseconds: 600));
  }



  static String? getTokenId() => prefs!.getString("user_token") ?? '';
  static bool? isLogin() => prefs?.getBool("IsLoggedIn") ?? false;

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAll(()=> LoginPage());
  }

  Future<void> changeAppTheme(bool isDarkThem) async {
    prefs?.setBool('isAppDarkThem', isDarkThem);
  }
  static bool? isAppDarkTheme() => prefs?.getBool("isAppDarkThem");
}