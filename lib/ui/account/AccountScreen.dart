import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get.dart';
import 'package:sanjivprkashan/controller/HomeController.dart';
import 'package:sanjivprkashan/ui/account/ac/MyAccountScreen.dart';
import 'package:sanjivprkashan/ui/account/address/MyAddressList.dart';
import 'package:sanjivprkashan/ui/account/myebook/MyEBookScreen.dart';
import 'package:sanjivprkashan/ui/account/mywishlist/MyWishlistScreen.dart';
import 'package:sanjivprkashan/ui/account/orderHistory/OrderHistoryListScreen.dart';
import 'package:sanjivprkashan/ui/account/ourPolicies/OurPoliciesScreen.dart';
import 'package:sanjivprkashan/ui/web/MyWebView.dart';

import '../../controller/CurrentAfairsController.dart';
import '../../session/SessionManager.dart';
import '../../theme/mythemcolor.dart';
import '../../utils/AppBars.dart';
import '../../utils/styleUtil.dart';
import 'orderHistory/AllOrdersScreen.dart';

class AccountScreen extends StatefulWidget {
  final bool showAppBar;
  const AccountScreen({super.key, required this.showAppBar});

  @override
  State<StatefulWidget> createState() => _AccountScreen();
}


class _AccountScreen extends State<AccountScreen> {
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

  Future<void> getData() async {

  }
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
                if(widget.showAppBar)
                otherAppBar(context, "Account", false),
                Flexible(
                  child: ListView(
                    children: [
                      if(widget.showAppBar)
                     const SizedBox(height: 10,),
                      InkWell(
                          onTap: (){
                            Get.to(()=> MyAccountScreen());
                          },
                          child: userView()
                      ),
                      const SizedBox(height: 10,),
                      InkWell(
                        onTap: (){
                          Get.to(()=> MyAccountScreen());
                        },
                          child: itemView("user_ac", "My Account")
                      ),
                      const SizedBox(height: 10,),
                      InkWell(
                        onTap: (){
                          Get.to(()=> AllOrdersScreen());
                        },
                          child: itemView("order-history", "Order History")
                      ),
                      const SizedBox(height: 10,),
                      InkWell(
                          onTap: (){
                            Get.to(()=> MyEBookScreen());
                          },
                          child: itemView("ebook", "E Books")
                      ),
                      const SizedBox(height: 10,),
                      InkWell(onTap: (){
                        Get.to(()=> MyAddressList(pType: "ac",));
                      },child: itemView("ic_location", "My Addresses")),
                      const SizedBox(height: 10,),
                      InkWell(
                        onTap: (){
                          Get.to(()=> MyWishlistScreen());
                          },
                          child: itemView("bookmark", "My Wishlist")
                      ),
                      const SizedBox(height: 10,),
                      InkWell(
                        onTap: (){
                          Get.to(()=> OurPoliciesScreen());
                          },
                          child: itemView("privacy-policy", "Our Policies & Useful Links")
                      ),
                      const SizedBox(height: 10,),
                      InkWell(
                        onTap: (){
                          logoutDialogNew();
                        },
                          child: itemView("logout", "Logout")
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


  Widget itemView(String imgName, String title){
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
                    borderRadius: BorderRadius.circular(150)
                  ),
                  child: Image.asset("assets/images/$imgName.png", height: 18, width: 18, color: imgName == "book" ? null : myprimarycolor,)
              ),
              const SizedBox(width: 10,),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Icon(Icons.navigate_next, size: 25,)
        ],
      ),
    );
  }


  Widget userView(){
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
              Image.asset("assets/images/avtar.png", height: 55, width: 55,),
              const SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hi! ${homeCtrl.userData.value?.userFname ?? ""}",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: Colors.white
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Text(
                    "(+91) ${homeCtrl.userData.value?.userMobile ?? ""}",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.white70
                    ),
                  ),
                ],
              ),
            ],
          ),
          Icon(Icons.navigate_next, size: 30, color: Colors.white,)
        ],
      ),
    );
  }


  Future<bool?> logoutDialogNew(){
    return showDialog(
        context: context,
        builder: (BuildContext context)
        {
          return AlertDialog(
            title: const Text('Do you really want to Logout!',style: TextStyle(
                color: Colors.black
            ),),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('No',
                  style: TextStyle(color: myprimarycolor, fontFamily: 'sb', fontSize: 16),),
              ),
              TextButton(
                onPressed: () {
                  SessionManager().logout();
                  Navigator.of(context).pop();
                  setState(() {});
                },
                child: const Text('Logout',
                  style: TextStyle(color: myprimarycolor, fontFamily: 'sb', fontSize: 16),),
              ),
            ],
          );
        }
    );
  }

}