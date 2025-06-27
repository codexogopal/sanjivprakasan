import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sanjivprkashan/db/DatabaseHelper.dart';
import 'package:sanjivprkashan/model/forGetExam/GetQuestionOptionsModel.dart';
import 'package:sanjivprkashan/model/forSetExam/CsQuestions.dart';
import 'package:sanjivprkashan/model/forSetExam/CsSubjects.dart';
import 'package:sanjivprkashan/theme/mythemcolor.dart';
import 'package:get/get.dart';
import 'package:sanjivprkashan/ui/exam/TestAnalysisScreen.dart';
import '../../../controller/ExamController.dart';
import '../../../model/forGetExam/GetSubjectWithQuestionsModel.dart';
import '../../../model/forGetExam/GetTestDataById.dart';
import '../../../model/forGetExam/GetTestQuestionByTidQidModel.dart';
import '../../../model/forSetExam/CsTestSubjectDetails.dart';
import '../../../utils/styleUtil.dart';
import 'ExamSubmissionDialog.dart';


final ExamController examCtrl = Get.put(ExamController());

// Usage (same as your original):
void showSubmitTestDialog(BuildContext context, int testId, String testType) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return ExamSubmissionDialog(
        testId: testId,
        testType: testType,
        examCtrl: Get.find<ExamController>(),
        buttonLoader: buttonLoader, // Your loader widget function
      );
    },
  );
}


Widget _buildCard({
  required BuildContext context,
  required String icon,
  required String label,
  required String count,
  required Color labelColor,
  required Color countColor,
}) {
  return Expanded(
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Image.asset(
              icon,
              width: label == "Skipped" ? 25 : 20,
              height: label == "Skipped" ? 25 : 20,
              color: countColor,
            ),
            const SizedBox(height: 5),
            Text(label, style: TextStyle(color: labelColor, fontSize: 12)),
            Text(
              count,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: countColor,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            Text(
              'Question',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


Future<bool?> exitExamDialog(BuildContext context){
  final ExamController examCtrl = Get.put(ExamController());
  return showDialog(
      context: context,
      builder: (BuildContext context)
      {
        return AlertDialog(
          title: Text('Do you really want to Exit?',style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.normal
          ),),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No',
                style: TextStyle(color: myprimarycolor, fontSize: 16),),
            ),
            TextButton(
              onPressed: () {
                examCtrl.timer?.cancel();
                // examCtrl.dbService.deleteDatabaseFile();
                Get.back();
                Get.back();
              },
              child: const Text('Yes',
                style: TextStyle(color: myprimarycolor,  fontSize: 16),),
            ),
          ],
        );
      }
  );
}


