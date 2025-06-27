import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sanjivprkashan/controller/CategoriesController.dart';
import 'package:sanjivprkashan/controller/TestSeriesController.dart';
import 'package:sanjivprkashan/ui/testSeries/TestSeriesCourseDetailsScreen.dart';
import 'package:sanjivprkashan/ui/product/ProductDetailScreen.dart';
import 'package:sanjivprkashan/ui/testSeries/MyTestSeriesDetailScreen.dart';
import 'package:sanjivprkashan/ui/web/MyWebView.dart';

import '../../../theme/mythemcolor.dart';
import '../../../utils/AppBars.dart';
import '../../../utils/styleUtil.dart';


class MyTestSeriesCourseScreen extends StatefulWidget {
  const MyTestSeriesCourseScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MyTestSeriesCourseScreenState();
}

class _MyTestSeriesCourseScreenState extends State<MyTestSeriesCourseScreen>{
  final TestSeriesController catCtrl = Get.put(TestSeriesController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    /*Timer(Duration(milliseconds: 100), (){
      getData();
    });*/
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getData() async {
    catCtrl.getMyCourseList();
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: catCtrl.myeCourseList.isEmpty ? Center(child: emptyWidget(context, "No Course found", onRefresh: getData)) : ListView.builder(
            padding: const EdgeInsets.all(0),
            itemCount: catCtrl.myeCourseList.length,
            itemBuilder: (context, index) {
              final product = catCtrl.myeCourseList[index].belongsToCSPackage;
              // ValidityStatus result = checkItemValidity("2024-04-22T18:10:01.000000Z");
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: (){
                        Get.to(() => MyTestSeriesDetailScreen(courseData: product, cImage: catCtrl.imageUrl.value+product.subPackImage));
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
                            catCtrl.imageUrl.value+product!.subPackImage ?? "",
                            90, 145, 5,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    product.subPackTitle ?? '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontSize: 13,),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5,),
                                  Text(
                                    "Test : ${product.subPackNoTest}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontSize: 13, fontWeight: FontWeight.normal),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5,),
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
