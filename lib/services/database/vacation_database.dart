import 'package:flutter_ace/models/vacation_model.dart';
import 'package:flutter_ace/services/web_api/vacation_api.dart';
import 'package:flutter_ace/src/app.dart';

class VacationDatabase {
  List<VacationModel> vacationList = [];  // 휴가 목록을 저장하는 리스트

  /// 초기 데이터 생성
  void createInitialData() {
    vacationList = [
      VacationModel(user_id: App.userId, start: DateTime.now().add(Duration(days:30)), end: DateTime.now().add(Duration(days:35))),
    ];
    addDataBase(vacationList[0]);
  }

  Future<void> loadData() async {
    await VacationAPIService().vacation(App.userId).then((val) {
      vacationList = val;
    }).catchError((error) {
      print('vacation database error: $error');
    });
  }

  /// 휴가 추가
  Future<void> addDataBase(VacationModel vacation) async {
    await VacationAPIService().vacationAdd(vacation).then((val) {
      vacation.vacation_id = val;
      vacationList.add(vacation);
    }).catchError((error) {
      print('vacationAdd database error: $error');
    });
  }

  /// 휴가 업데이트
  Future<void> updateDataBase(VacationModel vacation) async {
    await VacationAPIService().vacationUpdate(vacation).then((val) async {
      await loadData();
    }).catchError((error) {
      print('vacationUpdate database error: $error');
    });
  }

  /// 휴가 삭제
  Future<void> deleteDataBase(VacationModel vacation) async {
    await VacationAPIService().vacationDelete(vacation).then((val) {
      vacationList.removeWhere((a)=> a.vacation_id == vacation.vacation_id);
    }).catchError((error) {
      print('vacationDelete database error: $error');
    });
  }
}