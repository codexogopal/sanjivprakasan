import 'dart:async';
import 'dart:io' show Platform;
import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:sanjivprkashan/model/myCourse/UserCourseListModel.dart';
import 'package:sanjivprkashan/ui/exam/ExamScreen.dart';
import 'package:sanjivprkashan/ui/exam/dialogs/examUtils.dart';

import '../../controller/CartController.dart';
import '../../controller/TestSeriesController.dart';
import '../../controller/ExamController.dart';
import '../../theme/mythemcolor.dart';
import '../../utils/styleUtil.dart';
import '../account/promo/OfferAndPromoScreen.dart';

class MyTestSeriesDetailScreen extends StatefulWidget {
  final BelongsToCSPackage courseData;
  final cImage;

  const MyTestSeriesDetailScreen({super.key, required this.courseData, required this.cImage});

  @override
  State<StatefulWidget> createState() => MyTestSeriesDetailScreenState();
}

class MyTestSeriesDetailScreenState extends State<MyTestSeriesDetailScreen> {
  final TestSeriesController catCtrl = Get.put(TestSeriesController());
  final CartController cartCtrl = Get.put(CartController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  double value = 3.5;
  String selectedPType = "0";
  int pQuantity  = 1;
  @override
  void initState() {
    super.initState();
    Map<String, String> courseData = {
      "utsc_course_id" : widget.courseData.subPackId.toString()
    };
    Timer(Duration(milliseconds: 150), (){
      catCtrl.getMyTestSeriesList(courseData);
    });
  }


  @override
  Widget build(BuildContext context) {
    final product = widget.courseData;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      body: SafeArea(
        child: Obx(() {
          if (catCtrl.isLoading.value) {
            return Center(child: apiLoader());
          }
          return Column(
            children: [
              otherAppBar(context, "", true, isCartShow: false),
              const SizedBox(height: 10,),
              Flexible(
                child: catVeiw(),
              ),
            ],
          );
        }),
      ),
    );
  }

