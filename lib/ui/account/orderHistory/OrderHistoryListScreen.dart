import 'dart:async';
import 'dart:io' show Platform;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sanjivprkashan/controller/CartController.dart';
import 'package:sanjivprkashan/model/books/ChildCategoryModel.dart';
import 'package:sanjivprkashan/ui/account/orderHistory/OrderDetailsScreen.dart';
import 'package:sanjivprkashan/ui/product/ProductDetailScreen.dart';
import 'package:sanjivprkashan/ui/web/MyWebView.dart';
import 'package:upgrader/upgrader.dart';

import '../../../theme/mythemcolor.dart';
import '../../../utils/AppBars.dart';
import '../../../utils/styleUtil.dart';


class OrderHistoryListScreen extends StatefulWidget {

  const OrderHistoryListScreen({super.key});

  @override
  State<StatefulWidget> createState() => _OrderHistoryListScreenState();
}

class _OrderHistoryListScreenState extends State<OrderHistoryListScreen>
    with TickerProviderStateMixin {
  final CartController catCtrl = Get.put(CartController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
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
    catCtrl.getOrderHistoryList();
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
            child: Column(
              children: [
                otherAppBar(context, "My Orders", true),
                Flexible(child: tabvew()),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget tabvew() {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Flexible(
          child: catCtrl.orderList.isEmpty ? emptyWidget(context, "No Order placed yet") : ListView.builder(
            padding: const EdgeInsets.all(0),
            itemCount: catCtrl.orderList.length,
            itemBuilder: (context, index) {
              final product = catCtrl.orderList[index];
              ValidityStatus result = checkItemValidity(product.transDatetime!);
              // ValidityStatus result = checkItemValidity("2024-04-22T18:10:01.000000Z");
              return Row(
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
                                    product.transUserName ?? '',
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
                                    product.transBillingAddress ?? '',
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
                                        product.transUserEmail ?? "",
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
                                        "${product.transUserMobile} ",
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
                                      color: setStatusColor(product.orderStatus) ,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      product.orderStatus ?? '',
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
                                          product.transOrderNumber ?? '',
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
                                          formatDateForEBook(product.transDatetime ?? ''),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(fontSize: 13,
                                            fontWeight: FontWeight.normal,
                                            color: Theme.of(context).hintColor,),
                                        ),

                                        const SizedBox(height: 15,),
                                        Container(
                                          width: 170,
                                          alignment: Alignment.centerRight,
                                          child: ElevatedButton(
                                            // onPressed: !catCtrl.isProductAdding.value ? addToCart : null,
                                            onPressed: () {
                                              Get.to(()=> OrderDetailsScreen(orderId: product.transId));
                                            },
                                            style: ElevatedButton.styleFrom(
                                              elevation: 0,
                                              backgroundColor: Theme.of(context).primaryColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(7),
                                              ),
                                              minimumSize: const Size(double.infinity, 50),
                                            ),

                                            child:
                                            !catCtrl.isProductAdding.value
                                                ? Text(
                                              'View Details',
                                              style: Theme.of(context).textTheme.titleMedium
                                                  ?.copyWith(color: Colors.white),
                                            )
                                                : SizedBox(height: 50,child: buttonLoader()),
                                          ),
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
              );
            },
          ),
        ),
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
