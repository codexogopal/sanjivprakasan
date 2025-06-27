import 'dart:async';
import 'dart:io' show Platform;
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controller/CartController.dart';
import '../../controller/TestSeriesController.dart';
import '../../model/testSeries/AllTestCourseListModel.dart';
import '../../theme/mythemcolor.dart';
import '../../utils/styleUtil.dart';
import '../account/promo/OfferAndPromoScreen.dart';

class TestSeriesCourseDetailsScreen extends StatefulWidget {
  final AllTestCourseListModel courseData;
  final cImage;

  const TestSeriesCourseDetailsScreen({super.key, required this.courseData, required this.cImage});

  @override
  State<StatefulWidget> createState() => TestSeriesCourseDetailsScreenState();
}

class TestSeriesCourseDetailsScreenState extends State<TestSeriesCourseDetailsScreen> {
  final TestSeriesController catCtrl = Get.put(TestSeriesController());
  final CartController cartCtrl = Get.put(CartController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLike = false;

  double value = 3.5;
  String selectedPType = "0";
  int pQuantity  = 1;
  @override
  void initState() {
    isLike = false;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final product = widget.courseData;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      // appBar: myStatusBar(context),
      bottomNavigationBar: Container(
        height: 80,
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx((){
                return
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Total",
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).hintColor,
                        ),
                      ),

                      if(cartCtrl.appliedPromo.isEmpty)
                        Text(
                          "₹${product.subActualPrice ?? ''} ",
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            fontSize: 16,
                          ),
                        ),
                      if(cartCtrl.appliedPromo.isNotEmpty)
                        Text(
                          "₹${double.parse((cartCtrl.appliedPromo["finalAmount"] ?? 0.00).toString()).toStringAsFixed(2) ?? "0.00"}",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontSize: 16),
                        ),
                    ],
                  );
              }),
              Container(
                width: 170,
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: !cartCtrl.isBuying.value ? proceedToPay : null,
                  // onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),

                  child:
                  !cartCtrl.isBuying.value
                      ? Text(
                    'Proceed to buy',
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(color: Colors.white),
                  )
                      : SizedBox(height: 50,child: buttonLoader()),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (catCtrl.isLoading.value) {
            return Center(child: apiLoader());
          }
          return Column(
            children: [
              otherAppBar(context, "", true, isCartShow: false),
              Flexible(
                child: ListView(children: [addBody(), SizedBox(height: 50)]),
              ),
            ],
          );
        }),
      ),
    );
  }

  void proceedToPay(){

    Map<String, String> pData = {
      "course_id" : widget.courseData.subPackId.toString(),
      "final_amt" : cartCtrl.appliedPromo.isNotEmpty ?
          cartCtrl.appliedPromo["finalAmount"].toString():
      widget.courseData.subActualPrice.toString(),
      "gst_amt" : "0",
      "discount_amt" : widget.courseData.courseDiscountPrice.toString(),
      "payment_method" : "upi",
      "temp_course_type" : "0",

    };
    cartCtrl.createTampCourseOrder(pData, "t");
  }

  Widget addBody() {
    return Column(
        children: [
          SizedBox(height: 10),
          catVeiw(),
          SizedBox(height: 10),
          couponWidget(),
          SizedBox(height: 10),
          summeryView(),
        ]
    );
  }



  Widget couponWidget() {

    return cartCtrl.appliedPromo.isEmpty
        ? InkWell(
      onTap: () {
        Get.to(OfferAndPromoScreen(cartAmount: double.parse(widget.courseData.subActualPrice.toString() ?? "0.00").toStringAsFixed(2),pType: "2", courseId: widget.courseData.subPackId.toString()));
      },
      child: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        padding: const EdgeInsets.fromLTRB(10, 20, 8, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/presents.png',
                  width: 30,
                  height: 25,
                ),
                // Icon(Icons.favorite_border,size: 22,color: Theme.of(context).hintColor,),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Apply Coupon',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.normal,
                          fontSize: 15
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Icon(
              Icons.navigate_next,
              size: 26,
              color: Theme.of(context).hintColor,
            )
          ],
        ),
      ),
    )
        : Container(
      padding: const EdgeInsets.fromLTRB(10, 15, 8, 15),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/presents.png',
                width: 30,
                height: 25,
              ),
              // Icon(Icons.favorite_border,size: 22,color: Theme.of(context).hintColor,),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Applied Coupon',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                        color: Theme.of(context).hintColor
                    ),
                  ),
                  Text(
                    cartCtrl.appliedPromo["promo_code"],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 16,
                        color: Colors.green
                    ),
                  ),
                ],
              ),
            ],
          ),
          InkWell(
              onTap: () {
                cartCtrl.appliedPromo.clear();
              },
              child: Icon(
                Icons.close,
                size: 26,
                color: Theme.of(context).hintColor,
              ))
        ],
      ),
    );
  }

  Widget summeryView(){
    final product = widget.courseData;
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.primaryContainer,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Cart Summary",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.normal),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Item Total",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).hintColor),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "₹${double.parse(product.subPackPrice.toString() ?? "0.00").toStringAsFixed(2) ?? "0.00"}",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.normal,
                      fontSize: 16),
                ),
              ),
            ],
          ),/*
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "GST",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).hintColor),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  // "+₹${double.parse(cartCtrl.cartSummary["item_gst"].toString() ?? "0.00").toStringAsFixed(2) ?? "0.00"}",
                  "+₹0",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.normal,
                      fontSize: 16),
                ),
              ),
            ],
          ),*/
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Discount",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).hintColor),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "-₹${double.parse(product.courseDiscountPrice.toString() ?? "0.00").toStringAsFixed(2) ?? "0.00"}",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.normal,
                      color: Colors.green,
                      fontSize: 16),
                ),
              ),
            ],
          ),

          if(cartCtrl.appliedPromo.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Coupon Discount",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Theme.of(context).hintColor),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    // "-₹${double.parse(cartCtrl.appliedPromo["discountAmount"].toString() ?? "0.00").toStringAsFixed(2) ?? "0.00"}",
                    "-₹${double.parse((cartCtrl.appliedPromo["discountAmount"] ?? 0.00).toString()).toStringAsFixed(2) ?? "0.00"}",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.normal,
                        color: Colors.green,
                        fontSize: 16),
                  ),
                ),
              ],
            ),
          if(cartCtrl.appliedPromo.isEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Amount",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "₹${double.parse((product.subActualPrice.toString() ?? 0.00).toString()).toStringAsFixed(2) ?? "0.00"}",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: myprimarycolor, fontSize: 16),
                ),
              ),
            ],
          ),
          if(cartCtrl.appliedPromo.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Amount",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "₹${double.parse((cartCtrl.appliedPromo["finalAmount"] ?? 0.00).toString()).toStringAsFixed(2) ?? "0.00"}",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: myprimarycolor, fontSize: 16),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget catVeiw() {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final product = widget.courseData;
    if (product == null) {
      return SizedBox(
        height: MediaQuery.of(context).size.height - 60,
        child: Center(child: Text("No products Detail")),
      ); // Or your loader
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Padding(
                padding: const EdgeInsets.all(1.0),
                child: setCachedImage(
                  widget.cImage,
                  200,
                  MediaQuery.of(context).size.width,
                  5,
                ),
              ),
              SizedBox(height: 15),
              DottedLine(dashColor: myprimarycolor.withAlpha(50)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            product.subPackTitle ?? '',
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          children: [
                            Text(
                              "₹${product.subActualPrice ?? ''} ",
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: myprimarycolor,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Text(
                              "₹${product.subPackPrice ?? ''} ",
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium?.copyWith(
                                fontSize: 16,
                                color: Theme.of(context).hintColor,
                                decoration: TextDecoration.lineThrough,
                                decorationColor:
                                Theme.of(context).hintColor,
                                decorationThickness: 3.0,
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Text(
                              "(${getDiscountInPerstions(product.subPackPrice ?? "", product.courseDiscountPrice ?? '0')}%)",
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.green,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                RatingStars(
                                  axis: Axis.horizontal,
                                  value: 5.0,
                                  onValueChanged: (v) {
                                    //
                                    setState(() {
                                      value = v;
                                    });
                                  },
                                  starCount: 5,
                                  starSize: 15,
                                  valueLabelRadius: 10,
                                  maxValue: 5,
                                  starSpacing: 3,
                                  maxValueVisibility: true,
                                  valueLabelVisibility: false,
                                  animationDuration: Duration(
                                    milliseconds: 1000,
                                  ),
                                  valueLabelPadding: const EdgeInsets.symmetric(
                                    vertical: 1,
                                    horizontal: 8,
                                  ),
                                  valueLabelMargin: const EdgeInsets.only(
                                    right: 8,
                                  ),
                                  starOffColor: const Color(0xffe7e8ea),
                                  starColor: const Color(0XFFf8b81f),
                                  angle: 0,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "(5)",
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontSize: 13),
                                ),
                              ],
                            ),
/*
                            InkWell(
                              onTap: (){
                                catCtrl.addRemoveWishlist(widget.pId);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                                child:   catCtrl.addFav.value ? apiLoader(size: 30) : Icon(catCtrl.product_fav.value == 0 ? Icons.favorite_border : Icons.favorite, size: 30, color: myprimarycolor,),
                              ),
                            ),*/
                          ],
                        ),

                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              DottedLine(dashColor: myprimarycolor.withAlpha(50)),
              SizedBox(height: 10),
              textSpanMobile("Number of Tests ", product.subPackNoTest),
            ],
          ),
        ),
        if(product.subPackShortDesc != null && product.subPackShortDesc != "")
          SizedBox(height: 10,),
        if(product.subPackShortDesc != null && product.subPackShortDesc != "")
          Container(
            color: Theme.of(context).colorScheme.primaryContainer,
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                htmlSpanMobile("Short Description", product.subPackShortDesc ?? ""),
              ],
            ),
          ),
        if(product.subPackDesc != null && product.subPackDesc != "")
          SizedBox(height: 10,),
        if(product.subPackDesc != null && product.subPackDesc != "")
          Container(
            color: Theme.of(context).colorScheme.primaryContainer,
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                htmlSpanMobile("Description", product.subPackDesc ?? ""),
              ],
            ),
          ),
      ],
    );
  }

  Widget textSpanMobile(String title, String value) {
    return Row(
      children: [
        Text.rich(
            textAlign: TextAlign.left,
            TextSpan(
                text: "$title: ",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 14,
                ),
                children: <InlineSpan>[
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ]
            )
        ),
      ],
    );
  }
  Widget htmlSpanMobile(String title, String value) {
    return Text.rich(
        textAlign: TextAlign.left,
        TextSpan(
            text: "$title: ",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 14,
            ),
            children: <InlineSpan>[
              WidgetSpan(child: HtmlWidget(value,textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.normal,
                  color: Theme.of(context).hintColor),))
            ]
        )
    );
  }
}
