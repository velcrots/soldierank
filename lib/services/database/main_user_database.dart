
import 'package:flutter/material.dart';
import 'package:flutter_ace/models/group_user_model.dart';
import 'package:flutter_ace/models/main_user_model.dart';
import 'package:flutter_ace/services/web_api/api.dart';
import 'package:intl/intl.dart';

class MainUserDatabase {
  /// 사용자 목록을 저장하는 리스트
  MainUserModel? user;

  DateFormat format = DateFormat('yyyy-MM-dd HH:mm:ss');

  /// 초기 데이터 생성
  void createInitialData() {
    user = MainUserModel(
        soldierType: "해군",
        joinDate: DateTime.now().subtract(Duration(days: 300)),
        dischargeDate: DateTime.now().add(Duration(days: 300)),
        preOutingDate: DateTime.now().subtract(Duration(days: 30)),
        nextVacationDate: DateTime.now().add(Duration(days: 30)),
        nextEgressionDate: DateTime.now().add(Duration(days: 30))
    );
  }


  /// 데이터베이스 불러오기
  Future<void> loadData(userId) async {
    await ProfileAPIService().main(userId).then((val) {
      user = val;
    }).catchError((error) {
      print('main user database error: $error');
    });
  }

  /// 데이터베이스 업데이트
  void updateDataBase() {
    // ProfileAPIService api = ProfileAPIService();
    // var future = api.mainUpdate('1234567890');
    // future.then((val) {
    //   userList = val;
    // }).catchError((error) {
    //   print('error: $error');
    // });
  }
}