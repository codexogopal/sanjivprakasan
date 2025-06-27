import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sanjivprkashan/model/forGetExam/GetSubjectWithQuestionsModel.dart';
import 'package:sanjivprkashan/model/forGetExam/GetTestDataById.dart';
import 'package:sanjivprkashan/ui/exam/TestAnalysisScreen.dart';
import 'package:sanjivprkashan/ui/exam/dialogs/ExamThenkYouScreen.dart';
import 'package:sanjivprkashan/utils/styleUtil.dart';

import '../../Constant.dart';
import '../../session/SessionManager.dart';
import '../db/DatabaseHelper.dart';
import '../model/forGetExam/GetQuestionOptionsModel.dart';
import '../model/forGetExam/GetTestQuestionByTidQidModel.dart';
import '../model/forSetExam/TestDetailModel.dart';
import '../model/forSetExam/UserTestSeriesData.dart';
import '../ui/exam/dialogs/examUtils.dart';

class ExamController extends GetxController {
  var isLoading = false.obs;
  var isExamTimeOver = false.obs;
  var isExamSubmitting = false.obs;

  // variables for exam result start

  var rTotalCorrect = 0.obs;
  var rTotalWrong = 0.obs;
  var rTotalSkipped = 0.obs;
  var rTotalReviewMarked = 0.obs;
  var rTotalAnswered = 0.obs;
  var rTotalUnAns = 0.obs;
  var rTotalObtainedMarks = 0.0.obs;
  var rTotalObtainedPercentage = 0.0.obs;
  var rTotalNegativeMarks = 0.0.obs;

  // variables for exam result end

  final DatabaseHelper dbService = DatabaseHelper();

  @override
  void onInit() {
    super.onInit();
    isExamTimeOver.value = false;
    isStart.value = true;
  }

  var isStart = false.obs;
  var counters = 1.obs;
  var examEndTime = 0.obs;
  var isReview = 0.obs;
  var examLang = "1".obs;
  var testType = "0".obs;
  var testCourseId = "0".obs;

  var totalSeconds = 0.obs;

  var totalAnswered = 0.obs;
  var totalUnAns = 0.obs;
  var totalSkipped = 0.obs;
  var totalReviewMarked = 0.obs;
  var secondsSpent = 0.obs;
  Timer? timer;
  var subjectWiseResult = [].obs;

  var minutes = 0.obs;
  var seconds = 0.obs;

