import 'package:flutter_ace/models/egression_model.dart';
import 'package:flutter_ace/services/database/egression_database.dart';
import 'package:flutter_ace/src/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async{
  EgressionDatabase db = EgressionDatabase(); // setUp용 데이터베이스
  DateTime now = DateTime.now();
  DateTime start_test =  DateTime(now.year, now.month, now.day);
  EgressionModel model_test = EgressionModel(user_id: App.userId, start: start_test);

  EgressionDatabase db_test = EgressionDatabase(); // test용 데이터베이스

  group('외출 추가', () {
    setUp(() async { // 테스트 데이터 추가
      await db.loadData();
      await db.addDataBase(model_test);

      await db_test.loadData();
    });
    tearDown(() async { // 테스트가 끝나면 테스트 데이터 삭제
      await db.deleteDataBase(db.egressionList.last);
    });

    test('새로 추가한 외출의 유저 id가 같은가?', () {
      expect(db_test.egressionList.last.user_id, App.userId);
    });

    test('새로 추가한 외출의 출발일이 같은가?', () {
      expect(db_test.egressionList.last.start.toString(), start_test.toString());
    });
  });

  group('외출 수정', () {
    DateTime update_start_test =  start_test.add(Duration(days: 10));

    setUp(() async { // 테스트 데이터 수정
      await db.loadData();
      await db.addDataBase(model_test);
      EgressionModel update_model_test = db.egressionList.last;
      update_model_test.start = update_start_test;
      await db.updateDataBase(update_model_test);

      await db_test.loadData();
    });
    tearDown(() async { // 테스트가 끝나면 테스트 데이터 삭제
      await db.deleteDataBase(db.egressionList.last);
    });

    test('수정한 외출의 유저 id가 같은가?', () {
      expect(db_test.egressionList.last.user_id, App.userId);
    });

    test('수정한 외출의 출발일이 같은가?', () {
      expect(db_test.egressionList.last.start.toString(), update_start_test.toString());
    });
  });

  group('외출 삭제', () {
    String? lastId;
    setUp(() async { // 테스트 데이터 삭제
      await db.loadData();
      lastId = db.egressionList.last.egression_id;
      await db.addDataBase(model_test);
      await db.deleteDataBase(db.egressionList.last);

      await db_test.loadData();
    });

    test('삭제 후 마지막 외출 id가 같은가?', () {
      expect(db_test.egressionList.last.egression_id, lastId);
    });
  });
}