Future<Map> createExamSubmitJson123(int testId) async {
  Map mainMap = {};
  Map utsdMap = {};
  Map subDataMap = {};
  final DatabaseHelper dbService = DatabaseHelper();
  final result = await dbService.getTestById(testId);
  final utsByTestId = await dbService.getUserTestSeriesByTestId(testId);
  if(result!.isNotEmpty){
  final td = GetTestDataById.fromMap(result);

  List<GetSubjectWithQuestionsModel> sj = [];
  List<Map<String, dynamic>> sbj = [];
  final sResult = await dbService.getSubjectForResult(testId);

  examCtrl.rTotalCorrect.value = 0;
  examCtrl.rTotalWrong.value = 0;
  examCtrl.rTotalSkipped.value = 0;
  examCtrl.rTotalReviewMarked.value = 0;
  examCtrl.rTotalAnswered.value = 0;
  examCtrl.rTotalUnAns.value = 0;
  examCtrl.rTotalObtainedMarks.value = 0.0;
  examCtrl.rTotalObtainedPercentage.value = 0.0;
  examCtrl.rTotalNegativeMarks.value = 0.0;

  int sTotalCorrect = 0;
  int sTotalWrong = 0;
  int sTotalSkipped = 0;
  int sTotalReviewMarked = 0;
  int sTotalAnswered = 0;
  int sTotalUnAns = 0;
  double sTotalObtainedMarks = 0.0;
  double sTotalObtainedPercentage = 0.0;
  double sTotalNegativeMarks = 0.0;
  examCtrl.subjectWiseResult.clear();

  mainMap.addAll({
    "test_id": td.testId,
    "test_type": td.testType,
    "test_type_name": td.testTypeName,
    "test_exam_type": td.testExamType,
    "test_category_id": td.testCategoryId,
    "test_quiz_category_id": td.testQuizCategoryId,
    "text_lang": td.textLang,
    "test_title": td.testTitle,
    "test_course": td.testCourse,
    "test_description": td.testDescription,
    "test_total_no_of_ques": td.testTotalNoOfQues,
    "test_pause_on_que_num": td.testPauseOnQueNum,
    "test_total_marks": td.testTotalMarks,
    "test_duration": td.testDuration,
    "test_time": td.testTime,
    "test_schedule_date": td.testScheduleDate,
    "test_announcement_date": td.testAnnouncementDate,
    "test_negative_marking": td.testNegativeMarking,
    "test_paperpdf": td.testPaperPdf,
    "test_solution": td.testSolution,
    "test_image": td.testImage,
    "test_marks_perquestion": td.testMarksPerQuestion,
    "test_attempt_count": td.testAttemptCount,
    "test_status": td.testStatus,
    "exam_pause_time": td.examPauseTime,
    "test_meta_title": td.testMetaTitle,
    "test_meta_keyword":  td.testMetaKeyword,
    "test_meta_desc": td.testMetaDesc,
    "created_at": td.createdAt,
    "updated_at": td.updatedAt,
    "deleted_at": td.deletedAt,
    "has_many_cs_test_subject_details": sbj,
    "user_test_series_data": utsdMap
  });

  utsdMap.addAll({
    "uts_id": utsByTestId?["uts_id"],
    "uts_course_id": utsByTestId?["course_id"],
    "uts_test_id": utsByTestId?["test_id"],
    "uts_user_id": utsByTestId?["user_id"],
    "uts_status": utsByTestId?["status"],
    "uts_data_json": null,
    "created_at": utsByTestId?["created_at"],
    "updated_at": utsByTestId?["updated_at"]
  });

  sj = sResult.map((e) => GetSubjectWithQuestionsModel.fromMapNew(e)).toList();

  for (var s in sj) {



    List<GetTestQuestionByTidQidModel> sqList = [];
    List<Map<String, dynamic>> qList = [];

    final qResult = await dbService.getTestSubjectWiseQuestionListForResult(testId, s.subjectId);

    sqList = qResult.map((e) => GetTestQuestionByTidQidModel.fromMap(e)).toList();

    sTotalCorrect = 0;
    sTotalWrong = 0;
    sTotalSkipped = 0;
    sTotalReviewMarked = 0;
    sTotalAnswered = 0;
    sTotalUnAns = 0;
    sTotalObtainedMarks = 0.0;
    sTotalObtainedPercentage = 0.0;
    sTotalNegativeMarks = 0.0;

    sbj.add({
      "test_id": s.testId,
      "test_subject": s.subjectId,
      "test_topic": s.testTopic,
      "test_total_question": s.testTotalQuestion,
      "test_exam_id": s.testId,
      "created_at": s.createdAt,
      "updated_at": s.updatedAt,
      "belongs_to_cs_subjects":{
        "subject_id": s.subjectId,
        "subject_name": s.subjectName,
        "subject_topic_id": null,
        "subject_topic_name": null,
        "subject_order": 0,
        "subject_status": 1,
        "subject_slug": s.subjectName.toLowerCase().replaceAll(' ', '-'),
        "created_at": td.createdAt,
        "updated_at": td.updatedAt,
      },
      "has_many_cs_test_series_questions":qList
    });

    for(var q in sqList){
      List<GetQuestionOptionsModel> sOpList = [];
      List<Map<String, dynamic>> opList = [];
      List<Map<String, dynamic>> opHindiList = [];
      final opResult = await dbService.getTestSubjectWiseQuestionObjectListForResult(testId, s.subjectId, q.testQuestion ?? 0);

      sOpList = opResult.map((e) => GetQuestionOptionsModel.fromMap(e)).toList();

      qList.add({
        "question_id": q.questionId,
        "question_que_id": q.questionId,
        "question_test": s.testId,
        "question_topic": null,
        "question_subject": q.questionId,
        "created_at": q.createdAt,
        "updated_at": q.updatedAt,
        "belongs_to_cs_questions": {
          "question_id": q.questionId,
          "question_subject_id": q.subjectId,
          "question_topic": null,
          "question_type": q.type,
          "question_correct_ans": q.questionCorrectAns,
          "question_difficulty_type": q.difficulty,
          "question_eng": q.questionEng,
          "question_eng_solution": q.questionEngSolution,
          "question_hindi": q.questionHindi,
          "question_hindi_solution": q.questionHindiSolution,
          "question_status": q.status,
          "spend_time": q.spendTime,
          "ustqa_selected_ans": q.selectedAns,
          "ustqa_ans_status": q.ansStatus,
          "ustqa_review_status": q.reviewStatus,
          "created_at": q.createdAt,
          "updated_at": q.updatedAt,
          "deleted_at": q.deletedAt,
          "has_many_english_options": opList,
          "has_many_hindi_options": opHindiList
        }
      });

      double matchQueMarks = 0.0;
      double matchQueNgMarks = 0.0;
      bool isMatchCorrect = true;
      for(var o in sOpList){

        if(q.type == 3){

            if(isMatchCorrect){
              if(o.qoSelectedAns == o.qoCorrectAns){

              }else{
                isMatchCorrect = false;
              }
            }
         /* if(o.qoSelectedAns == o.qoCorrectAns){
            matchQueNgMarks = matchQueNgMarks + td.testMarksPerQuestion / sOpList.length;
          }else {
            matchQueNgMarks = matchQueNgMarks +
                double.parse(td.testNegativeMarking) / sOpList.length;
          }*/
        }

        opList.add({
          "qo_id": o.qoId,
          "qo_question_id": o.qoQuestionId,
          "qo_options": o.qoOptions,
          "qo_options_sec": o.qoOptionsSec,
          "qo_correct_ans": o.qoCorrectAns,
          "qo_text": o.qoText,
          "qo_text_sec": o.qoTextSec,
          "qo_lang": o.qoLang,
          "qo_editor": o.qoEditor,
          "qo_selected_ans": o.qoSelectedAns,
          "qoIsSecletedOrNot": o.qoIsSelectedOrNot,
          "created_at": o.createdAt,
          "updated_at": o.updatedAt,
          "deleted_at": o.deletedAt,
          "hindi_qo_options": o.hindiQoOptions,
          "hindi_qo_text": o.hindiQoText,
          "hindi_qo_selected_ans": o.hindiQoSelectedAns,
          "hindi_qo_text_sec": o.hindiQoTextSec,
        });

        opHindiList.add({
        "qo_id": o.qoId,
        "qo_question_id": o.qoQuestionId,
        "qo_options":  o.qoOptions,
        "qo_options_sec": o.qoOptionsSec,
        "qo_correct_ans": o.qoCorrectAns,
        "qo_text": o.hindiQoText,
        "qo_text_sec": o.hindiQoTextSec,
        "qo_lang": 2,
        "qo_editor": o.qoEditor,
        "qo_selected_ans": o.qoSelectedAns,
        "qoIsSecletedOrNot": o.qoIsSelectedOrNot,
        "created_at": o.createdAt,
        "updated_at": o.updatedAt,
        "deleted_at": o.deletedAt,
        });
      }


      if(q.type != 3){
        if(q.selectedAns == q.questionCorrectAns){
          examCtrl.rTotalCorrect.value = examCtrl.rTotalCorrect.value + 1;
          sTotalCorrect = sTotalCorrect + 1;

          sTotalObtainedMarks =
              sTotalObtainedMarks + td.testMarksPerQuestion;

          examCtrl.rTotalObtainedMarks.value =
              examCtrl.rTotalObtainedMarks.value + td.testMarksPerQuestion;

        }else{
          if(q.selectedAns != "1") {
            examCtrl.rTotalWrong.value = examCtrl.rTotalWrong.value + 1;
            sTotalWrong = sTotalWrong + 1;
            examCtrl.rTotalNegativeMarks.value =
                examCtrl.rTotalNegativeMarks.value +
                    double.parse(td.testNegativeMarking);
            sTotalNegativeMarks =
                sTotalNegativeMarks + double.parse(td.testNegativeMarking);
          }
        }
      }else{
        if(isMatchCorrect){
          examCtrl.rTotalCorrect.value = examCtrl.rTotalCorrect.value + 1;
          sTotalCorrect = sTotalCorrect + 1;

          sTotalObtainedMarks =
              sTotalObtainedMarks + td.testMarksPerQuestion;

          examCtrl.rTotalObtainedMarks.value =
              examCtrl.rTotalObtainedMarks.value + td.testMarksPerQuestion;
        }else {
          if (q.selectedAns != "1") {
            examCtrl.rTotalWrong.value = examCtrl.rTotalWrong.value + 1;
            sTotalWrong = sTotalWrong + 1;

            examCtrl.rTotalNegativeMarks.value =
                examCtrl.rTotalNegativeMarks.value +
                    double.parse(td.testNegativeMarking);
            sTotalNegativeMarks =
                sTotalNegativeMarks + double.parse(td.testNegativeMarking);
          }
        }
      }

      if(q.selectedAns != "1"){
        examCtrl.rTotalAnswered.value = examCtrl.rTotalAnswered.value + 1;
        sTotalAnswered = sTotalAnswered + 1;

      }else{
        examCtrl.rTotalUnAns.value = examCtrl.rTotalUnAns.value + 1;
        sTotalUnAns = sTotalUnAns + 1;

      }

      if(q.visitStatus == 1){
        examCtrl.rTotalSkipped.value = examCtrl.rTotalSkipped.value + 1;
        sTotalSkipped = sTotalSkipped + 1;
      }
      if(q.reviewStatus == 1){
        examCtrl.rTotalReviewMarked.value = examCtrl.rTotalReviewMarked.value + 1;
        sTotalReviewMarked = sTotalReviewMarked + 1;

      }



    }
    subDataMap.addAll(
        {
          "sub_tc": sTotalCorrect,
          "sub_tw": sTotalWrong,
          "sub_ts": sTotalSkipped,
          "sub_trm": sTotalReviewMarked,
          "sub_tans": sTotalAnswered,
          "sub_tunans": sTotalUnAns,
          "sub_tom": sTotalObtainedMarks,
          "sub_top": sTotalObtainedPercentage,
          "sub_tnm": sTotalNegativeMarks,
        }
    );

    debugPrint("subjectWiseResult    ${subDataMap}");
    examCtrl.subjectWiseResult.add(subDataMap);


    debugPrint("mainMap12 :- \nTOM:- ${examCtrl.rTotalObtainedMarks}, \nTNM:- ${examCtrl.rTotalNegativeMarks},"
        "\nTANS:- ${examCtrl.rTotalAnswered}, \nTUNANS:- ${examCtrl.rTotalUnAns}, \nTSKIP:- ${examCtrl.rTotalSkipped},"
        "\nTREVIEW:- ${examCtrl.rTotalReviewMarked}, \nTCOR:- ${examCtrl.rTotalCorrect}, \nTWR:- ${examCtrl.rTotalWrong},"
        "\nTP:- ${examCtrl.rTotalObtainedPercentage}");

  }

}
  debugPrint("subjectWiseResult1    ${examCtrl.subjectWiseResult}");
  mainMap.addAll({
    "sub_tc": examCtrl.subjectWiseResult
  });

  debugPrint("mainMap :- \nTOM:- ${examCtrl.rTotalObtainedMarks}, \nTNM:- ${examCtrl.rTotalNegativeMarks},"
      "\nTANS:- ${examCtrl.rTotalAnswered}, \nTUNANS:- ${examCtrl.rTotalUnAns}, \nTSKIP:- ${examCtrl.rTotalSkipped},"
      "\nTREVIEW:- ${examCtrl.rTotalReviewMarked}, \nTCOR:- ${examCtrl.rTotalCorrect}, \nTWR:- ${examCtrl.rTotalWrong},"
      "\nTP:- ${examCtrl.rTotalObtainedPercentage}");

  return mainMap;
}

