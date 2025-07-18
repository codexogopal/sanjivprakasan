import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sanjivprkashan/controller/CourseController.dart';
import 'package:sanjivprkashan/controller/TestSeriesController.dart';
import 'package:sanjivprkashan/ui/testSeries/TestSeriesCourseDetailsScreen.dart';

import '../../../theme/mythemcolor.dart';
import '../../../utils/AppBars.dart';
import '../../../utils/styleUtil.dart';
import '../web/MyWebView.dart';
import 'CourseDetailsScreen.dart';


class SubCatCourseScreen extends StatefulWidget {
  final String catID;
  final String title;
  final bool isShowHeader;
  const SubCatCourseScreen({super.key, required this.catID, required this.title, required this.isShowHeader});

  @override
  State<StatefulWidget> createState() => _SubCatCourseScreenState();
}

class _SubCatCourseScreenState extends State<SubCatCourseScreen>{
  final CourseController catCtrl = Get.put(CourseController());
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
    catCtrl.getAllTestSeriesCourseList(widget.catID, "subCat");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      appBar: widget.isShowHeader ? AppBars.myAppBar(widget.title, context, true) : null,
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
          child: catCtrl.allSubCatCourseList.isEmpty ? Center(child: emptyWidget(context, "No course found", onRefresh: getData)) : ListView.builder(
            padding: const EdgeInsets.all(0),
            itemCount: catCtrl.allSubCatCourseList.length,
            itemBuilder: (context, index) {
              final product = catCtrl.allSubCatCourseList[index];
              // ValidityStatus result = checkItemValidity("2024-04-22T18:10:01.000000Z");
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: (){
                      if(product.courseType == 1){
                        Get.to(() => CourseDetailsScreen(courseData: product, cImage: catCtrl.imageUrl.value+product.coursesImage!));
                      }else{
                        if(product.coursePdf != null){
                          Get.to(()=> MyWebView(mPdfFile: catCtrl.pdfViewerUrl.value+(product.coursePdf ?? "")));
                        }else{
                          showSnackbar("File not found", "File not found");
                        }
                      }
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
                            catCtrl.imageUrl.value+(product.coursesImage ?? ""),
                            60, 100, 5,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    product.coursesName ?? '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontSize: 13,),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5,),
                                  // const SizedBox(height: 5,),
                                  if(product.courseType == 1)
                                  Row(
                                    children: [
                                      Text(
                                        "₹${product.courseActualPrice ?? ''} ",
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          color: myprimarycolor,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        "₹${product.coursesPrice ?? ''} ",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium?.copyWith(
                                          fontSize: 10,
                                          color: Theme.of(context).hintColor,
                                          decoration: TextDecoration.lineThrough,
                                          decorationColor:
                                          Theme.of(context).hintColor,
                                          decorationThickness: 3.0,
                                        ),
                                      ),
                                      Text(
                                        "(${getDiscountInPerstions(product.coursesPrice ?? "", product.courseDiscountPrice ?? '0')}%)",
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          color: Colors.green,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if(product.courseType == 0)
                                  Text(
                                    "Free",
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: myprimarycolor,
                                      fontSize: 15,
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
}
