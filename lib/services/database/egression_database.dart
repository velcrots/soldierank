import 'package:flutter_ace/models/egression_model.dart';
import 'package:flutter_ace/services/web_api/egression_api.dart';
import 'package:flutter_ace/src/app.dart';

class EgressionDatabase {
  List<EgressionModel> egressionList = [];  // 외출 목록을 저장하는 리스트

  /// 초기 데이터 생성
  void createInitialData() {
    egressionList = [
      EgressionModel(user_id: App.userId, start: DateTime.now().add(Duration(days:30)), ),
    ];
    addDataBase(egressionList[0]);
  }

  Future<void> loadData() async {
    await EgressionAPIService().egression(App.userId).then((val) {
      egressionList = val;
    }).catchError((error) {
      print('egression database error: $error');
    });
  }

  /// 외출 추가
  Future<void> addDataBase(EgressionModel egression) async {
    await EgressionAPIService().egressionAdd(egression).then((val) {
      egression.egression_id = val;
    }).catchError((error) {
      print('egressionnAdd database error: $error');
    });
  }

  /// 외출 업데이트
  Future<void> updateDataBase(EgressionModel egression) async {
    await EgressionAPIService().egressionUpdate(egression).then((val) {
      //
    }).catchError((error) {
      print('egressionUpdate database error: $error');
    });
  }

  /// 외출 삭제
  Future<void> deleteDataBase(EgressionModel egression) async {
    await EgressionAPIService().egressionDelete(egression).then((val) {
      //
    }).catchError((error) {
      print('egressionDelete database error: $error');
    });
  }
}