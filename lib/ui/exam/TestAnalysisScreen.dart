import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../controller/ExamController.dart';
import '../../controller/HomeController.dart';
import '../../utils/styleUtil.dart';
import 'dialogs/examUtils.dart';


class TestAnalysisScreen extends StatefulWidget {
  final testID;
  const TestAnalysisScreen({super.key, required this.testID});

  @override
  _TestAnalysisScreen createState() => _TestAnalysisScreen();
}

class _TestAnalysisScreen extends State<TestAnalysisScreen> {
  final screenshotController = ScreenshotController();

  late final ExamController examCtrl;

  final HomeController homeCtrl = Get.put(HomeController());
  @override
  void initState() {
    examCtrl = Get.find<ExamController>();
    Timer(Duration(milliseconds: 150), (){
      examCtrl.getExamResultData(widget.testID);
    });
    super.initState();
  }


  Future<void> _captureAndShare() async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Capture the widget
      final imageBytes = await screenshotController.capture();
      if (imageBytes == null) return;

      // Get temporary directory
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/screenshot.png').create();
      await file.writeAsBytes(imageBytes);

      // Share directly without saving to gallery
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Check this out!', // Optional message
        subject: 'Screenshot from My App', // Optional subject
      );

      // Close loading dialog
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading if still open
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer, // bg color
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              elevation: 7,
              pinned: true,
              floating: true,
              titleSpacing: 0,
              leading: InkWell(onTap: (){Get.back();},child: Icon(Icons.arrow_back, color: Theme.of(context).indicatorColor,)),
              title: Text(
                'Test Analysis',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 16,
                ),
              ),
              actions: [
                TextButton(
                  child: Text(
                    'SOLUTION',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 14,
                    ),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ],
            ),
          ];
        },
        body: Obx((){
          if (examCtrl.isLoading.value) {
            return Center(child: apiLoader());
          }
          return SingleChildScrollView(
            child: Screenshot(
              controller: screenshotController,
              child: Container(
                color: Theme.of(context).colorScheme.secondaryContainer,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    _buildTestInfoCard(),
                    SizedBox(height: 10),
                    _buildTestUserInfoCard(),
                    SizedBox(height: 10),
                    _buildScoreCard(),
                    SizedBox(height: 10),
                    _buildLegendCard(),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTestInfoCard() {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    examCtrl.testData.value?.testTitle ?? "",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${examCtrl.testData.value?.testTotalNoOfQues ?? 0} Ques • ${examCtrl.testData.value?.testDuration ?? "0"} Min',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).hintColor,
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestUserInfoCard() {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    homeCtrl.userData.value?.userFname ?? "",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }




  Widget _buildScoreCard() {
    final spentTime = (getSpentTimeInMinutes(examCtrl.testData.value?.testDuration ?? "0", examCtrl.testData.value?.examPauseTime ?? "0")/examCtrl.rTotalAnswered.value).toStringAsFixed(2);
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          // Score and Rank Row
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        Image.asset("assets/images/star-badge.png", width: 50,),
                        SizedBox(height: 4),
                        Text(
                          'Rank',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 12,
                        ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${examCtrl.ranking.value}/${examCtrl.outOfRanking.value}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(height: 1, color: Theme.of(context).hintColor.withAlpha(30)),
          // Score and Rank Row
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 30),
                        SizedBox(height: 4),
                        Text(
                          'Scored',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${examCtrl.rTotalObtainedMarks.value - examCtrl.rTotalNegativeMarks.value ?? 0}/${examCtrl.testData.value?.testTotalMarks ?? 0}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: 0.5,
                height: 80,
                color:  Theme.of(context).hintColor.withAlpha(30)
              ),
              Expanded(
                child: InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        // Icon(Icons.leaderboard, color: Colors.amber, size: 30),
                        Icon(Icons.cancel, color: Colors.red, size: 30),
                        SizedBox(height: 4),
                        Text(
                          'Negative',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${examCtrl.rTotalNegativeMarks.value ?? "0"}/${examCtrl.rTotalObtainedMarks.value ?? 0}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(height: 1, color: Theme.of(context).hintColor.withAlpha(30)),

          // Stats Row 1
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Image.asset("assets/images/dart.png", color: Colors.amber, height: 20,),
                      // Icon(Icons.trending_up, color: Colors.amber, size: 20),
                      SizedBox(height: 5),
                      Text(
                        'Accuracy',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        calculateAccuracy(examCtrl.rTotalCorrect.value, examCtrl.rTotalWrong.value).toStringAsFixed(2),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: 5),
                      Visibility(
                        visible: false,
                        child: Text(
                          'Question',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                    width: 0.5,
                    height: 80,
                    color:  Theme.of(context).hintColor.withAlpha(30)
                ),
                Expanded(
                  child: Column(
                    children: [
                      Image.asset("assets/images/effort.png", color: Colors.green, height: 20,),
                      SizedBox(height: 5),
                      Text(
                        'Attempt',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '${examCtrl.rTotalAnswered}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Visibility(
                        visible: false,
                        child: Text(
                          'Question',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                    width: 0.5,
                    height: 80,
                    color:  Theme.of(context).hintColor.withAlpha(30)
                ),
                Expanded(
                  child: Column(
                    children: [
                      Image.asset("assets/images/threshold.png", color: Colors.blue, height: 20,),
                      SizedBox(height: 5),
                      Text(
                        'Avg. T/Q',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "$spentTime Min",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Visibility(
                        visible: false,
                        child: Text(
                          'Question',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontFamily: 'sans-serif',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color:  Theme.of(context).hintColor.withAlpha(30)),

          // Stats Row 2
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 20),
                      SizedBox(height: 5),
                      Text(
                        'Correct',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontFamily: 'sans-serif',
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "${examCtrl.rTotalCorrect.value}",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Question',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    width: 0.5,
                    height: 80,
                    color:  Theme.of(context).hintColor.withAlpha(30)
                ),
                Expanded(
                  child: Column(
                    children: [
                      Icon(Icons.cancel, color: Colors.red, size: 20),
                      SizedBox(height: 5),
                      Text(
                        'Wrong',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontFamily: 'sans-serif',
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "${examCtrl.rTotalWrong.value}",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Question',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    width: 0.5,
                    height: 80,
                    color:  Theme.of(context).hintColor.withAlpha(30)
                ),
                Expanded(
                  child: Column(
                    children: [
                      Image.asset("assets/images/skipped2.png", color: Colors.grey, height: 20,),
                      SizedBox(height: 5),
                      Text(
                        'Unanswered',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "${examCtrl.rTotalUnAns.value}",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Question',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color:  Theme.of(context).hintColor.withAlpha(30)),

          // Test Analysis Text
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              'Subject wise analysis',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFFD5252),
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ),
              /*Map<String, dynamic> subDataMap = {
              "sub_tc": 0,  // subject total correct
              "sub_tw": 0,  // subject total wrong
              "sub_ts": 0,  // subject total skipped
              "sub_trm": 0, // subject total review marked
              "sub_tans": 0, // subject total answered
              "sub_tunans": 0, // subject total unanswered
              "sub_tom": 0.0, // subject total obtained marks
              "sub_top": 0.0, // subject total obtained percentage
              "sub_tnm": 0.0, // subject total negative marks
              "sub_name": "",
              };*/

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Text("Subject",
                    style: TextStyle(
                      fontSize: 13,
                    ),),
                ),

                Expanded(
                  flex: 1,
                  child: Text("C. Q.",
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.green
                    ),),
                ),

                Expanded(
                  flex: 1,
                  child: Text(
                      "Ob. M",
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.green
                    ),),
                ),

                Expanded(
                  flex: 1,
                  child: Text(
                      "W. Q.",
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.red
                    ),),
                ),

                Expanded(
                  flex: 0,
                  child: Text(
                      "Neg. M",
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.red
                    ),),
                ),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Divider(height: 1, color:  Theme.of(context).hintColor.withAlpha(30)),
          SizedBox(height: 10,),
          ...List.generate(examCtrl.subjectWiseResult.length, (index) {
            final option = examCtrl.subjectWiseResult[index];

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          option["sub_name"],
                          style: TextStyle(
                            fontSize: 13,
                          ),),
                      ),

                      Expanded(
                        flex: 1,
                        child: Text(
                          option["sub_tc"].toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.green
                          ),),
                      ),

                      Expanded(
                        flex: 1,
                        child: Text(
                          option["sub_tom"].toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.green
                          ),),
                      ),

                      Expanded(
                        flex: 1,
                        child: Text(
                          option["sub_tw"].toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.red
                          ),),
                      ),

                      Expanded(
                        flex: 1,
                        child: Text(
                          option["sub_tnm"].toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.red
                          ),),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Divider(height: 1, color:  Theme.of(context).hintColor.withAlpha(30)),
                SizedBox(height: 10,),
              ],
            );
          }),

          // Hidden topic result section
          Visibility(
            visible: false,
            child: Column(
              children: [
                Divider(height: 1, color: Color(0xFFF5F5F5)),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Table(
                    border: TableBorder.all(color: Colors.grey[300]!),
                    children: [
                      TableRow(
                        decoration: BoxDecoration(color: Color(0xFFE4E4E4)),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text('No.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text('Subject', textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(Icons.check, color: Colors.green, size: 15),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(Icons.close, color: Colors.red, size: 15),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(Icons.next_plan, color: Colors.grey, size: 15),
                          ),
                        ],
                      ),
                      TableRow(
                        decoration: BoxDecoration(color: Color(0xFFF0F7F7)),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text('1', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text('Math', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text('5', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text('2', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text('3', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color:  Theme.of(context).hintColor.withAlpha(30)),
          Divider(height: 1, color: Color(0xFFF5F5F5)),

          // Buttons Row
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Visibility(
                  visible: false,
                  child: Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        textStyle: TextStyle(color: Colors.white),
                      ),
                      child: Text('Reattempt'),
                    ),
                  ),
                ),
                Visibility(
                  visible: false,
                  child: SizedBox(width: 5),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _captureAndShare();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.purple, backgroundColor: Colors.white,
                      elevation: 0,
                    ),
                    child: Text('Share Scorecard'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildLegendCard() {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: 20, top: 20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 30),
                      SizedBox(height: 4),
                      Text(
                        'Correct',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Icon(Icons.check_circle, color: Colors.amber, size: 30),
                      SizedBox(height: 4),
                      Text(
                        'Unanswered',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Icon(Icons.check_circle, color: Colors.red, size: 30),
                      SizedBox(height: 4),
                      Text(
                        'Wronged',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            piCart(),
          ],
        ),
      ),
    );
  }
}