Future<void> writeToLocalFile(String fileName, String content) async {
  debugPrint('File saved at: $fileName');
  try {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$fileName.txt';

    final file = File(path);
    await file.writeAsString(content);

    debugPrint('File saved at: $path');
  } catch (e) {
    debugPrint('Error writing file: $e');
  }
}

double calculateAccuracy(int correctAnswers, int wrongAnswers) {
  if (correctAnswers + wrongAnswers == 0) return 0.0; // Prevent division by zero
  return (correctAnswers / (correctAnswers + wrongAnswers)) * 100;
}

String getExtendedTimeStringFormat(int timeInSeconds) {
  int hours = timeInSeconds ~/ 3600;
  int minutes = (timeInSeconds % 3600) ~/ 60;
  int seconds = timeInSeconds % 60;

  return "${hours.toString().padLeft(2, '0')}:"
      "${minutes.toString().padLeft(2, '0')}:"
      "${seconds.toString().padLeft(2, '0')}";
}


Widget piCart() {
  final int tc = examCtrl.rTotalCorrect.value;
  final int tw = examCtrl.rTotalWrong.value;
  final int tun = examCtrl.rTotalUnAns.value;
  int totalVotes = tc + tw + tun;
  double tcp = (tc / totalVotes) * 100;
  double twp = (tw / totalVotes) * 100;
  double tunp = (tun / totalVotes) * 100;

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 200,
            child: AspectRatio(
              aspectRatio: 1.3,
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: tcp,
                        title: '',
                        color: Color.fromRGBO(7, 137, 0, 1),
                        radius: 80,
                      ),
                      PieChartSectionData(
                        value: twp,
                        title: '',
                        color: Color.fromRGBO(225, 40, 43, 1),
                        radius: 80,
                      ),
                      PieChartSectionData(
                        value: tunp,
                        title: '',
                        color: Colors.amber,
                        radius: 80,
                      ),
                    ],
                    sectionsSpace: 1,
                    centerSpaceRadius:
                    0, // Creates space in the center for the logo
                  ),
                ),
              ),
            ),
          ),
          ClipOval(
            child: Image.asset(
              'assets/images/logo.png',
              width: 40, // Adjust logo size
              height: 40,
            ),
          ),
        ],
      ),
    ],
  );
}