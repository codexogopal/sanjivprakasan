import 'dart:async';
import 'dart:io' show Platform;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sanjivprkashan/controller/CategoriesController.dart';
import 'package:sanjivprkashan/model/books/ChildCategoryModel.dart';
import 'package:sanjivprkashan/ui/product/ProductDetailScreen.dart';
import 'package:sanjivprkashan/ui/web/MyWebView.dart';
import 'package:upgrader/upgrader.dart';

import '../../../theme/mythemcolor.dart';
import '../../../utils/AppBars.dart';
import '../../../utils/styleUtil.dart';


class MyEBookScreen extends StatefulWidget {

  const MyEBookScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MyEBookScreenState();
}

class _MyEBookScreenState extends State<MyEBookScreen>
    with TickerProviderStateMixin {
  final CategoriesController catCtrl = Get.put(CategoriesController());
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
    catCtrl.getMyEBookList();
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
                otherAppBar(context, "E Books", true),
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
          child: catCtrl.myeBooksList.isEmpty ? emptyWidget(context, "No book preached yet") : ListView.builder(
            padding: const EdgeInsets.all(0),
            itemCount: catCtrl.myeBooksList.length,
            itemBuilder: (context, index) {
              final product = catCtrl.myeBooksList[index];
              ValidityStatus result = checkItemValidity(product.purchaseDate!);
              // ValidityStatus result = checkItemValidity("2024-04-22T18:10:01.000000Z");
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: (){
                      result.status != "Expired" ? Get.to(()=> MyWebView(mPdfFile: catCtrl.ebookBaseUrl+product.productPdf)) : null;
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
                          setCachedImage(
                            product.productImage,
                            100, 80, 5,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    product.productName ?? '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontSize: 13),
                                  ),
                                  const SizedBox(height: 3,),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Order date: ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                          fontSize: 10,
                                            color: Theme.of(context).hintColor
                                        ),
                                      ),
                                      Text(
                                        formatDateForEBook(product.purchaseDate ?? ''),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5,),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Remaining days: ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                          fontSize: 11,
                                            color: Theme.of(context).hintColor
                                        ),
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

                                  if(result.status == "Expired")
                                    OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                          minimumSize: const Size(40, 30),
                                        ),
                                        onPressed: (){
                                          Get.to(()=> ProductDetailScreen(pId: product.productId.toString()));
                                        }, child: Text(
                                      "Renew",
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: myprimarycolor,
                                        fontSize: 13,
                                        fontWeight: FontWeight.normal
                                      )
                                    )),
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
}
