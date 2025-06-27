import 'dart:async';

import 'package:sanjivprkashan/ui/exam/dialogs/examUtils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sqlite;

import '../model/forGetExam/GetSubjectWithQuestionsModel.dart';
import '../model/forGetExam/GetTestQuestionByTidQidModel.dart';


class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'gpExam.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> deleteDatabaseFile() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'gpExam.db');
    await deleteDatabase(path);
    print("Database deleted.");
  }

  Future<bool> doesTestExist(int testId) async {
    final db = await database;
    final result = await db.query(
      'tests',
      where: 'test_id = ?',
      whereArgs: [testId],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<void> _onCreate(Database db, int version) async {
    // Main Test Table (now with all fields)
    await db.execute('''
    CREATE TABLE tests (
      id INTEGER PRIMARY KEY,
      test_id INTEGER,
      test_type TEXT,
      test_type_name TEXT,
      test_exam_type INTEGER,
      test_category_id TEXT,
      text_lang TEXT,
      test_quiz_category_id TEXT,
      test_title TEXT,
      test_course TEXT,
      test_description TEXT,
      test_total_no_of_ques INTEGER,
      test_pause_on_que_num INTEGER,
      test_total_marks INTEGER,
      test_duration TEXT,
      test_time TEXT,
      test_schedule_date TEXT,
      test_announcement_date TEXT,
      test_negative_marking TEXT,
      test_paperpdf TEXT,
      test_solution TEXT,
      test_image TEXT,
      test_marks_perquestion INTEGER,
      test_attempt_count INTEGER,
      test_status INTEGER,
      exam_pause_time TEXT,
      test_meta_title TEXT,
      test_meta_keyword TEXT,
      test_meta_desc TEXT,
      created_at TEXT,
      updated_at TEXT,
      deleted_at TEXT
    )
  ''');

    // Subjects Table
    await db.execute('''
    CREATE TABLE test_subjects (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      test_id INTEGER,
      subject_id INTEGER,
      subject_name TEXT,
      test_topic INTEGER,
      test_total_question INTEGER,
      created_at TEXT,
      updated_at TEXT,
      FOREIGN KEY (test_id) REFERENCES tests (test_id)
    )
  ''');

    // Questions Table - FIXED HERE (added missing comma)
    await db.execute('''
    CREATE TABLE questions (
      id INTEGER PRIMARY KEY,
      question_id INTEGER,
      que_no INTEGER,
      test_question INTEGER,
      test_id INTEGER,
      subject_id INTEGER,
      topic_id INTEGER,
      type INTEGER,
      question_correct_ans TEXT,
      difficulty INTEGER,
      question_eng TEXT,
      question_eng_solution TEXT,
      question_hindi TEXT,
      question_hindi_solution TEXT,
      status INTEGER,
      spend_time INTEGER,
      selected_ans TEXT,             /*selected_ans = 1(Not Answered) otherwise value is selected answer */
      visit_status INTEGER,          /*visit_status = 1(Question not visited by user) 2(Question visited by user) */
      ans_status INTEGER,            /*ans_status = 1(Answered by user) 2(Not answered by user)  0(Answer removed by user) */
      review_status INTEGER,         /*review_status = 1(Question add for review by user)  0(Question not for review) */
      created_at TEXT,
      updated_at TEXT,
      deleted_at TEXT,
      FOREIGN KEY (test_id) REFERENCES tests (test_id),
      FOREIGN KEY (subject_id) REFERENCES test_subjects (subject_id)
    )
  ''');

    // Options Table (combines English/Hindi)
    await db.execute('''
    CREATE TABLE question_options (
       id INTEGER PRIMARY KEY,
       qo_id INTEGER,
       que_no INTEGER,
       test_question INTEGER,
       qo_question_id INTEGER,
       test_id INTEGER,
       subject_id INTEGER,
       topic_id INTEGER,
       qo_options TEXT,
       qo_options_sec TEXT,
       qo_correct_ans "B",
       qo_text TEXT,
       qo_text_sec TEXT,
       qo_lang INTEGER,
       qo_editor INTEGER,
       qo_selected_ans TEXT,
       qoIsSecletedOrNot INTEGER,
       created_at TEXT,
       updated_at TEXT,
       deleted_at TEXT,
       hindi_qo_options TEXT,
       hindi_qo_text TEXT,
       hindi_qo_text_sec TEXT,
       hindi_qo_selected_ans TEXT,
       FOREIGN KEY (test_id) REFERENCES questions (test_id),
       FOREIGN KEY (subject_id) REFERENCES questions (subject_id)
       FOREIGN KEY (topic_id) REFERENCES questions (topic_id)
    )
  ''');

    // Options Table (combines only Hindi)
    await db.execute('''
    CREATE TABLE question_options_only_hindi (
       qo_id INTEGER,
       que_no INTEGER,
       test_question INTEGER,
       qo_question_id INTEGER,
       test_id INTEGER,
       subject_id INTEGER,
       topic_id INTEGER,
       qo_options TEXT,
       qo_options_sec TEXT,
       qo_correct_ans TEXT,
       qo_text TEXT,
       qo_text_sec TEXT,
       qo_lang INTEGER,
       qo_editor INTEGER,
       qo_selected_ans TEXT,
       qoIsSecletedOrNot INTEGER,
       created_at TEXT,
       updated_at TEXT,
       deleted_at TEXT,
       FOREIGN KEY (test_id) REFERENCES questions (test_id),
       FOREIGN KEY (subject_id) REFERENCES questions (subject_id),
       FOREIGN KEY (topic_id) REFERENCES questions (topic_id)
    )
''');

    // User Test Series Data
    await db.execute('''
    CREATE TABLE user_test_series (
      uts_id INTEGER PRIMARY KEY,
      course_id INTEGER,
      test_id INTEGER,
      user_id INTEGER,
      status INTEGER,
      created_at TEXT,
      updated_at TEXT,
      FOREIGN KEY (test_id) REFERENCES tests (test_id)
    )
  ''');
  }

  // The getTestById function you asked about
  Future<Map<String, dynamic>?> getTestById(int id) async {
    final db = await database;
    final results = await db.query(
      'tests',
      where: 'test_id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<void> updateExamPauseTime(int testId, double pauseTime) async {
    final db = await database;
    await db.update(
      'tests',
      {'exam_pause_time': pauseTime.toString()},
      where: 'test_id = ?',
      whereArgs: [testId],
    );
  }



  Future<void> updateExamPauseOnQuestion(int testId, int qNo) async {
    final db = await database;
    await db.update(
      'tests',
      {'test_pause_on_que_num': qNo},
      where: 'test_id = ?',
      whereArgs: [testId],
    );
  }

  Future<void> setExamLanguage(int testId, int langStatus) async {
    final db = await database;
    await db.update(
      'tests',
      {'text_lang': langStatus.toString()},
      where: 'test_id = ?',
      whereArgs: [testId],
    );
  }

  Future<void> addQuestionInReview(int testId, int qNo, int rStatus) async {
    final db = await database;
    // debugPrint('addQuestionInReview: $testId  $qNo $rStatus');
    await db.update(
      'questions',
      {
        'review_status': rStatus,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'test_id = ? AND test_question = ?',
      whereArgs: [testId, qNo],
    );
  }
  int _secondsSpent = 0;
  Timer? _timer;

  Future<void> startTimerForQuestion(int testId, int qNo, int rStatus) async {
    await saveSpendTimeOnQue(testId, qNo, rStatus);

    _secondsSpent = rStatus;

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _secondsSpent++;
    });
  }

  Future<void> saveSpendTimeOnQue(int testId, int qNo, int rStatus) async {
    final db = await database;
    // debugPrint('addQuestionInReview: $testId  $qNo $rStatus');
    await db.update(
      'questions',
      {
        'spend_time': rStatus,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'test_id = ? AND test_question = ?',
      whereArgs: [testId, qNo],
    );
  }

  Future<void> clearAnswerForQuestion(int testId, int qNo) async {
    final db = await database;
    // debugPrint('addQuestionInReview: $testId  $qNo');
    await db.update(
      'questions',
      {
        'review_status': 0,
        'selected_ans': 1,
        'ans_status': 2,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'test_id = ? AND test_question = ?',
      whereArgs: [testId, qNo],
    );
    await db.update(
      'question_options',
      {
        'qo_selected_ans': "1",
        'qoIsSecletedOrNot': 0,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'test_id = ? AND test_question = ?',
      whereArgs: [testId, qNo],
    );
  }


  Future<Map<String, dynamic>?> getQuestionByQueNoAndTestId(int testId, int queNo , String testType) async {
    final db = await database;
    if(testType != "1") {
      await db.update(
        'questions',
        {'visit_status': 2},
        where: 'test_id = ? AND test_question = ?',
        whereArgs: [testId, queNo],
      );
    }
    final result = await db.query(
      'questions',
      where: 'test_id = ? AND test_question = ?',
      whereArgs: [testId, queNo],
      limit: 1,
    );
    updateExamPauseOnQuestion(testId, queNo);
    return result.isNotEmpty ? result.first : null;
  }


  Future<List<Map<String, dynamic>>> getQuestionsLength(int testId) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'questions',
      where: 'test_id = ?',
      whereArgs: [testId],
    );

    return result;
  }

  Future<List<Map<String, dynamic>>> getQuestionOptions(int testId, int queNo) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'question_options',
      where: 'test_id = ? AND test_question = ?',
      whereArgs: [testId, queNo],
    );

    return result;
  }



  Future<void> updateOptionAndQuestionForMatchTheFollowing(int testId, int questionId, String opt1st, int status, String option) async {
    final db = await database;

    // Update question_options table

/*      await db.update(
        'question_options',
        {
          'qoIsSecletedOrNot': 0,
          'qo_selected_ans': option,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'test_id = ? AND test_question = ? AND qo_options = ?',
        whereArgs: [testId, questionId, opt1st],
      );*/

    await db.update(
      'question_options',
      {
        'qo_selected_ans': option,
        'qoIsSecletedOrNot': status,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'test_id = ? AND test_question = ? AND qo_options = ?',
      whereArgs: [testId, questionId, opt1st],
    );

    // Update questions table
    await db.update(
      'questions',
      {
        'selected_ans': option,
        'ans_status': status,
        'visit_status': 1,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'test_id = ? AND test_question = ?',
      whereArgs: [testId, questionId],
    );
  }

  Future<void> updateOptionAndQuestion(int testId, int questionId, int status, String option) async {
    final db = await database;

    // Update question_options table

      await db.update(
        'question_options',
        {
          'qoIsSecletedOrNot': 0,
          'qo_selected_ans': option,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'test_id = ? AND test_question = ?',
        whereArgs: [testId, questionId],
      );

    await db.update(
      'question_options',
      {
        'qo_selected_ans': option,
        'qoIsSecletedOrNot': status,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'test_id = ? AND test_question = ? AND qo_options = ?',
      whereArgs: [testId, questionId, option],
    );

    // Update questions table
    await db.update(
      'questions',
      {
        'selected_ans': option,
        'ans_status': status,
        'visit_status': 1,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'test_id = ? AND test_question = ?',
      whereArgs: [testId, questionId],
    );
  }

  Future<bool> updateOptionAndQuestionMultiSelect(int testId, int questionId, int newStatus, String option) async {
    final db = await database;

// Step 1: Update clicked option
    await db.update(
      'question_options',
      {
        'qoIsSecletedOrNot': newStatus,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'test_id = ? AND test_question = ? AND qo_options = ?',
      whereArgs: [testId, questionId, option],
    );

// Step 2: Re-fetch selected options
    final List<Map<String, dynamic>> selectedOptions = await db.query(
      'question_options',
      columns: ['qo_options'],
      where: 'test_id = ? AND test_question = ? AND qoIsSecletedOrNot = 1',
      whereArgs: [testId, questionId],
    );

// Step 3: Sort & join
    List<String> options = selectedOptions.map((e) => e['qo_options'].toString()).toList();
    options.sort();
    String selectedAns = options.join('##');

// Step 4: Update questions table
    await db.update(
      'questions',
      {
        'selected_ans': selectedAns,
        'ans_status': options.isNotEmpty ? 1 : 0,
        'visit_status': 1,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'test_id = ? AND test_question = ?',
      whereArgs: [testId, questionId],
    );

    return true;
  }

  Future<void> updateOptionAndQuestionMultiSelect123(int testId, int questionId, int newStatus, String option) async {

    final db = await database;

// Step 1: Update clicked option
    await db.update(
      'question_options',
      {
        'qoIsSecletedOrNot': newStatus,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'test_id = ? AND test_question = ? AND qo_options = ?',
      whereArgs: [testId, questionId, option],
    );

// Step 2: Re-fetch selected options
    final List<Map<String, dynamic>> selectedOptions = await db.query(
      'question_options',
      columns: ['qo_options'],
      where: 'test_id = ? AND test_question = ? AND qoIsSecletedOrNot = 1',
      whereArgs: [testId, questionId],
    );

// Step 3: Sort & join
    List<String> options = selectedOptions.map((e) => e['qo_options'].toString()).toList();
    options.sort();
    String selectedAns = options.join('##');

// Step 4: Update questions table
    await db.update(
      'questions',
      {
        'selected_ans': selectedAns,
        'ans_status': options.isNotEmpty ? 1 : 0,
        'visit_status': 1,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'test_id = ? AND test_question = ?',
      whereArgs: [testId, questionId],
    );
  }

  Future<List<GetSubjectWithQuestionsModel>> fetchSubjectWithQuestions(int testId) async {
    final db = await database;
    final List<Map<String, dynamic>> subjectRows = await db.query(
      'test_subjects',
      where: 'test_id = ?',
      whereArgs: [testId],
    );

    List<GetSubjectWithQuestionsModel> result = [];

    for (var subject in subjectRows) {
      final List<Map<String, dynamic>> questionRows = await db.query(
        'questions',
        where: 'test_id = ? AND subject_id = ?',
        whereArgs: [testId, subject['subject_id']],
      );

      List<GetTestQuestionByTidQidModel> questions = questionRows.map((q) => GetTestQuestionByTidQidModel.fromMap(q)).toList();

      result.add(GetSubjectWithQuestionsModel.fromMap(subject, questions));
    }

    return result;
  }


  Future<List> getSubjectForResult(int testId) async {
    final db = await database;
    final List<Map<String, dynamic>> subjectRows = await db.query(
      'test_subjects',
      where: 'test_id = ?',
      whereArgs: [testId],
    );
    // debugPrint("eieei  $subjectRows");
    return subjectRows;
  }

  Future<List> getTestSubjectWiseQuestionListForResult(int testId, int subId) async {
    final db = await database;
    final List<Map<String, dynamic>> subjectRows = await db.query(
      'questions',
      where: 'test_id = ? AND subject_id = ?',
      whereArgs: [testId, subId],
    );
    // debugPrint("eieei  $subjectRows");
    return subjectRows;
  }

  Future<List> getTestSubjectWiseQuestionObjectListForResult(int testId, int subId, int qId) async {
    final db = await database;
    final List<Map<String, dynamic>> subjectRows = await db.query(
      'question_options',
      where: 'test_id = ? AND subject_id = ? AND test_question = ?',
      whereArgs: [testId, subId, qId],
    );
    // debugPrint("eieei  $subjectRows");
    return subjectRows;
  }


  // The getTestById function you asked about
  Future<Map<String, dynamic>?> getUserTestSeriesByTestId(int id) async {
  final db = await database;
  final results = await db.query(
  'user_test_series',
  where: 'test_id = ?',
  whereArgs: [id],
  limit: 1,
  );
  return results.isNotEmpty ? results.first : null;
  }

}

/*
final List<Map<String, dynamic>> selectedOptions = await db.query(
'question_options',
columns: ['qo_options'],
where: 'test_id = ? AND test_question = ? AND qoIsSecletedOrNot = 1',
whereArgs: [testId, questionId],
);*/