  void addToCart(){
    Map<String, String> pData = {
      "selectedPrice" : selectedPType.toString(),
      "qty" : pQuantity.toString(),
    };
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
                          padding: const EdgeInsets.only(top: 0),
                          child: Text(
                            product.subPackTitle ?? '',
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 0),
              textSpanMobile("Number of Tests ", product.subPackNoTest),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
          child: Text(
            'Test Series :',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontSize: 16,
                color: myprimarycolor
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Flexible(
          child: catCtrl.myTestSeriesListData.isEmpty ? Center(child: emptyWidget(context, "No Test Series found",)) : ListView.builder(
            padding: const EdgeInsets.all(0),
            itemCount: catCtrl.myTestSeriesListData.length,
            itemBuilder: (context, index) {
              final product = catCtrl.myTestSeriesListData[index];
              RxBool isTimeUp = catCtrl.isTimeUpList[index];
              RxBool isResultTimeUp = catCtrl.isResultTimeUpList[index];
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: (){
                      final ExamController examCtrl = Get.put(ExamController());
                      examCtrl.testType.value = "${product.userTestSeries?.utsStatus ?? 0}";
                      if(product.testType == "1"){
                        if(product.userTestSeries?.utsStatus == 1 && isResultTimeUp.value){
                          Get.off(()=> ExamScreen(testID: product.testId.toString(), testType: "${product.userTestSeries?.utsStatus ?? 0}", courseId: widget.courseData.subPackId.toString(),));
                        }else if(product.userTestSeries?.utsStatus != 1 && isTimeUp.value){
                          Get.off(()=> ExamScreen(testID: product.testId.toString(), testType: "${product.userTestSeries?.utsStatus ?? 0}", courseId: widget.courseData.subPackId.toString(),));
                        }else{
                            showSnackbar("Oops...!", "This test series not allow to any action yet!");
                        }
                      }else{
                        Get.off(()=> ExamScreen(testID: product.testId.toString(), testType: "${product.userTestSeries?.utsStatus ?? 0}", courseId: widget.courseData.subPackId.toString(),));
                      }
                        },
                    child: Container(
                      width: screenWidth,
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0,),
                      padding: EdgeInsets.fromLTRB(product.testType == "1" ? 0 : 0, product.testType == "1" ? 0 : 10, 15, 10,),
                      decoration: BoxDecoration(
                        color:
                        Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if(product.testType == "1")
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Visibility(
                                  visible: false,
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(15, 3, 30, 3),
                                    decoration: BoxDecoration(
                                      color: myprimarycolor.withAlpha(40),
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(200)
                                      ),
                                    ),
                                    child: BlinkText(
                                      "Mega Test",
                                      beginColor: myprimarycolor.withAlpha(40),
                                      endColor: myprimarycolor,
                                      duration: Duration(milliseconds: 300),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(fontSize: 13,
                                          color: myprimarycolor
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  child: Row(
                                    children: [

                                      if(product.userTestSeries?.utsStatus != 1)
                                      Obx(() =>
                                          Text(
                                            isTimeUp.value ? "You can attempt test" : "Test Start On:- ",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                fontSize: 10,
                                                fontWeight: FontWeight.normal,
                                                color: Theme.of(context).hintColor
                                            ),
                                          ),
                                      ),
                                      if(product.userTestSeries?.utsStatus != 1)
                                        Obx(() =>
                                        Text(
                                          isTimeUp.value ? "" : formatDateForEBook(product.testScheduleDate ?? ""),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: myprimarycolor
                                          ),
                                        ),
                                        ),

                                      if(product.userTestSeries?.utsStatus == 1)
                                      Obx(() =>
                                          Text(
                                            isResultTimeUp.value ? "You can view result" : "View result on:- ",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                fontSize: 10,
                                                fontWeight: FontWeight.normal,
                                                color: Theme.of(context).hintColor
                                            ),
                                          ),
                                      ),

                                      if(product.userTestSeries?.utsStatus == 1)
                                        Obx(() =>
                                            Text(
                                              isResultTimeUp.value ? "" : formatDateForEBook(product.testAnnouncementDate ?? ""),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: myprimarycolor
                                              ),
                                            ),
                                        ),

                                      if(product.userTestSeries?.utsStatus != 1)
                                      CountdownTimer(
                                        endTime: DateFormat("yyyy-MM-dd HH:mm:ss")
                                        .parse(product.testScheduleDate ?? "")
                                        //     .parse("2025-06-19 17:46:00")
                                            .millisecondsSinceEpoch,
                                        onEnd: () {
                                          isTimeUp.value = true;
                                        },
                                        endWidget: Text(""),
                                        textStyle: TextStyle(
                                          fontSize: 0,
                                          fontFamily: "epr",
                                          fontWeight: FontWeight.w600,
                                          color: myprimarycolor,
                                        ),
                                      ),

                                      if(product.userTestSeries?.utsStatus == 1)
                                      CountdownTimer(
                                        endTime: DateFormat("yyyy-MM-dd HH:mm:ss")
                                        .parse(product.testAnnouncementDate ?? "")
                                        //     .parse("2025-06-19 17:46:00")
                                            .millisecondsSinceEpoch,
                                        onEnd: () {
                                          isResultTimeUp.value = true;
                                        },
                                        endWidget: Text(""),
                                        textStyle: TextStyle(
                                          fontSize: 0,
                                          fontFamily: "epr",
                                          fontWeight: FontWeight.w600,
                                          color: myprimarycolor,
                                        ),
                                      )

                                    ],
                                  ),
                                ),
                              ],
                            ),
                          if(product.testType == "1")
                            const SizedBox(height: 0,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(15, 7, 30, 3),
                                    decoration: BoxDecoration(
                                      color: product.testType == "1" ? myprimarycolor.withAlpha(15) : null,
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(200)
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        if(product.testType == "1")
                                        BlinkText(
                                          product.testTitle ?? "",
                                          beginColor: Theme.of(context).indicatorColor.withAlpha(40),
                                          endColor: Theme.of(context).indicatorColor,
                                          duration: Duration(milliseconds: 300),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                            fontSize: 15,
                                          ),
                                        ),
                                        if(product.testType != "1")
                                        Text(
                                          product.testTitle ?? '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                            fontSize: 13,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 5,),
                                        Text(
                                          "${product.testDuration} min | ${product.testTotalNoOfQues} que. | ${product.testTotalMarks} marks",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                              fontSize: 13,
                                              fontWeight: FontWeight.normal,
                                              color: Theme.of(context).hintColor
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 5,),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              if(product.testType == "1")
                              Obx((){
                                return Container(
                                  height: 30,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: product.userTestSeries?.utsStatus == 1 ?
                                      Border.all(color: isResultTimeUp.value ? Colors.green : Colors.grey.shade400, width: 1) :
                                      Border.all(color: isTimeUp.value ? myprimarycolor : Colors.grey.shade400, width: 1)
                                  ),
                                  child: product.userTestSeries?.utsStatus == 1 ?
                                  Text("Result",
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: isResultTimeUp.value ? Colors.green : Colors.grey.shade400, fontSize: 12, fontWeight: FontWeight.normal
                                    ),) :
                                  Text(
                                    product.userTestSeries?.utsStatus == 0 ? "Resume" : "Start",
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: isTimeUp.value ? myprimarycolor : Colors.grey.shade400, fontSize: 12, fontWeight: FontWeight.normal
                                    ),),
                                );
                              }),
                              if(product.testType == "0")
                              Container(
                                height: 30,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  // color: myprimarycolor,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: product.userTestSeries?.utsStatus != 1 ? myprimarycolor : Colors.green, width: 1)
                                ),
                                child: Text(product.userTestSeries?.utsStatus == 1 ? "Result" :
                                product.userTestSeries?.utsStatus == 0 ? "Resume" : "Start",
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: product.userTestSeries?.utsStatus != 1 ? myprimarycolor : Colors.green, fontSize: 12, fontWeight: FontWeight.normal
                                  ),),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            },
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
                  color: Theme.of(context).hintColor,
                  fontWeight: FontWeight.w300,
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
