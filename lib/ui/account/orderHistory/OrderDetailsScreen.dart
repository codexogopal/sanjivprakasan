import 'dart:async';
import 'dart:io' show Platform;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sanjivprkashan/controller/CartController.dart';
import 'package:sanjivprkashan/model/books/ChildCategoryModel.dart';
import 'package:sanjivprkashan/ui/product/ProductDetailScreen.dart';
import 'package:sanjivprkashan/ui/web/MyWebView.dart';
import 'package:upgrader/upgrader.dart';

import '../../../theme/mythemcolor.dart';
import '../../../utils/AppBars.dart';
import '../../../utils/styleUtil.dart';


class OrderDetailsScreen extends StatefulWidget {
 final orderId;
  const OrderDetailsScreen({super.key , required this.orderId});

  @override
  State<StatefulWidget> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen>
    with TickerProviderStateMixin {
  final CartController catCtrl = Get.put(CartController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool showLitItem = false;
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 100), (){
      getData();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getData() async {
    Map<String, String> userData = {
      "trans_id" : widget.orderId.toString()
    };
    catCtrl.getOrderOrderDetails(userData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      appBar: myStatusBar(context),
      body: SafeArea(
        child: Obx(() {
          if (catCtrl.isLoading.value) {
            return Center(child: apiLoader());
          }

          return RefreshIndicator(
            onRefresh: () => getData(),
            child: ListView(
              children: [
                otherAppBar(context, "Order : ${catCtrl.orderData.value?.transOrderNumber ?? ""}", true),
                tabvew(),
              ],
            ),
          );
        }),
      ),
    );
  }


  Widget summeryView(){
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
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16),
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
                  "₹${double.parse(catCtrl.orderItemCartSummary["subTotal"].toString() ?? "0.00").toStringAsFixed(2) ?? "0.00"}",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.normal,
                      fontSize: 16),
                ),
              ),
            ],
          ),
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
                  "+₹${double.parse(catCtrl.orderItemCartSummary["GST"].toString() ?? "0.00").toStringAsFixed(2) ?? "0.00"}",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.normal,
                      fontSize: 16),
                ),
              ),
            ],
          ),
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
                  "-₹${double.parse(catCtrl.orderItemCartSummary["discount"].toString() ?? "0.00").toStringAsFixed(2) ?? "0.00"}",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.normal,
                      color: Colors.green,
                      fontSize: 16),
                ),
              ),
            ],
          ),
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
                  "-${catCtrl.orderItemCartSummary["Coupon Discount"] == "" ? "₹0.00" : catCtrl.orderItemCartSummary["Coupon Discount"]}",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.normal,
                      color: Colors.green,
                      fontSize: 16),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Shipping Charge",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).hintColor),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  catCtrl.orderItemCartSummary["Delivery Charges"] == 0 ? "Free" :
                  "${catCtrl.orderItemCartSummary["Delivery Charges"] ?? "₹0.00"}",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.normal,
                      color: catCtrl.orderItemCartSummary["Delivery Charges"] == 0 ? Colors.green : null,
                      fontSize: 16),
                ),
              ),
            ],
          ),
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
                  "₹${double.parse(catCtrl.orderItemCartSummary["Grand total"].toString() ?? "0.00").toStringAsFixed(2) ?? "0.00"}",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: myprimarycolor, fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget cartListItem(){
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final mainCats = catCtrl.orderedItemList;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10,),
        Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Column(
            children: [

              InkWell(
                onTap: (){
                  setState(() {
                    showLitItem = !showLitItem;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Order Items List",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.normal),
                      ),
                      InkWell(
                        onTap: (){

                        },
                        child: Icon(showLitItem ? Icons.keyboard_arrow_up_outlined : Icons.keyboard_arrow_down, size: 25,),
                      ),
                    ],
                  ),
                ),
              ),

              if(!showLitItem)
                SizedBox(height: 10,),
              if(showLitItem)
              Obx(() {
                if (catCtrl.isLoading.value) {
                  return Center(child: apiLoader());
                }
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  // Prevent internal scrolling
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                  itemCount: mainCats.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                    childAspectRatio: 2.2,
                  ),
                  itemBuilder: (context, index) {
                    final item = mainCats[index];
                    return InkWell(
                      onTap: (){

                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 5,),
                        decoration: BoxDecoration(
                          color:
                          Theme.of(
                            context,
                          ).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(
                            12,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                              isDarkTheme
                                  ? myprimarycolor
                                  .withAlpha(80)
                                  : Colors.black12,
                              blurRadius: 4,
                              offset: Offset(-0.5, 0),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: setCachedImage(
                                item.tdItemImage,
                                130,
                                90,
                                5,
                              ),
                            ),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding:
                                    const EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 20,),
                                        Text(
                                          item.tdItemTitle ?? '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(fontSize: 12),
                                        ),

                                        Text(
                                          item.tdItemType == 0 ? "Ebook" : "Physical",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                            color: Theme.of(context).hintColor,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Row(
                                          children: [
                                            Text(
                                              "₹${item.tdItemSelllingPrice ?? ''} ",
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleMedium?.copyWith(
                                                color: myprimarycolor,
                                                fontSize: 16,
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              "₹${item.tdItemNetPrice ?? ''} ",
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleMedium?.copyWith(
                                                fontSize: 14,
                                                color: Theme.of(context).hintColor,
                                                decoration: TextDecoration.lineThrough,
                                                decorationColor:
                                                Theme.of(context).hintColor,
                                                decorationThickness: 3.0,
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              "(${getDiscountInPerstions(item.tdItemNetPrice ?? "",
                                                  (double.parse(item.tdItemNetPrice) - double.parse(item.tdItemSelllingPrice)).toStringAsFixed(2) ?? '0')}%)",
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleMedium?.copyWith(
                                                color: Colors.green,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),

                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        ),

      ],
    );
  }

  Widget tabvew() {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: (){

              },
              child: Container(
                width: screenWidth,
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0,),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  color:
                  Theme.of(
                    context,
                  ).colorScheme.primaryContainer,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Delivery Address',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontSize: 15),
                            ),
                            const SizedBox(height: 7,),
                            Text(
                              catCtrl.orderData.value?.transUserName ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                  fontSize: 14,
                                  color: Theme.of(context).hintColor,
                                  fontWeight: FontWeight.w900
                              ),
                            ),
                            const SizedBox(height: 7,),
                            Text(
                              catCtrl.orderData.value?.transBillingAddress ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: Theme.of(context).hintColor,),
                            ),
                            const SizedBox(height: 7,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Email Id : ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                    fontSize: 13,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                                Text(
                                  catCtrl.orderData.value?.transUserEmail ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                      fontSize: 13,
                                      color: Theme.of(context).hintColor,
                                      fontWeight: FontWeight.normal
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 7,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Phone number : ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                    fontSize: 13,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                                Text(
                                  "${catCtrl.orderData.value?.transUserMobile} ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                      fontSize: 13,
                                      color: Theme.of(context).hintColor,
                                      fontWeight: FontWeight.normal
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8,),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: setStatusColor(catCtrl.orderData.value?.orderStatus ?? "") ,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                catCtrl.orderData.value?.orderStatus ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            DottedLine(dashColor: myprimarycolor.withAlpha(50)),
                            SizedBox(height: 15),

                            Container(
                              width: double.infinity,
                              height: 70,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.secondaryContainer,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'ORDER ID',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontSize: 15),
                                  ),
                                  const SizedBox(height: 7,),
                                  Text(
                                    catCtrl.orderData.value?.transOrderNumber ?? '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                        fontSize: 13,
                                        color: Theme.of(context).hintColor,
                                        fontWeight: FontWeight.w900
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 15,),
                            SizedBox(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    textAlign: TextAlign.center,
                                    'ORDER ON',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                      color: Theme.of(context).hintColor,),
                                  ),

                                  Text(
                                    textAlign: TextAlign.center,
                                    formatDateForEBook(catCtrl.orderData.value?.transDatetime ?? ''),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                      color: Theme.of(context).hintColor,),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        cartListItem(),
        const SizedBox(height: 10,),
        summeryView()
      ],
    );
  }

  Color setStatusColor(String value) {
    switch (value) {
      case 'Pending payment':
        return Colors.orange;
      case 'Processing':
        return Colors.blue;
      case 'Shipped':
        return Colors.purple;
      case 'Delivered':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      case 'On hold':
        return Colors.brown;
      case 'Item Picked Up':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

}