  void startTimer(int testId) {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (testType.value != "1") {
        totalSeconds++;
        examCtrl.saveSpendTimer(testId, counters.value, totalSeconds.value);
      }
      minutes.value = totalSeconds.value ~/ 60;
      seconds.value = totalSeconds.value % 60;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  final Rxn<GetTestDataById> testData = Rxn<GetTestDataById>();
  final Rxn<GetTestQuestionByTidQidModel> tQData =
      Rxn<GetTestQuestionByTidQidModel>();
  final RxList<GetTestQuestionByTidQidModel> getQuestionsLength =
      RxList<GetTestQuestionByTidQidModel>();
  final RxList<GetQuestionOptionsModel> tQOptionData =
      RxList<GetQuestionOptionsModel>();

  // get test data by test id
  Future<void> loadTestDataById(int testId) async {
    final result = await dbService.getTestById(testId);
    final qLengthResult = await dbService.getQuestionsLength(testId);
    getQuestionsLength.value =
        qLengthResult
            .map((e) => GetTestQuestionByTidQidModel.fromMap(e))
            .toList();

    if (result != null) {
      testData.value = GetTestDataById.fromMap(result);
      /*

      double pauseMinutes = double.tryParse(testData.value?.examPauseTime ?? "0") ?? 0.0;
      // double pauseMinutes = double.tryParse("1") ?? 1.0;
      int minutesPart = pauseMinutes.floor();
      int secondsPart = ((pauseMinutes - minutesPart) * 60).round();
      examEndTime.value = DateTime.now().millisecondsSinceEpoch + (minutesPart * 60 * 1000) + (secondsPart * 1000);
*/
      examLang.value = testData.value?.textLang ?? "1";
      counters.value = testData.value?.testPauseOnQueNum ?? 1;
      initializeExamTimer();
      // if(isStart.value){
      timer?.cancel();
      isStart.value = false;
      startTimer(testId);
      // }
      Timer(Duration(milliseconds: 150), () {
        getQByQIdAndTId(testId, counters.value);

        loadSubjects(testId);
        debugPrint('✅ LoadData from database  ${testData.value?.testTitle}');
      });
    } else {
      testData.value = null;
      debugPrint('❌ is null data   ${testData.value?.testTitle}');
    }
  }

  void initializeExamTimer() {
    isLoading.value = true;

    try {
      double pauseMinutes =
          double.tryParse(testData.value?.examPauseTime ?? "0") ?? 0.0;
      int totalMilliseconds = (pauseMinutes * 60 * 1000).round();

      if (totalMilliseconds > 0) {
        examEndTime.value =
            DateTime.now().millisecondsSinceEpoch + totalMilliseconds;
      } else {
        isExamTimeOver.value = true;
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getUserQueHistory(BuildContext context, int testId) async {
    // totalAnswered.value = 0;
    // totalUnAns.value = 0;
    // totalSkipped.value = 0;
    // totalReviewMarked.value = 0;
    int tAnsed = 0;
    int tUnAnsed = 0;
    int tUnVisited = 0;
    int tReMarked = 0;
    final qLengthResult = await dbService.getQuestionsLength(testId);
    getQuestionsLength.value =
        qLengthResult
            .map((e) => GetTestQuestionByTidQidModel.fromMap(e))
            .toList();
    for (var que in getQuestionsLength) {
      if (que.selectedAns != "1") {
        tAnsed = tAnsed + 1;
      } else {
        tUnAnsed = tUnAnsed + 1;
      }

      if (que.visitStatus == 1) {
        tUnVisited = tUnVisited + 1;
      }

      if (que.reviewStatus == 1) {
        tReMarked = tReMarked + 1;
      }
    }

    totalAnswered.value = tAnsed;
    totalUnAns.value = tUnAnsed;
    totalSkipped.value = tUnVisited;
    totalReviewMarked.value = tReMarked;

    showSubmitTestDialog(context, testId, testType.value);
  }

  // get question and option data by test id and question id
  Future<void> getQByQIdAndTId(int testId, int questionId) async {
    final result = await dbService.getQuestionByQueNoAndTestId(
      testId,
      questionId,
      testType.value,
    );
    final otpResult = await dbService.getQuestionOptions(testId, questionId);

    if (result != null) {
      tQData.value = GetTestQuestionByTidQidModel.fromMap(result);

      tQOptionData.value =
          otpResult.map((e) => GetQuestionOptionsModel.fromMap(e)).toList();

      totalSeconds.value = tQData.value?.spendTime ?? 0;
      isReview.value = tQData.value?.reviewStatus ?? 0;
    } else {
      tQData.value = null;
      tQOptionData.clear();
      debugPrint('❌ is null data   ${tQData.value?.questionHindi}');
    }
  }

  // exam time over then use
  void onExamTimeEnd(BuildContext context, int testId) {
    isExamTimeOver.value = true;
    timer?.cancel();
    getUserQueHistory(context, testId);
  }

  // update exam pause time
  Future<void> updateExamPauseTimeAndFetch(int testId, double minutes) async {
    try {
      final success = await dbService.updateExamPauseTime(testId, minutes);
    } catch (e) {
      debugPrint('Error in updateAndFetch: $testId  $minutes ${e.toString()}');
      return null;
    }
  }

  // update exam pause time
  Future<void> saveAnswers(
    int testId,
    int qId,
    int status,
    String userAns,
  ) async {
    try {
      final success = await dbService.updateOptionAndQuestion(
        testId,
        qId,
        status,
        userAns,
      );
      getQByQIdAndTId(testId, qId);
      debugPrint('Error in updateAndFetch: $testId  $qId $status $userAns');
    } catch (e) {
      debugPrint(
        'Error in updateAndFetch: $testId  $qId $status $userAns ${e.toString()}',
      );
      return null;
    }
  }

  // update exam pause time
  Future<void> saveAnswersForMatchTheFo(
    int testId,
    int qId,
    String matchOpt,
    int status,
    String userAns,
  ) async {
    try {
      final success = await dbService
          .updateOptionAndQuestionForMatchTheFollowing(
            testId,
            qId,
            matchOpt,
            status,
            userAns,
          );
      getQByQIdAndTId(testId, qId);
      debugPrint(
        'Match the following: $testId  $qId $matchOpt $status $userAns',
      );
    } catch (e) {
      debugPrint(
        'Error in updateAndFetch: $testId  $qId $status $userAns ${e.toString()}',
      );
      return null;
    }
  }

  // add or remove question from review status
  Future<void> addToReview(int testId, int qId, int rStatus) async {
    try {
      final success = await dbService.addQuestionInReview(testId, qId, rStatus);
      getQByQIdAndTId(testId, qId);
    } catch (e) {
      debugPrint('Error in updateAndFetch: $testId  $qId ${e.toString()}');
      return null;
    }
  }

  // save total spend time on pre question
  Future<void> saveSpendTimer(int testId, int qId, int sec) async {
    try {
      final success = await dbService.startTimerForQuestion(testId, qId, sec);
      getQByQIdAndTId(testId, qId);
    } catch (e) {
      debugPrint('Error in updateAndFetch: $testId  $qId ${e.toString()}');
      return null;
    }
  }

  // change exam language
  Future<void> setExamLanguage(int testId, int lStatus) async {
    try {
      final success = await dbService.setExamLanguage(testId, lStatus);
      loadTestDataById(testId);
    } catch (e) {
      debugPrint('Error in updateAndFetch: $testId  $lStatus  ${e.toString()}');
      return null;
    }
  }

  // clear current Question all status
  Future<void> clearAnswerForQuestion(int testId, int qId) async {
    try {
      final success = await dbService.clearAnswerForQuestion(testId, qId);
      getQByQIdAndTId(testId, qId);
    } catch (e) {
      debugPrint('Error in updateAndFetch: $testId  $qId ${e.toString()}');
      return null;
    }
  }

  Future<void> saveAnswersMultiSelect(
    int testId,
    int qId,
    int newStatus,
    String userAns,
  ) async {
    try {
      final success = await dbService.updateOptionAndQuestionMultiSelect(
        testId,
        qId,
        newStatus,
        userAns,
      );
      getQByQIdAndTId(testId, qId);
      debugPrint('Error in updateAndFetch: $testId  $qId  $userAns');
    } catch (e) {
      debugPrint(
        'Error in updateAndFetch: $testId  $qId  $userAns ${e.toString()}',
      );
      return null;
    }
  }

  var subjects = <GetSubjectWithQuestionsModel>[].obs;

  Future<void> loadSubjects(int testId) async {
    try {
      final result = await dbService.fetchSubjectWithQuestions(testId);
      subjects.assignAll(result);

      // debugPrint("loading subjects: ${subjects.length}");
    } catch (e) {
      debugPrint("Error loading subjects: $e");
    } finally {}
  }

  void toggleExpand(int index) {
    subjects[index].isExpanded = !subjects[index].isExpanded;
    subjects.refresh();
  }

  // getting text data from api
  Rxn<TestDetailModel> examData = Rxn<TestDetailModel>();
  Rxn<UserTestSeriesData> userTestSeriesData = Rxn<UserTestSeriesData>();
  Map<String, dynamic> userTestSeriesDataMap = {
    "uts_id": 0,
    "uts_course_id": 0,
    "uts_test_id": 0,
    "uts_user_id": 0,
    "uts_status": 3,
    "created_at": "2025-05-14T09:54:41.000000Z",
    "updated_at": "2025-05-14T09:54:41.000000Z",
  };

  Future<void> getExamData(String testID, String courseId) async {
    isLoading.value = true;
    final dbHelper = DatabaseHelper();

    // 1. Check if test already exists in DB
    final bool exists = await dbHelper.doesTestExist(int.parse(testID));

    if (exists) {
      // getTestData = ExamRepository().getTestById(int.parse(testID)) as Rxn<GetTestDataById>;
      loadTestDataById(int.parse(testID));
      debugPrint('✅ Test already exists in database - skipping API call');
      isLoading.value = false;
      return; // Exit if data exists
    }
    try {
      var response = await http.post(
        Uri.parse(Constant.testQuestionsData),
        body: {
          "test_id": testID.toString(),
          "test_type": testType.value,
          "course_id": courseId,
        },
        headers: Constant().userHeader,
      );
      if (response.statusCode == 200) {
        Map mData = json.decode(response.body);

        // debugPrint("dataaa ${mData}  ${Constant().userHeader}");
        if (mData['status'] == "success") {
          examData.value = TestDetailModel.fromJson(mData["data"]);
          userTestSeriesData.value =
              mData["user_test_series_data"] != null
                  ? UserTestSeriesData.fromJson(mData["user_test_series_data"])
                  : UserTestSeriesData.fromJson(userTestSeriesDataMap);
          saveCompleteTestSeries(examData.value!, userTestSeriesData.value!, 1);
          Timer(Duration(milliseconds: 500), () {
            // showGreenSnackbar("Great!", mData["message"]);
          });
        } else {
          if (mData["message"] == "Session Expired") {
            SessionManager().logout();
          }
          showSnackbar("Opps!", mData["message"]);
        }
      } else {
        showSnackbar(
          "Error",
          "Failed to fetch getting response Code : ${response.statusCode}",
        );
      }
    } catch (e) {
      debugPrint("error123 ${e.toString()}");
      showSnackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitTheTest(
    String testID,
    String testJson,
    String rtm,
    String rmo,
    String raq,
    String rcq,
    String ratpq,
    String rwq,
    String runans,
    String subResultJson,
  ) async {
    isLoading.value = true;
    timer?.cancel();

    try {
      var response = await http.post(
        Uri.parse(Constant.userTestSubmit),
        body: {
          "test_id": testID.toString(),
          "result_course_id": testCourseId.value,
          "result_total_marks": rtm,
          "result_marks_obtained": rmo,
          "result_attempted_questions": raq,
          "result_correct_questions": rcq,
          "result_average_time_per_question": ratpq,
          "result_wrong_questions": rwq,
          "result_unanswered": runans,
          "sub_result_json": subResultJson,
          "uts_data_json": testJson,
        },
        headers: Constant().userHeader,
      );
      if (response.statusCode == 200) {
        Map mData = json.decode(response.body);

        debugPrint("dataaa  $testID ${mData}  ${Constant().userHeader}");
        if (mData['status'] == "success") {
          showGreenSnackbar("Great!", mData["message"]);
          Timer(Duration(milliseconds: 500), () {
            // Get.off(()=> TestAnalysisScreen(testID: testID));
            Get.offAll(
              () => ExamThenkYouScreen(),
              transition: Transition.rightToLeft,
              duration: Duration(milliseconds: 600),
            );
          });
        } else {
          if (mData["message"] == "Session Expired") {
            SessionManager().logout();
          }
          showSnackbar("Opps!", mData["message"]);
        }
      } else {
        showSnackbar(
          "Error",
          "Failed to fetch getting response Code : ${response.statusCode}",
        );
      }
    } catch (e) {
      debugPrint("error ${e.toString()}");
      showSnackbar("Error", e.toString());
    } finally {
      isExamSubmitting.value = false;
      isLoading.value = false;
    }
  }

  var ranking = "".obs;
  var outOfRanking = "".obs;
  Future<void> getExamResultData(
    String testID,
  ) async {
    isLoading.value = true;
    timer?.cancel();

    try {
      var response = await http.post(
        Uri.parse(Constant.testResultData),
        body: {
          "test_id": testID.toString(),
        },
        headers: Constant().userHeader,
      );
      if (response.statusCode == 200) {
        Map mData = json.decode(response.body);
        debugPrint("dataaa  $testID ${mData}  ${Constant().userHeader}");
        ranking.value = mData["resultData"]["result_user_ranking"].toString();
        outOfRanking.value = mData["resultData"]["totalResultCount"].toString();
        if (mData['status'] == "success") {

          Timer(Duration(milliseconds: 500), () {

          });
        } else {
          if (mData["message"] == "Session Expired") {
            SessionManager().logout();
          }
          showSnackbar("Opps!", mData["message"]);
        }
      } else {
        showSnackbar(
          "Error",
          "Failed to fetch getting response Code : ${response.statusCode}",
        );
      }
    } catch (e) {
      debugPrint("error ${e.toString()}");
      showSnackbar("Error", e.toString());
    } finally {
      isExamSubmitting.value = false;
      isLoading.value = false;
    }
  }

  // saving exam data in database
  Future<void> saveCompleteTestSeries(
    TestDetailModel response,
    UserTestSeriesData userTestData,
    int examStatus,
  ) async {
    final dbHelper = DatabaseHelper();
    final batch = (await dbHelper.database).batch();
    int queCounter = 0;
    int pauseOnQueNo = 1;
    try {
      // 1. Save main test data
      batch.insert('tests', {
        'test_id': response.testId,
        'test_type': response.testType,
        'test_type_name': response.testTypeName,
        'test_exam_type': response.testExamType,
        'test_category_id': response.testCategoryId,
        'test_quiz_category_id': response.testQuizCategoryId,
        'text_lang': 1,
        'test_title': response.testTitle,
        'test_course': response.testCourse,
        'test_description': response.testDescription,
        'test_total_no_of_ques': response.testTotalNoOfQues,
        'test_pause_on_que_num': pauseOnQueNo,
        'test_total_marks': response.testTotalMarks,
        'test_duration': response.testDuration,
        'test_time': response.testTime,
        'test_schedule_date': response.testScheduleDate,
        'test_announcement_date': response.testAnnouncementDate,
        'test_negative_marking': response.testNegativeMarking,
        'test_paperpdf': response.testPaperpdf,
        'test_solution': response.testSolution,
        'test_image': response.testImage,
        'test_marks_perquestion': response.testMarksPerquestion,
        'test_attempt_count': response.testAttemptCount,
        'test_status': response.testStatus,
        'exam_pause_time':
            (response.examPauseTime == "" ||
                    response.examPauseTime == "0" ||
                    response.examPauseTime == null)
                ? response.testDuration
                : response.examPauseTime,
        'test_meta_title': response.testMetaTitle,
        'test_meta_keyword': response.testMetaKeyword,
        'test_meta_desc': response.testMetaDesc,
        'created_at': response.createdAt,
        'updated_at': response.updatedAt,
        'deleted_at': response.deletedAt,
      });

      // 2. Save user test series data
      if (userTestData != null) {
        batch.insert('user_test_series', {
          'uts_id': userTestData.utsId,
          'course_id': userTestData.utsCourseId,
          'test_id': userTestData.utsTestId,
          'user_id': userTestData.utsUserId,
          'status': userTestData.utsStatus,
          'created_at': userTestData.createdAt,
          'updated_at': userTestData.updatedAt,
        });
      }

      // 3. Save subjects and questions

      queCounter = 0;
      for (var subject in response.hasManyCsTestSubjectDetails ?? []) {
        batch.insert('test_subjects', {
          'test_id': response.testId,
          'subject_id': subject.testSubject,
          'subject_name': subject.belongsToCsSubjects?.subjectName,
          'test_topic': subject.testTopic,
          'test_total_question': subject.testTotalQuestion,
          'created_at': subject.createdAt,
          'updated_at': subject.updatedAt,
        });

        for (var entry
            in (subject.hasManyCsTestSeriesQuestions ?? []).asMap().entries) {
          final index = entry.key; // This is the index (0-based)
          final q = entry.value;
          final question = q.belongsToCsQuestions;
          queCounter = queCounter + 1;
          batch.insert('questions', {
            'question_id': question.questionId,
            'que_no': index + 1,
            'test_question': queCounter,
            'test_id': response.testId,
            'subject_id': subject.testSubject,
            'topic_id': subject.testTopic,
            'type': question.questionType,
            'question_correct_ans':
                question?.hasManyEnglishOptions[0].qoCorrectAns.toString() ??
                "1",
            'difficulty': question.questionDifficultyType,
            'question_eng': question.questionEng,
            'question_eng_solution': question.questionEngSolution,
            'question_hindi': question.questionHindi,
            'question_hindi_solution': question.questionHindiSolution,
            'status': question.questionStatus,
            'spend_time': question.spendTime,
            'selected_ans': question.ustqaSelectedAns,
            'visit_status': question.ustqaVisitStatus,
            'ans_status': question.ustqaAnsStatus,
            'review_status': question.ustqaReviewStatus,
            'created_at': question.createdAt,
            'updated_at': question.updatedAt,
            'deleted_at': question.deletedAt,
          });

          // Save options
          for (var opt in question?.hasManyEnglishOptions ?? []) {
            batch.insert('question_options', {
              "qo_id": opt.qoId,
              'que_no': index + 1,
              'test_question': queCounter,
              "qo_question_id": opt.qoQuestionId,
              'test_id': response.testId,
              'subject_id': subject.testSubject,
              'topic_id': question.questionTopic,
              "qo_options": opt.qoOptions,
              "qo_options_sec": opt.qoOptionsSec,
              "qo_correct_ans": opt.qoCorrectAns,
              "qo_text": opt.qoText,
              "qo_text_sec": opt.qoTextSec,
              "qo_lang": opt.qoLang,
              "qo_editor": opt.qoEditor,
              "qo_selected_ans": opt.qoSelectedAns,
              "qoIsSecletedOrNot": opt.qoIsSelectedOrNot,
              "created_at": opt.createdAt,
              "updated_at": opt.updatedAt,
              "deleted_at": opt.deletedAt,
              "hindi_qo_options": opt.hindiQoOptions,
              "hindi_qo_text": opt.hindiQoText,
              "hindi_qo_text_sec": opt.hindiQoTextSec,
              "hindi_qo_selected_ans": opt.hindiQoSelectedAns,
            });
          }

          // Repeat for Hindi options
          for (var opt in question?.hasManyHindiOptions ?? []) {
            batch.insert('question_options_only_hindi', {
              'qo_id': opt.qoId,
              'que_no': index + 1,
              'test_question': queCounter,
              'qo_question_id': opt.qoQuestionId,
              'test_id': response.testId,
              'subject_id': subject.testSubject,
              'topic_id': question.questionTopic,
              'qo_options': opt.qoOptions,
              'qo_options_sec': opt.qoOptionsSec,
              'qo_correct_ans': opt.qoCorrectAns,
              'qo_text': opt.qoText,
              'qo_text_sec': opt.qoTextSec,
              'qo_lang': opt.qoLang,
              'qo_editor': opt.qoEditor,
              'qo_selected_ans': opt.qoSelectedAns,
              'qoIsSecletedOrNot': opt.qoIsSelectedOrNot,
              'created_at': opt.createdAt,
              'updated_at': opt.updatedAt,
              'deleted_at': opt.deletedAt,
            });
          }
        }
      }

      await batch.commit(noResult: true);
      debugPrint('✅ All data saved successfully!');
      loadTestDataById(response.testId!);
    } catch (e) {
      debugPrint('❌ Error saving data: $e');
    }
  }

  Future<Map> createExamSubmitJson(int testId, String testType) async {
    isExamSubmitting.value = true;
    Map mainMap = {};
    Map utsdMap = {};
    final DatabaseHelper dbService = DatabaseHelper();
    final result = await dbService.getTestById(testId);
    final utsByTestId = await dbService.getUserTestSeriesByTestId(testId);

    if (result!.isNotEmpty) {
      final td = GetTestDataById.fromMap(result);

      List<GetSubjectWithQuestionsModel> sj = [];
      List<Map<String, dynamic>> sbj = [];
      final sResult = await dbService.getSubjectForResult(testId);

      // Reset all counters
      rTotalCorrect.value = 0;
      rTotalWrong.value = 0;
      rTotalSkipped.value = 0;
      rTotalReviewMarked.value = 0;
      rTotalAnswered.value = 0;
      rTotalUnAns.value = 0;
      rTotalObtainedMarks.value = 0.0;
      rTotalObtainedPercentage.value = 0.0;
      rTotalNegativeMarks.value = 0.0;

      subjectWiseResult.clear();

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
        "test_meta_keyword": td.testMetaKeyword,
        "test_meta_desc": td.testMetaDesc,
        "created_at": td.createdAt,
        "updated_at": td.updatedAt,
        "deleted_at": td.deletedAt,
        "has_many_cs_test_subject_details": sbj,
        "user_test_series_data": utsdMap,
      });

      utsdMap.addAll({
        "uts_id": utsByTestId?["uts_id"],
        "uts_course_id": utsByTestId?["course_id"],
        "uts_test_id": utsByTestId?["test_id"],
        "uts_user_id": utsByTestId?["user_id"],
        "uts_status": utsByTestId?["status"],
        "uts_data_json": null,
        "created_at": utsByTestId?["created_at"],
        "updated_at": utsByTestId?["updated_at"],
      });

      sj =
          sResult
              .map((e) => GetSubjectWithQuestionsModel.fromMapNew(e))
              .toList();

      for (var s in sj) {
        List<GetTestQuestionByTidQidModel> sqList = [];
        List<Map<String, dynamic>> qList = [];
        final qResult = await dbService.getTestSubjectWiseQuestionListForResult(
          testId,
          s.subjectId,
        );
        sqList =
            qResult
                .map((e) => GetTestQuestionByTidQidModel.fromMap(e))
                .toList();

        // Create a new map for each subject's data
        Map<String, dynamic> subDataMap = {
          "sub_tc": 0, // subject total correct
          "sub_tw": 0, // subject total wrong
          "sub_ts": 0, // subject total skipped
          "sub_trm": 0, // subject total review marked
          "sub_tans": 0, // subject total answered
          "sub_tunans": 0, // subject total unanswered
          "sub_tom": 0.0, // subject total obtained marks
          "sub_top": 0.0, // subject total obtained percentage
          "sub_tnm": 0.0, // subject total negative marks
          "sub_name": "",
          "sub_id": 0,
        };

        sbj.add({
          "test_id": s.testId,
          "test_subject": s.subjectId,
          "test_topic": s.testTopic,
          "test_total_question": s.testTotalQuestion,
          "test_exam_id": s.testId,
          "created_at": s.createdAt,
          "updated_at": s.updatedAt,
          "belongs_to_cs_subjects": {
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
          "has_many_cs_test_series_questions": qList,
        });

        for (var q in sqList) {
          List<GetQuestionOptionsModel> sOpList = [];
          List<Map<String, dynamic>> opList = [];
          List<Map<String, dynamic>> opHindiList = [];
          final opResult = await dbService
              .getTestSubjectWiseQuestionObjectListForResult(
                testId,
                s.subjectId,
                q.testQuestion ?? 0,
              );

          sOpList =
              opResult.map((e) => GetQuestionOptionsModel.fromMap(e)).toList();

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
              "ustqa_visit_status": q.visitStatus,
              "created_at": q.createdAt,
              "updated_at": q.updatedAt,
              "deleted_at": q.deletedAt,
              "has_many_english_options": opList,
              "has_many_hindi_options": opHindiList,
            },
          });

          double matchQueMarks = 0.0;
          double matchQueNgMarks = 0.0;
          bool isMatchCorrect = true;

          for (var o in sOpList) {
            if (q.type == 3) {
              if (isMatchCorrect) {
                if (o.qoSelectedAns == o.qoCorrectAns) {
                  // Correct match
                } else {
                  isMatchCorrect = false;
                }
              }
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
              "qo_options": o.qoOptions,
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

          // Update counters for both subject and overall exam
          if (q.type != 3) {
            if (q.selectedAns == q.questionCorrectAns) {
              rTotalCorrect.value += 1;
              subDataMap["sub_tc"] += 1;

              subDataMap["sub_tom"] += td.testMarksPerQuestion;
              rTotalObtainedMarks.value += td.testMarksPerQuestion;
            } else {
              if (q.selectedAns != "1") {
                rTotalWrong.value += 1;
                subDataMap["sub_tw"] += 1;

                rTotalNegativeMarks.value += double.parse(
                  td.testNegativeMarking,
                );
                subDataMap["sub_tnm"] += double.parse(td.testNegativeMarking);
              }
            }
          } else {
            if (isMatchCorrect) {
              rTotalCorrect.value += 1;
              subDataMap["sub_tc"] += 1;

              subDataMap["sub_tom"] += td.testMarksPerQuestion;
              rTotalObtainedMarks.value += td.testMarksPerQuestion;
            } else {
              if (q.selectedAns != "1") {
                rTotalWrong.value += 1;
                subDataMap["sub_tw"] += 1;

                rTotalNegativeMarks.value += double.parse(
                  td.testNegativeMarking,
                );
                subDataMap["sub_tnm"] += double.parse(td.testNegativeMarking);
              }
            }
          }

          if (q.selectedAns != "1") {
            rTotalAnswered.value += 1;
            subDataMap["sub_tans"] += 1;
          } else {
            rTotalUnAns.value += 1;
            subDataMap["sub_tunans"] += 1;
          }

          if (q.visitStatus == 1) {
            rTotalSkipped.value += 1;
            subDataMap["sub_ts"] += 1;
          }
          if (q.reviewStatus == 1) {
            rTotalReviewMarked.value += 1;
            subDataMap["sub_trm"] += 1;
          }
        }

        // Calculate percentage for this subject
        if (s.testTotalQuestion > 0) {
          subDataMap["sub_top"] =
              (subDataMap["sub_tom"] /
                  (s.testTotalQuestion * td.testMarksPerQuestion)) *
              100;
        }
        subDataMap["sub_name"] = s.subjectName;
        subDataMap["sub_id"] = s.subjectId;
        // Add this subject's data to the controller
        subjectWiseResult.add(Map.from(subDataMap));
      }

      // Calculate overall percentage
      if (td.testTotalNoOfQues > 0 && td.testTotalMarks > 0) {
        rTotalObtainedPercentage.value =
            (rTotalObtainedMarks.value / td.testTotalMarks) * 100;
      }

      debugPrint("Subject-wise results: ${subjectWiseResult}");
      debugPrint(
        "Overall results: "
        "\nTotal Obtained Marks: ${rTotalObtainedMarks.value}, "
        "\nTotal Negative Marks: ${rTotalNegativeMarks.value},"
        "\nTotal Answered: ${rTotalAnswered.value}, "
        "\nTotal Unanswered: ${rTotalUnAns.value}, "
        "\nTotal Skipped: ${rTotalSkipped.value},"
        "\nTotal Review Marked: ${rTotalReviewMarked.value}, "
        "\nTotal Correct: ${rTotalCorrect.value}, "
        "\nTotal Wrong: ${rTotalWrong.value},"
        "\nTotal Percentage: ${rTotalObtainedPercentage.value}",
      );
    }
    const encoder = JsonEncoder.withIndent('  ');
    final String formattedJson = encoder.convert(mainMap);
    final String formattedSubJson = encoder.convert(subjectWiseResult);
    final spentTime = (getSpentTimeInMinutes(
              examCtrl.testData.value?.testDuration ?? "0",
              examCtrl.testData.value?.examPauseTime ?? "0",
            ) /
            examCtrl.rTotalAnswered.value)
        .toStringAsFixed(2);
    if (testType == "1") {
      isExamSubmitting.value = false;
      Get.to(() => TestAnalysisScreen(testID: testId.toString()));
    } else {
      submitTheTest(
        testId.toString(),
        formattedJson,
        testData.value?.testTotalMarks.toString() ?? "",
        rTotalObtainedMarks.value.toString(),
        rTotalAnswered.value.toString(),
        rTotalCorrect.value.toString(),
        spentTime.toString(),
        rTotalWrong.value.toString(),
        rTotalUnAns.value.toString(),
        formattedSubJson,
      );
    }

    // Pretty-print the JSON with indentation

    await writeToLocalFile("GopalSanjiv", formattedJson);
    return mainMap;
  }
}
