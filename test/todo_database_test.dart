import 'package:flutter_ace/models/todo_model.dart';
import 'package:flutter_ace/services/database/todo_database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async{
  ToDoDatabase db = ToDoDatabase(); // setUp용 데이터베이스
  String name_test = '테스트 todo';
  ToDoModel model_test = ToDoModel(name: '테스트 todo');

  ToDoDatabase db_test = ToDoDatabase(); // test용 데이터베이스

  group('todo 추가', () {
    setUp(() async { // 테스트 데이터 추가
      await db.loadData();
      await db.addDataBase(model_test);

      await db_test.loadData();
    });
    tearDown(() async { // 테스트가 끝나면 테스트 데이터 삭제
      await db.deleteDataBase(db.toDoList.last);
    });

    test('새로 추가한 todo의 name이 같은가?', () {
      expect(db_test.toDoList.last.name, name_test);
    });
  });

  group('todo 수정', () {
    String update_name_test = '테스트 todo update';

    setUp(() async { // 테스트 데이터 수정
      await db.loadData();
      await db.addDataBase(model_test);
      ToDoModel update_model_test = db.toDoList.last;
      update_model_test.name = update_name_test;
      await db.updateDataBase(update_model_test);

      await db_test.loadData();
    });
    tearDown(() async { // 테스트가 끝나면 테스트 데이터 삭제
      await db.deleteDataBase(db.toDoList.last);
    });

    test('수정한 todo의 name이 같은가?', () {
      expect(db_test.toDoList.last.name, update_name_test);
    });
  });

  group('todo 삭제', () {
    int? lastId;
    setUp(() async { // 테스트 데이터 삭제
      await db.loadData();
      lastId = db.toDoList.last.id;
      await db.addDataBase(model_test);
      await db.deleteDataBase(db.toDoList.last);

      await db_test.loadData();
    });

    test('삭제 후 마지막 todo id가 같은가?', () {
      expect(db_test.toDoList.last.id, lastId);
    });
  });
}