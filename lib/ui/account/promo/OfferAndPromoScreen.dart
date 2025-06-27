import 'dart:async';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get.dart';
import 'package:sanjivprkashan/controller/CartController.dart';

import '../../../theme/mythemcolor.dart';
import '../../../utils/styleUtil.dart';


class OfferAndPromoScreen extends StatefulWidget {
  final String cartAmount;
  final String pType;
  final String courseId;
  const OfferAndPromoScreen({super.key, required this.cartAmount, required this.pType, required this.courseId});

  @override
  State<StatefulWidget> createState() => _OfferAndPromoScreen();
}


class _OfferAndPromoScreen extends State<OfferAndPromoScreen> {
  final CartController caCtrl = Get.put(CartController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();


  TextEditingController mobileController = TextEditingController();
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 500), (){
      getData();
    });
  }
  @override
  void dispose() {
    super.dispose();
  }
  Future<void> getData() async {
    caCtrl.getPromoList(widget.pType);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      // appBar: myStatusBar(context),
      body: SafeArea(
        child: Obx(() {
          if (caCtrl.isLoading.value) {
            return Center(child: apiLoader());
          }
          return RefreshIndicator(
            onRefresh: () => getData(),
            child: Column(
              children: [
                otherAppBar(context, "Offers and Promo", true, isCartShow: false),
                addBody(),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget addBody(){
    return catVeiw();
  }

  Widget catVeiw(){
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final mainCats = caCtrl.promoList;
    if (caCtrl.promoList.isEmpty) {
      return emptyWidget(context, "No Offers or Coupon found"); // Or your loader
    }
    return Obx(() {
      return Expanded(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: mainCats.length,
          itemBuilder: (context, index) {
            final product = mainCats[index];
            return Column(
              children: [
                if(index == 0)
                  Container(
                    padding:
                    const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 10.0),
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: SizedBox(
                      height: 50,
                      child: TextFormField(
                        onChanged: (value) {

                        },
                        cursorColor: Colors.grey,
                        scrollPadding: EdgeInsets.only(
                            bottom:
                            MediaQuery.of(context).viewInsets.bottom),
                        controller: mobileController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'Enter Coupon Code',
                          suffix : InkWell(
                            onTap: (){
                              Map<String, String> cartData = {
                                "promocode" : mobileController.text.trim().toString(),
                                "totalAmount" : widget.cartAmount,
                                "promoApplicable" : widget.pType,
                                "courseId": widget.courseId,
                              };
                              caCtrl.applyPromoCode(cartData);
                            },
                            child: Text(
                              'Apply',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontSize: 14,
                                  color: myprimarycolor,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                          ),
                          hintStyle:  Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w600
                        ),
                          counterText: "",
                          floatingLabelBehavior:
                          FloatingLabelBehavior.never,
                          contentPadding:
                          const EdgeInsets.fromLTRB(15, 15, 15, 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(50, 88, 88, 88),
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7.0),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(50, 88, 88, 88),
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                if(index == 0)
                SizedBox(height: 10,),
                Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 20, 15, 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                  DottedBorder(
                                  color: myprimarycolor,
                                  strokeWidth: 1,
                                  child: Container(
                                    color: Colors.grey.shade200,
                                    padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
                                    child: Text(
                                      product.promoCouponCode,
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        letterSpacing: 8
                                      ),
                                      maxLines: 3,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: (){
                                    Map<String, String> cartInfo = {
                                      'promocode' : product.promoCouponCode,
                                      'totalAmount' : widget.cartAmount,
                                      "promoApplicable" : widget.pType,
                                      "courseId": widget.courseId,
                                    };
                                    caCtrl.applyPromoCode(cartInfo);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Apply",
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontSize: 14,
                                          color: myprimarycolor,
                                          fontWeight: FontWeight.w600
                                      ),
                                      maxLines: 3,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15,),
                            Text(
                              product.promoName,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontSize: 14,
                                  color: Theme.of(context).hintColor,
                                  fontWeight: FontWeight.normal
                              ),
                              maxLines: 3,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Visibility(
                              visible: product.promoDescription != "",
                              child: Text(
                                product.promoDescription,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontSize: 12,
                                  color: Theme.of(context).hintColor,
                                    fontWeight: FontWeight.normal
                                ),
                                maxLines: 3,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      hrWidget(),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );
    });

  }

}