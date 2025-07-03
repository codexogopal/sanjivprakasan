import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sanjivprkashan/controller/ExamController.dart';
import 'package:sanjivprkashan/model/forGetExam/GetSubjectWithQuestionsModel.dart';
import 'package:sanjivprkashan/theme/mythemcolor.dart';
import 'package:sanjivprkashan/ui/web/HtmlViewer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../model/forGetExam/GetQuestionOptionsModel.dart';
import '../../utils/styleUtil.dart';
import 'dialogs/MinuteCountUp.dart';
import 'dialogs/examUtils.dart';

class ExamScreen extends StatefulWidget {
  final testID;
  final testType;
  final courseId;

  const ExamScreen({super.key, required this.testID, required this.testType, required this.courseId});

  @override
  _ExamScreenState createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ExamController examCtrl = Get.put(ExamController());
  String _elapsedTime = "0 seconds";

  @override
  void initState() {
    examCtrl.testType.value = "${widget.testType}";
    examCtrl.testCourseId.value = "${widget.courseId}";
    super.initState();
    Timer(Duration(milliseconds: 150), () {
      examCtrl.getExamData(widget.testID, widget.courseId);
    });
  }
  @override
  void dispose() {
    examCtrl.timer?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final result = await exitExamDialog(context);
        return result == true;
      },
      child: SafeArea(
        child: Obx(() {
          final subjectList = examCtrl.subjects;
          if (examCtrl.isLoading.value) {
            return Center(child: apiLoader());
          }
          return Scaffold(
            key: _scaffoldKey,
            // drawer: _buildDrawer(),
            drawer: _buildDrawer(subjectList, (subjectIndex, questionIndex) {
              examCtrl.counters.value = questionIndex;
              examCtrl.getQByQIdAndTId(int.parse(widget.testID), questionIndex);
              Get.back();
            }),
            body: _buildBody(),
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            bottomNavigationBar: _buildBottomNavigation(),
          );
        }),
      ),
    );
  }


  Widget _buildDrawer(List<GetSubjectWithQuestionsModel> subjectList, void Function(int subjectIndex, int questionIndex)? onQuestionTap) {
    return Drawer(
      child: Container(
        width: 250,
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Column(
          children: [
            _buildLegend(),
            Divider(height: 1, thickness: 1, color: Colors.grey[300]),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: subjectList.asMap().entries.map((entry) {
                    int subjectIndex = entry.key;
                    GetSubjectWithQuestionsModel subject = entry.value;
                    return _buildSubjectSection(subject, subjectIndex, onQuestionTap);
                  }).toList(),
                ),
              ),
            ),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }


  Widget _buildLegend() {
    return Column(
      children: [
        SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              _buildLegendItem(Colors.green, "Answered"),
              _buildLegendItem(Colors.red, "Not Answered"),
            ],
          ),
        ),
        const SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              _buildLegendItem(Colors.purple, "Review"),
              _buildLegendItem(Colors.grey, "Not Visited"),
            ],
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Expanded(
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: 5),
          Text(text, style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.normal
          )
          ),
        ],
      ),
    );
  }


  Widget _buildSubjectSection(GetSubjectWithQuestionsModel subject, int subjectIndex, void Function(int subjectIndex, int questionIndex)? onQuestionTap) {
    return ExpansionTile(
      title: Text(
        subject.subjectName,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: subject.questions.asMap().entries.map((entry) {
              int questionIndex = entry.key;
              final data = entry.value;
              Color bgColor = (data.reviewStatus == 1 && data.ansStatus == 1) ? Colors.purple :
              data.ansStatus == 1 ? Colors.green :
              data.reviewStatus == 1 ? Colors.purple :
              data.visitStatus == 2 ? Colors.red : Colors.grey;
              return GestureDetector(
                onTap: () {
                  if (onQuestionTap != null) onQuestionTap(subject.subjectId, entry.value.testQuestion ?? 0);
                },
                child: _buildQuestionNumber(data.testQuestion ?? 0, color: bgColor),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _buildQuestionNumber(int number, {Color color = Colors.grey}) {
    return Container(
      height: 40,
      width: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(400),
      ),
      child: Text(
        number.toString(),
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        )
      ),
    );
  }


  Widget _buildSubmitButton() {
    return Container(
      color: Theme.of(context).colorScheme.secondaryContainer,
      padding: EdgeInsets.all(8),
      child: InkWell(
        onTap: (){
          if(widget.testType == "1"){
            examCtrl.createExamSubmitJson(int.parse(widget.testID), widget.testType);
          }else {
            examCtrl.getUserQueHistory(context, int.parse(widget.testID));
          }
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            widget.testType == "1" ? "View Report" : "Submit",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            expandedHeight: 140,
            floating: false,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: _buildHeader(),
            ),
          ),
        ];
      },
      body: _buildQuestionContent(),
    );
  }

  Widget _buildHeader() {
    return Obx(() {
      return Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.primaryContainer,
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                _buildPlayPauseButton(),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        examCtrl.testData.value?.testTitle ??
                            "Loading data Please wait...",
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            "Total Q. ${examCtrl.testData.value?.testTotalNoOfQues}",
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              color: Colors.blue,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 20,
                            color: Colors.grey[300],
                            margin: EdgeInsets.symmetric(horizontal: 10),
                          ),
                          if(examCtrl.testData.value?.examPauseTime != null)
                          examTimer(),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Image.asset("assets/images/open_menu.png"),
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                    examCtrl.loadSubjects(int.parse(widget.testID));
                  },
                ),
              ],
            ),
          ),
          Divider(height: 0.5, thickness:0.1, color: Theme.of(context).hintColor),
          _buildQuestionInfo(),
        ],
      );
    });
  }
  Widget examTimer() {
    return Obx(() {
      // Show loading indicator while initializing
      if (examCtrl.isLoading.value) {
        return const CircularProgressIndicator();
      }

      // Handle paused exam case
      if (widget.testType == "1") {
        double? remainingMinutes = double.tryParse(examCtrl.testData.value!.examPauseTime);
        if (remainingMinutes != null && remainingMinutes > 0) {
          int totalSeconds = (remainingMinutes * 60).round();
          int hours = totalSeconds ~/ 3600;
          int minutes = (totalSeconds % 3600) ~/ 60;
          int seconds = totalSeconds % 60;

          return Text(
            'Time: ${hours.toString().padLeft(2, '0')}:'
                '${minutes.toString().padLeft(2, '0')}:'
                '${seconds.toString().padLeft(2, '0')}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          );
        }
      }

      // Only start countdown if we have valid future end time
      if (examCtrl.examEndTime.value > DateTime.now().millisecondsSinceEpoch) {
        return CountdownTimer(
          endTime: examCtrl.examEndTime.value,
          onEnd: () => examCtrl.onExamTimeEnd(context, int.parse(widget.testID)),
          widgetBuilder: (_, time) {
            if (time == null) {
              // This will only happen when time actually ends
              examCtrl.onExamTimeEnd(context, int.parse(widget.testID));
              return const Text(
                'Time: 00:00:00',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              );
            }

            // Update remaining time (optional)
            double totalRemaining = (time.hours ?? 0) * 60 + (time.min ?? 0) + (time.sec ?? 0)/60;
            examCtrl.updateExamPauseTimeAndFetch(
              examCtrl.testData.value!.testId,
              double.parse(totalRemaining.toStringAsFixed(2)),
            );

            return Text(
              'Time: ${(time.hours ?? 0).toString().padLeft(2, '0')}:'
                  '${(time.min ?? 0).toString().padLeft(2, '0')}:'
                  '${(time.sec ?? 0).toString().padLeft(2, '0')}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            );
          },
        );
      } else {
        // If time is already over
        if (!examCtrl.isExamTimeOver.value) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            debugPrint("333333333333  ${examCtrl.testData.value?.examPauseTime ?? "gk"}");
            examCtrl.onExamTimeEnd(context, int.parse(widget.testID));
          });
        }
        return const Text(
          'Time: 00:00:00',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.purple,
          ),
        );
      }
    });
  }
  Widget examTimer1122() {
    return Obx(() {
      if (widget.testType == "1") {
        double? remainingMinutes = double.tryParse(examCtrl.testData.value!.examPauseTime);

        if (remainingMinutes != null) {
          // Convert total minutes into hours, minutes, seconds
          int totalSeconds = (remainingMinutes * 60).round();
          int hours = totalSeconds ~/ 3600;
          int minutes = (totalSeconds % 3600) ~/ 60;
          int seconds = totalSeconds % 60;

          // Format as HH:MM:SS
          String h = hours.toString().padLeft(2, '0');
          String m = minutes.toString().padLeft(2, '0');
          String s = seconds.toString().padLeft(2, '0');

          return Text(
            'Time: $h:$m:$s',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          );
        }
      }

      // Only show countdown if examEndTime is in the future
      if (examCtrl.examEndTime.value > DateTime.now().millisecondsSinceEpoch) {
        return CountdownTimer(
          endTime: examCtrl.examEndTime.value,
          onEnd: () {
            examCtrl.onExamTimeEnd(context, int.parse(widget.testID));
          },
          widgetBuilder: (_, time) {
            if (time == null) {
              return const Text(
                'Time: 00:00:00',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              );
            }

            // Update examPauseTime while the timer runs (optional)
            double totalRemainingMinutes = (time.hours ?? 0) * 60 + (time.min ?? 0) + (time.sec ?? 0) / 60;
            examCtrl.updateExamPauseTimeAndFetch(
              examCtrl.testData.value!.testId,
              double.parse(totalRemainingMinutes.toStringAsFixed(2)),
            );

            String h = (time.hours ?? 0).toString().padLeft(2, '0');
            String m = (time.min ?? 0).toString().padLeft(2, '0');
            String s = (time.sec ?? 0).toString().padLeft(2, '0');

            return Text(
              'Time: $h:$m:$s',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            );
          },
        );
      } else {
        // If time is already over, show 00:00:00 and call onExamTimeEnd if not already called
        if (!examCtrl.isExamTimeOver.value) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            examCtrl.onExamTimeEnd(context, int.parse(widget.testID));
          });
        }
        return const Text(
          'Time: 00:00:00',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.purple,
          ),
        );
      }
    });
  }
  Widget examTimer11() {
    return Obx(() {
      if (widget.testType == "1") {
        double? remainingMinutes = double.tryParse(examCtrl.testData.value!.examPauseTime);

        if (remainingMinutes != null) {
          // Convert total minutes into hours, minutes, seconds
          int totalSeconds = (remainingMinutes * 60).round();
          int hours = totalSeconds ~/ 3600;
          int minutes = (totalSeconds % 3600) ~/ 60;
          int seconds = totalSeconds % 60;

          // Format as HH:MM:SS
          String h = hours.toString().padLeft(2, '0');
          String m = minutes.toString().padLeft(2, '0');
          String s = seconds.toString().padLeft(2, '0');

          return Text(
            'Time: $h:$m:$s',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          );
        }
      }

      // Otherwise, show the live countdown
      return CountdownTimer(
        endTime: examCtrl.examEndTime.value,
        onEnd: (){
          examCtrl.onExamTimeEnd(context, int.parse(widget.testID));
          },
        widgetBuilder: (_, time) {
          if (time == null) {
            return const Text(
              'Time: 00:00:00',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            );
          }

          // Update examPauseTime while the timer runs (optional)
          double totalRemainingMinutes = (time.hours ?? 0) * 60 + (time.min ?? 0) + (time.sec ?? 0) / 60;
          examCtrl.updateExamPauseTimeAndFetch(
            examCtrl.testData.value!.testId,
            double.parse(totalRemainingMinutes.toStringAsFixed(2)),
          );

          String h = (time.hours ?? 0).toString().padLeft(2, '0');
          String m = (time.min ?? 0).toString().padLeft(2, '0');
          String s = (time.sec ?? 0).toString().padLeft(2, '0');

          return Text(
            'Time: $h:$m:$s',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          );
        },
      );
    });
  }
  Widget examTimer123() {
    return Obx(() {
      return CountdownTimer(
        endTime: examCtrl.examEndTime.value,
        onEnd: () {
          examCtrl.onExamTimeEnd(context, int.parse(widget.testID));
        },
        widgetBuilder: (_, time) {
          if (time == null) {
            return const Text(
              'Time: 00:00:00',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            );
          }
          int hours = time.hours ?? 0;
          int minutes = time.min ?? 0;
          int seconds = time.sec ?? 0;

          // ⏱️ Update remainingMinutes as decimal
          double totalRemainingMinutes = (hours * 60) + minutes + (seconds / 60);
          double mtime = double.parse(totalRemainingMinutes.toStringAsFixed(2));
          // debugPrint("mTimeris: $mtime");
          examCtrl.updateExamPauseTimeAndFetch(examCtrl.testData.value!.testId, mtime);
          String h = hours.toString().padLeft(2, '0');
          String m = minutes.toString().padLeft(2, '0');
          String s = seconds.toString().padLeft(2, '0');
          return Text(
            'Time: $h:$m:$s',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          );
        },
      );
    });
  }
  Widget _buildPlayPauseButton() {
    return GestureDetector(
      onTap: () {
        exitExamDialog(context);
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Icon(Icons.pause, size: 25, color: Colors.white)
      ),
    );
  }

  Widget _buildQuestionInfo() {
    return Material(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Obx((){
       return Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildQuestionNumberCard(),
              Container(width: 1, height: 20, color: Colors.grey[300]),
              /*MinuteCountUp(
                initialSeconds: 0,
                onTick: (seconds) {
                  print("Current seconds: $seconds");
                  examCtrl.saveSpendTimer(int.parse(widget.testID), examCtrl.counters.value, seconds);
                  // You can do something with the value
                },
              ),*/
              Text(
                '${examCtrl.minutes.toString().padLeft(2, '0')}:${examCtrl.seconds.toString().padLeft(2, '0')} Mint' ?? "00:00 Mint",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.purple, fontSize: 12
                  ),
              ),
              Container(width: 1, height: 20, color: Colors.grey[300]),
              _buildMarksCard("+${examCtrl.testData.value?.testMarksPerQuestion ?? 0}", Color(0xFFDCFBDC)),
              _buildMarksCard("-${examCtrl.testData.value?.testNegativeMarking ?? 0}", Color(0xFFF8D5D5)),

              Row(
                children: [
                  _buildLanguageButton(),
                  _buildReviewButton(),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildQuestionNumberCard() {
    return Container(
      height: 25,
      width: 25,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(150),
        color: Colors.grey[200],
      ),
      child: Obx((){
        return Text(
          examCtrl.tQData.value?.testQuestion.toString() ?? "0",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        );
      })
    );
  }

  Widget _buildMarksCard(String text, Color color) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      color: color,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageButton() {
    return IconButton(
        icon: Image.asset("assets/images/translate.png", height: 22, color: myprimarycolor,),
        onPressed: () {
      showLanguageBottomSheet();
    });
  }

  Widget _buildReviewButton() {
    return Obx(
      () {
        return InkWell(
          onTap: () {
            if(widget.testType == "1"){

            }else{
              int status  = examCtrl.tQData.value?.reviewStatus ?? 0;
              status = status == 1 ? 0 : 1;
              examCtrl.addToReview(int.parse(widget.testID), examCtrl.tQData.value?.testQuestion ?? 0, status);
            }

          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              children: [
                Icon(
                  Icons.check,
                  size: 15,
                  color: examCtrl.isReview.value == 1 ? Colors.amber : Colors.blue,
                ),
                SizedBox(width: 8),
                Text(
                  "Review",
                  style: TextStyle(
                    color: examCtrl.isReview.value == 1 ? Colors.amber : Colors.blue,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )
        );
      }
    );
  }

  Widget _buildQuestionContent() {
    final question = examCtrl.tQData;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Obx(() => ListView(
        physics: const NeverScrollableScrollPhysics(), // Disable scrolling
        shrinkWrap: true, // Only take needed height
        children: [
          _buildQuestionCard(),
          const SizedBox(height: 10),


          if(question.value?.type == 3)
            _buildMatchTheFollowingOptions(),

          if(question.value?.type != 3)
          ...List.generate(examCtrl.tQOptionData.length, (index) {
            final option = examCtrl.tQOptionData[index];
            String showOptions = (question.value?.type == 1 ? String.fromCharCode(65 + index) : option.qoOptions) ?? "NA";
            String ansOptions = option.qoOptions ?? "1";
            return Column(
              children: [
                InkWell(
                  onTap: (){
                    if(widget.testType != "1") {
                      int status = option.qoIsSelectedOrNot ?? 0;
                      status = status == 1 ? 0 : 1;
                      ansOptions =
                      ansOptions == examCtrl.tQData.value?.selectedAns
                          ? "1"
                          : ansOptions;
                      if (examCtrl.tQData.value?.type == 0 ||
                          examCtrl.tQData.value?.type == 1) {
                        examCtrl.saveAnswers(int.parse(widget.testID),
                            examCtrl.tQData.value?.testQuestion ?? 0, status,
                            ansOptions);
                      } else if (examCtrl.tQData.value?.type == 2) {
                        examCtrl.saveAnswersMultiSelect(
                            int.parse(widget.testID),
                            examCtrl.tQData.value?.testQuestion ?? 0, status,
                            ansOptions);
                      }
                    }
                  },
                  child: _buildOption(
                      showOptions,
                      (examCtrl.examLang.value == "2" ?
                      (question.value?.type != 1 ? (option.hindiQoText == "" ? option.qoText : option.hindiQoText) : option.qoOptions) :
                      (question.value?.type != 1 ? option.qoText : option.qoOptions))
                          ??  ((question.value?.type != 1 ? option.qoText : option.qoOptions) ?? ""),
                      option.qoIsSelectedOrNot ?? 0
                  ),
                ),
                const SizedBox(height: 10),
              ],
            );
          }),

          const SizedBox(height: 0),
          if(widget.testType == "1" && examCtrl.tQData.value?.type != 3)
            _buildCorrectAnsCard(),
          if(widget.testType == "1" && examCtrl.tQData.value?.type == 3)
            _buildCorrectAnsCardMatch(),
          const SizedBox(height: 20),
          if(widget.testType == "1")
          _buildSolutionCard(),
        ],
      )),
    );
  }

  Widget _buildMatchTheFollowingOptions(){
    final question = examCtrl.tQData;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Obx(() => ListView(
        physics: const NeverScrollableScrollPhysics(), // Disable scrolling
        shrinkWrap: true, // Only take needed height
        children: [
            ...List.generate(examCtrl.tQOptionData.length, (index) {
              final option = examCtrl.tQOptionData[index];
              String showOptions = (question.value?.type == 1 ? String.fromCharCode(65 + index) : option.qoOptionsSec) ?? "NA";
              String ansOptions = option.qoOptionsSec ?? "1";
              return Column(
                children: [
                  _buildOptionForMatch(
                      showOptions,
                      (examCtrl.examLang.value == "2" ? (question.value?.type != 1 ? (option.hindiQoTextSec == "" ? option.qoTextSec : option.hindiQoTextSec) : option.qoOptionsSec)
                          : (question.value?.type != 1 ? option.qoTextSec : option.qoOptionsSec))
                          ??  ((question.value?.type != 1 ? option.qoTextSec : option.qoOptionsSec) ?? ""),
                      option.qoIsSelectedOrNot ?? 0, examCtrl.tQOptionData, "l1"
                  ),
                  const SizedBox(height: 10),
                ],
              );
            }),
          const SizedBox(height: 20),

          // Dynamically build options from list
          ...List.generate(examCtrl.tQOptionData.length, (index) {
            final option = examCtrl.tQOptionData[index];
            String showOptions = (question.value?.type == 1 ? String.fromCharCode(65 + index) : option.qoOptions) ?? "NA";
            String ansOptions = option.qoOptions ?? "1";
            return Column(
              children: [
                InkWell(
                  onTap: (){
                    int status  = option.qoIsSelectedOrNot ?? 0;
                    status = status == 1 ? 0 : 1;
                    ansOptions = ansOptions ==  examCtrl.tQData.value?.selectedAns ? "1" : ansOptions;
                    if(examCtrl.tQData.value?.type == 0 || examCtrl.tQData.value?.type == 1){
                      examCtrl.saveAnswers(int.parse(widget.testID), examCtrl.tQData.value?.testQuestion ?? 0, status, ansOptions);
                    }else if(examCtrl.tQData.value?.type == 2){
                      examCtrl.saveAnswersMultiSelect(int.parse(widget.testID), examCtrl.tQData.value?.testQuestion ?? 0, status, ansOptions);
                    }
                  },
                  child: _buildOptionForMatch(
                      showOptions, // Converts 0 to 'A', 1 to 'B', etc.
                      // (question.value?.type != 1 ? option.qoText : option.qoOptions) ?? 'No Option Text',
                      (examCtrl.examLang.value == "2" ? (question.value?.type != 1 ? (option.hindiQoText == "" ? option.qoText : option.hindiQoText) : option.qoOptions)
                          : (question.value?.type != 1 ? option.qoText : option.qoOptions))
                          ??  ((question.value?.type != 1 ? option.qoText : option.qoOptions) ?? ""),
                      option.qoIsSelectedOrNot ?? 0, examCtrl.tQOptionData, "l2", userAns: option.qoSelectedAns
                  ),
                ),
                const SizedBox(height: 10),
              ],
            );
          }),
        ],
      )),
    );
  }


  Widget _buildQuestionCard() {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Theme.of(context).colorScheme.primaryContainer,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Question",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).hintColor,
                  fontSize: 14,
                    fontWeight: FontWeight.normal
                ),
              ),
              SizedBox(height: 10),
              htmlViewer(
                ((examCtrl.examLang.value == "2" && examCtrl.tQData.value?.questionHindi != "") ? examCtrl.tQData.value?.questionHindi : examCtrl.tQData.value?.questionEng) ??  (examCtrl.tQData.value?.questionEng ?? ""),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(String letter, String text, int optSelected) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Card(
          elevation: 0,
          color: (optSelected == 1 && widget.testType == "1") ? Colors.purple.shade100 :
          (optSelected == 1 && widget.testType != "1") ? Colors.green.shade100 :
          Theme.of(context).colorScheme.primaryContainer,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Row(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: (optSelected == 1 && widget.testType == "1") ? Colors.purple :
                    (optSelected == 1 && widget.testType != "1") ? Colors.green :
                    Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      letter,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      )
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: HtmlWidget(text,
                    textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.normal,
                      color: (optSelected == 1 && isDarkTheme) ? Colors.black : null,
                    ),
                  )
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionMatchTheFollowing(String letter, String optSelected) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    // debugPrint("hihiii $letter   $optSelected");
    return Card(
      elevation: 0,
      color: (optSelected == letter && widget.testType != "1") ? Colors.green.shade100 :
      (optSelected == letter && widget.testType == "1") ? Colors.purple.shade100 :
      Theme.of(context).colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: (optSelected == letter && widget.testType != "1") ? Colors.green :
            (optSelected == letter && widget.testType == "1") ? Colors.purple : Colors.grey,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              letter,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              )
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionForMatch(
      String letter,
      String text,
      int optSelected,
      List<GetQuestionOptionsModel> mOList,
      String lType,
  {String? userAns}
      ) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.primaryContainer,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Row(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: lType == 'l1' ? Colors.brown.shade400 : Colors.blueGrey, /*optSelected == 1 ? Colors.green : Colors.grey,*/
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      letter,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      )
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: HtmlWidget(text,
                    textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.normal,
                      // color: (optSelected == 1 && isDarkTheme) ? Colors.black : null,
                    ),
                  )
                ),
              ],
            ),
          ),
        ),
        if(lType == "l2")
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(mOList.length, (index) {
              final option = mOList[index];
              String showOptions = option.qoOptionsSec ?? "NA";
              String ansOptions = option.qoOptionsSec ?? "1";
              return Padding(
                padding: const EdgeInsets.only(right: 10), // spacing between options
                child: InkWell(
                  onTap: () {
                    if(widget.testType != "1") {
                      int status = option.qoIsSelectedOrNot ?? 0;
                      status = 1;
                      ansOptions = option.qoOptionsSec ?? "1";
                      examCtrl.saveAnswersForMatchTheFo(int.parse(
                          widget.testID), examCtrl.tQData.value?.testQuestion ??
                          0, letter, status, ansOptions);
                    }
                  },
                  child: _buildOptionMatchTheFollowing(
                    showOptions,
                    userAns ?? "1",
                  ),
                ),
              );
            }),
          ),
        )

      ],
    );
  }

  Widget _buildCorrectAnsCardMatch() {

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Correct Answer:-",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).hintColor
              )
            ),
            SizedBox(height: 20),

            ...List.generate(examCtrl.tQOptionData.length, (index) {
              final option = examCtrl.tQOptionData[index];
              String showOptions = option.qoOptions ?? "NA";
              String ansOptions = option.qoCorrectAns ?? "1";
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(showOptions,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Image.asset("assets/images/arrows.png", width: 100, height: 10, color: Theme.of(context).hintColor,),
                      const SizedBox(width: 10),
                      Text(ansOptions,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.green.shade600
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCorrectAnsCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Correct Answer:-",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).hintColor
              )
            ),
            SizedBox(width: 10),
            Text(examCtrl.tQData.value?.questionCorrectAns?.replaceAll("##", ", ") ?? "",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.green.shade600
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSolutionCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Solution",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              )
            ),
            SizedBox(height: 10),
            htmlViewer(
              ((examCtrl.examLang.value == "2" && examCtrl.tQData.value?.questionHindiSolution != "") ? examCtrl.tQData.value?.questionHindiSolution :
              examCtrl.tQData.value?.questionEngSolution) ??  (examCtrl.tQData.value?.questionEngSolution ?? "No Solution available for this question!"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      padding: EdgeInsets.all(15),
      child: Row(
        children: [
          if(widget.testType != "1")
          _buildClearButton(),
          Spacer(),
          _buildPreviousButton(),
          SizedBox(width: 10),
          _buildNextButton(),
        ],
      ),
    );
  }

  Widget _buildClearButton() {
    return OutlinedButton(
      onPressed: () {
        if(widget.testType != "1") {
          examCtrl.clearAnswerForQuestion(int.parse(widget.testID),
              examCtrl.tQData.value?.testQuestion ?? 0);
        }
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Theme.of(context).indicatorColor),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      ),
      child: Text("Clear", style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.normal
      ),),
    );
  }

  Widget _buildPreviousButton() {
    return InkWell(
      onTap: (){
        if(examCtrl.counters.value == 1){

        }else {
          examCtrl.counters = examCtrl.counters - 1;
          examCtrl.getQByQIdAndTId(int.parse(widget.testID), examCtrl.counters.value);
        }
      },
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.secondaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(
            "Previous",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.normal
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    bool isTestEnding = examCtrl.getQuestionsLength.length == examCtrl.counters.value;
    return InkWell(
      onTap: (){
        if(examCtrl.getQuestionsLength.length == examCtrl.counters.value){
          if(widget.testType == "1"){
            examCtrl.createExamSubmitJson(int.parse(widget.testID),  widget.testType);
          }else {
            examCtrl.getUserQueHistory(context, int.parse(widget.testID));
          }
        }else {
          examCtrl.counters = examCtrl.counters + 1;
          examCtrl.getQByQIdAndTId(int.parse(widget.testID), examCtrl.counters.value);
        }
      },
      child: Card(
        elevation: 0,
        color: Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: widget.testType == "1" ? 25 : 10, vertical: 10),
          child: widget.testType == "1" ? Text(
            isTestEnding ? "View Report" : "Next",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ) : Text(
            isTestEnding ? "Ready to Submit" : "Save & Next",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
    );
  }

  Widget htmlViewer(String value){
    return HtmlWidget(value,
      textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.normal,
      ),
    );
  }



  Widget htmlViewer1(String value){
    return HtmlViewer(
      htmlContent: value,
      height: 300,
    );
  }


  void showLanguageBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0), // Same as @dimen/dimen_20dp
          child: Obx((){
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                Text(
                  'Select Language',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    examCtrl.setExamLanguage(int.parse(widget.testID), 1);
                    goBack();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 15, right: 10, bottom: 10),
                    child: Text(
                      'English',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        color: examCtrl.examLang.value == "1" ? myprimarycolor : null,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    examCtrl.setExamLanguage(int.parse(widget.testID), 2);
                    goBack();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 15, right: 10, bottom: 10),
                    child: Text(
                      'Hindi',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        color: examCtrl.examLang.value == "2" ? myprimarycolor : null,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    goBack();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 15, right: 10, bottom: 10),
                    child: Text(
                      'Cancel',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.normal,
                          fontSize: 16
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        );
      },
    );
  }

  void goBack(){
    Timer(Duration(milliseconds: 150),(){
      Navigator.pop(context);
    });
  }

}



class HtmlWebViewScreen extends StatefulWidget {
  final String htmlContent;

  const HtmlWebViewScreen({Key? key, required this.htmlContent}) : super(key: key);

  @override
  State<HtmlWebViewScreen> createState() => _HtmlWebViewScreenState();
}

class _HtmlWebViewScreenState extends State<HtmlWebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..loadHtmlString(
        '''
        <!DOCTYPE html>
        <html>
          <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
          </head>
          <body>
            ${widget.htmlContent}
          </body>
        </html>
        ''',
        baseUrl: 'https://studykee.com', // Helps load external images
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("HTML WebView")),
      body: WebViewWidget(controller: _controller),
    );
  }
}
