import 'package:flutter_ace/models/vacation_model.dart';
import 'package:flutter_ace/services/database/vacation_database.dart';
import 'package:flutter_ace/src/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async{
  VacationDatabase db = VacationDatabase(); // setUp용 데이터베이스
  DateTime now = DateTime.now();
  DateTime start_test =  DateTime(now.year, now.month, now.day);
  DateTime end_test =  start_test.add(Duration(days: 30));
  VacationModel model_test = VacationModel(user_id: App.userId, start: start_test, end: end_test);

  VacationDatabase db_test = VacationDatabase(); // test용 데이터베이스

  group('휴가 추가', () {
    setUp(() async { // 테스트 데이터 추가
      await db.loadData();
      await db.addDataBase(model_test);

      await db_test.loadData();
    });
    tearDown(() async { // 테스트가 끝나면 테스트 데이터 삭제
      await db.deleteDataBase(db.vacationList.last);
    });

    test('새로 추가한 휴가의 유저 id가 같은가?', () {
      expect(db_test.vacationList.last.user_id, App.userId);
    });

    test('새로 추가한 휴가의 출발일이 같은가?', () {
      expect(db_test.vacationList.last.start.toString(), start_test.toString());
    });

    test('새로 추가한 휴가의 복귀일이 같은가?', () {
      expect(db_test.vacationList.last.end.toString(), end_test.toString());
    });
  });

  group('휴가 수정', () {
    DateTime update_start_test =  start_test.add(Duration(days: 10));
    DateTime update_end_test =  start_test.add(Duration(days: 40));

    setUp(() async { // 테스트 데이터 수정
      await db.loadData();
      await db.addDataBase(model_test);
      VacationModel update_model_test = db.vacationList.last;
      update_model_test.start = update_start_test;
      update_model_test.end = update_end_test;
      await db.updateDataBase(update_model_test);

      await db_test.loadData();
    });
    tearDown(() async { // 테스트가 끝나면 테스트 데이터 삭제
      await db.deleteDataBase(db.vacationList.last);
    });

    test('수정한 휴가의 유저 id가 같은가?', () {
      expect(db_test.vacationList.last.user_id, App.userId);
    });

    test('수정한 휴가의 출발일이 같은가?', () {
      expect(db_test.vacationList.last.start.toString(), update_start_test.toString());
    });

    test('수정한 휴가의 복귀일이 같은가?', () {
      expect(db_test.vacationList.last.end.toString(), update_end_test.toString());
    });
  });

  group('휴가 삭제', () {
    String? lastId;
    setUp(() async { // 테스트 데이터 삭제
      await db.loadData();
      lastId = db.vacationList.last.vacation_id;
      await db.addDataBase(model_test);
      await db.deleteDataBase(db.vacationList.last);

      await db_test.loadData();
    });

    test('삭제 후 마지막 휴가 id가 같은가?', () {
      expect(db_test.vacationList.last.vacation_id, lastId);
    });
  });
}