import 'package:flutter/material.dart';
import 'package:flutter_ace/models/group_user_model.dart';
import 'package:flutter_ace/services/web_api/group_api.dart';

class GroupUserDatabase {
  /// 사용자 목록을 저장하는 리스트
  List<GroupUserModel> userList = [];

  /// 초기 데이터 생성
  void createInitialData() {
    for(int i = 0; i < 10; i++){
      userList.add(GroupUserModel(name: "이름$i", message: '상태메시지$i', info: '관련 정보$i'));
    }
  }

  /// 사용자 이미지
  Icon getImage(int index){
    return Icon(Icons.account_circle);
  }

  /// 사용자 이름
  Text getName(int index){
    return Text(userList[index].name);
  }

  /// 사용자 상태메시지
  Text getMessage(int index){
    return Text(userList[index].message);
  }

  /// 사용자 관련정보
  SizedBox getInfo(int index){
    return SizedBox(
      height: 200,
      child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(userList[index].info),
            SizedBox(height: 50,),
            Text('익명 평가 점수 : ${userList[index].score}')
          ]),
    );
  }

  /// 점수 올리기
  void upScore(int index){
    userList[index].score++;
  }

  /// 점수 내리기
  void downScore(int index){
    userList[index].score--;
  }

  /// 데이터베이스 불러오기
  void loadData() {
    GroupAPIService().group('1234567890').then((val) {
      userList = val;
    }).catchError((error) {
      print('group user database error: $error');
    });
  }

  /// 데이터베이스 업데이트
  void updateDataBase() {
    // ProfileAPIService api = ProfileAPIService();
    // var future = api.groupUpdate('1234567890');
    // future.then((val) {
    //   userList = val;
    // }).catchError((error) {
    //   print('error: $error');
    // });
  }
}