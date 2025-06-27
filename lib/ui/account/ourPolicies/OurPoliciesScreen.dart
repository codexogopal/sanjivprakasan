import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get.dart';
import 'package:sanjivprkashan/Constant.dart';
import 'package:sanjivprkashan/controller/HomeController.dart';
import 'package:sanjivprkashan/ui/account/ac/MyAccountScreen.dart';
import 'package:sanjivprkashan/ui/account/address/MyAddressList.dart';
import 'package:sanjivprkashan/ui/account/myebook/MyEBookScreen.dart';
import 'package:sanjivprkashan/ui/account/mywishlist/MyWishlistScreen.dart';
import 'package:sanjivprkashan/ui/account/orderHistory/OrderHistoryListScreen.dart';
import 'package:sanjivprkashan/ui/web/MyWebView.dart';

import '../../../theme/mythemcolor.dart';
import '../../../utils/styleUtil.dart';


class OurPoliciesScreen extends StatefulWidget {
  const OurPoliciesScreen({super.key});

  @override
  State<StatefulWidget> createState() => _OurPoliciesScreen();
}


class _OurPoliciesScreen extends State<OurPoliciesScreen> {
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
          return Column(
            children: [
                otherAppBar(context, "Our Policies & Useful Links", true, isCartShow: false),
              Flexible(
                child: ListView(
                  children: [
                    const SizedBox(height: 10,),
                    InkWell(
                        onTap: (){
                          openWhatsApp(Constant.privacyPolicy);
                        },
                        child: itemView("privacy-policy", "Privacy Policy")
                    ),
                    const SizedBox(height: 10,),
                    InkWell(
                        onTap: (){
                          openWhatsApp(Constant.termsUrl);
                        },
                        child: itemView("tnc", "Terms of Service")
                    ),
                    const SizedBox(height: 10,),
                    InkWell(
                        onTap: (){
                          openWhatsApp(Constant.termsConditionUrl);
                        },
                        child: itemView("tnc", "Terms & Conditions")
                    ),
                    const SizedBox(height: 10,),
                    InkWell(onTap: (){
                      openWhatsApp(Constant.termsOfEBookSaleUrl);
                    },child: itemView("tnc", "Terms of Ebook Sale")),
                    const SizedBox(height: 10,),
                    InkWell(
                        onTap: (){
                          openWhatsApp(Constant.bookShippingPolicyUrl);
                        },
                        child: itemView("privacy-policy", "Book Shipping Policy")
                    ),
                    const SizedBox(height: 10,),
                    InkWell(
                        onTap: (){
                          openWhatsApp(Constant.faqUrl);
                        },
                        child: itemView("qa", "FAQs")
                    ),
                    const SizedBox(height: 10,),
                    InkWell(
                        onTap: (){
                          openWhatsApp(Constant.aboutUsUrl);
                        },
                        child: itemView("about-us", "About Us")
                    ),
                    const SizedBox(height: 10,),
                    InkWell(
                        onTap: (){
                          openWhatsApp(Constant.contactUs);
                        },
                        child: itemView("email", "Contact Us")
                    ),
                  ],
                ),
              ),
            ],
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
}