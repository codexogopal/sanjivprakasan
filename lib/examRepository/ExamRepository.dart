import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:sanjivprkashan/db/DatabaseHelper.dart';
import 'package:sanjivprkashan/model/forGetExam/GetTestDataById.dart';

class ExamRepository{
  final DatabaseHelper _dbService = DatabaseHelper();


  Future<GetTestDataById?> getTestById(int id) async {
    final testMap = await _dbService.getTestById(id);
    return testMap != null ? GetTestDataById.fromMap(testMap) : null;
  }

  Future<List<GetTestDataById>> getAllTests() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query('tests');
    return List.generate(maps.length, (i) => GetTestDataById.fromMap(maps[i]));
  }

  Future<int> insertTest(GetTestDataById test) async {
    final db = await _dbService.database;
    return await db.insert('tests', test.toMap());
  }

  Future<int> updateTest(GetTestDataById test) async {
    final db = await _dbService.database;
    return await db.update(
      'tests',
      test.toMap(),
      where: 'id = ?',
      whereArgs: [test.id],
    );
  }

  Future<int> deleteTest(int id) async {
    final db = await _dbService.database;
    return await db.delete(
      'tests',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}