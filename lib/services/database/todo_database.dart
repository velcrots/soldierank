import 'package:flutter_ace/models/todo_model.dart';
import 'package:flutter_ace/services/web_api/todo_api.dart';
import 'package:flutter_ace/src/app.dart';

class ToDoDatabase {
  List<ToDoModel> toDoList = [];  // 할 일 목록을 저장하는 리스트

  /// 초기 데이터 생성
  void createInitialData() {
    toDoList = [
      ToDoModel(name: "운동 1시간", isCompleted: false),
      ToDoModel(name: "밥먹기", isCompleted: false),
      ToDoModel(name: "빨래하기", isCompleted: false),
    ];
  }

  Future<void> loadData() async {
    await ToDoAPIService().todo(App.userId).then((val) {
      toDoList = val;
    }).catchError((error) {
      print('todo database error: $error');
    });
  }

  /// 데이터베이스 업데이트
  Future<void> updateDataBase() async {
    await ToDoAPIService().todoAdd(App.userId).then((val) {
      toDoList = val;
    }).catchError((error) {
      print('todo database error: $error');
    });
    // ProfileAPIService api = ProfileAPIService();
    // var future = api.todoUpdate(userId);
    // future.then((val) {
    //   userList = val;
    // }).catchError((error) {
    //   print('error: $error');
    // });
  }
}