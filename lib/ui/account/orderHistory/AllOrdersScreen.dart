import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get.dart';
import 'package:sanjivprkashan/controller/HomeController.dart';
import 'package:sanjivprkashan/ui/account/address/MyAddressList.dart';
import 'package:sanjivprkashan/ui/account/myebook/MyEBookScreen.dart';
import 'package:sanjivprkashan/ui/account/mywishlist/MyWishlistScreen.dart';
import 'package:sanjivprkashan/ui/account/orderHistory/CourseOrderHistoryList.dart';
import 'package:sanjivprkashan/ui/account/orderHistory/OrderHistoryListScreen.dart';
import 'package:sanjivprkashan/ui/account/ourPolicies/OurPoliciesScreen.dart';
import 'package:sanjivprkashan/ui/web/MyWebView.dart';

import '../../../theme/mythemcolor.dart';
import '../../../utils/styleUtil.dart';

class AllOrdersScreen extends StatefulWidget {
  const AllOrdersScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AllOrdersScreen();
}

class _AllOrdersScreen extends State<AllOrdersScreen> {
  final HomeController homeCtrl = Get.put(HomeController());

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getData() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      // appBar: myStatusBar(context),
      body: SafeArea(
        child: Obx(() {
          if (homeCtrl.isLoading.value) {
            return Center(child: apiLoader());
          }
          return RefreshIndicator(
            onRefresh: () => getData(),
            child: Column(
              children: [
                otherAppBar(context, "All Orders", true, isCartShow: false),
                Flexible(
                  child: ListView(
                    children: [
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          Get.to(() => OrderHistoryListScreen());
                        },
                        child: itemView("order-history", "Books Order History"),
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          Get.to(() => CourseOrderHistoryList(cType: "t",));
                        },
                        child: itemView(
                          "order-history",
                          "Test Series Course Order History",
                        ),
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          Get.to(() => CourseOrderHistoryList(cType: "c",));
                        },
                        child: itemView(
                          "order-history",
                          "Course Order History",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget itemView(String imgName, String title) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: myprimarycolor.shade50.withAlpha(30),
                  borderRadius: BorderRadius.circular(150),
                ),
                child: Image.asset(
                  "assets/images/$imgName.png",
                  height: 18,
                  width: 18,
                  color: imgName == "book" ? null : myprimarycolor,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Icon(Icons.navigate_next, size: 25),
        ],
      ),
    );
  }

  Widget userView() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 15, 5, 15),
      // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        color: myprimarycolor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/images/avtar.png", height: 55, width: 55),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hi! ${homeCtrl.userData.value?.userFname ?? ""}",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "(+91) ${homeCtrl.userData.value?.userMobile ?? ""}",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Icon(Icons.navigate_next, size: 30, color: Colors.white),
        ],
      ),
    );
  }
}
