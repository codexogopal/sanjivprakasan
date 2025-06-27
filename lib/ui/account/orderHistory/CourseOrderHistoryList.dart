import 'dart:async';
import 'dart:io' show Platform;
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sanjivprkashan/controller/CartController.dart';
import 'package:sanjivprkashan/ui/account/orderHistory/OrderDetailsScreen.dart';
import 'package:sanjivprkashan/ui/course/CourseDetailsScreen.dart';
import 'package:sanjivprkashan/ui/testSeries/TestSeriesCourseDetailsScreen.dart';

import '../../../theme/mythemcolor.dart';
import '../../../utils/AppBars.dart';
import '../../../utils/styleUtil.dart';


class CourseOrderHistoryList extends StatefulWidget {
  final cType;
  const CourseOrderHistoryList({super.key, required this.cType});

  @override
  State<StatefulWidget> createState() => _CourseOrderHistoryListState();
}

class _CourseOrderHistoryListState extends State<CourseOrderHistoryList>
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
    catCtrl.getCourseOrderHistoryList(widget.cType);
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
                otherAppBar(context, "My Orders", true, isCartShow: false),
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
          child: catCtrl.courseOrderList.isEmpty ? emptyWidget(context, "No Order placed yet") : ListView.builder(
            padding: const EdgeInsets.all(0),
            itemCount: catCtrl.courseOrderList.length,
            itemBuilder: (context, index) {
              final product = catCtrl.courseOrderList[index];
              ValidityStatus result = checkItemValidityMonthWise(product.transDatetime ?? "", validityMonths: int.parse(
                  widget.cType == "t" ? (product.belongsToCsTest?.subPackValidity ?? "0") : (product.belongsToCsCourses?.courseValidity ?? "0")));
              // ValidityStatus result = checkItemValidityMonthWise("2024-04-22T18:10:01.000000Z" , validityMonths: 0);
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
                                    product.transCourseName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontSize: 15),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Remaining days: ",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(fontSize: 13,
                                              fontWeight: FontWeight.normal,
                                              color: Theme.of(context).hintColor,),
                                          ),
                                          Text(
                                            "${result.remainingDays} ",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                              fontSize: 13,
                                            ),
                                          ),
                                          if(result.status != "Valid")
                                            Text(
                                              "(${result.status})",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                  fontSize: 13,
                                                  color: result.color
                                              ),
                                            ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Price: ",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(fontSize: 13,
                                              fontWeight: FontWeight.normal,
                                              color: Theme.of(context).hintColor,),
                                          ),
                                          Text(
                                            "₹${product.transAmt}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                              fontSize: 13,
                                              color: myprimarycolor
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
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

                                        if(result.status == "Expired")
                                        const SizedBox(height: 15,),
                                        if(result.status == "Expired")
                                        Container(
                                          width: 170,
                                          alignment: Alignment.centerRight,
                                          child: ElevatedButton(
                                            // onPressed: !catCtrl.isProductAdding.value ? addToCart : null,
                                            onPressed: () {
                                              if(widget.cType == "c"){
                                                Get.to(() =>
                                                    CourseDetailsScreen(
                                                      courseData: product
                                                          .belongsToCsCourses!,
                                                      cImage: catCtrl.cImageUrl + product.belongsToCsCourses!.coursesImage!,));
                                              }else {
                                                  Get.to(() =>
                                                      TestSeriesCourseDetailsScreen(
                                                        courseData: product
                                                            .belongsToCsTest!,
                                                        cImage: catCtrl
                                                            .cImageUrl + product
                                                            .belongsToCsTest!
                                                            .subPackImage,));

                                              }
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
                                              'Renew',
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
