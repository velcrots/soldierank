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
    addDataBase(toDoList[0]);
    addDataBase(toDoList[1]);
    addDataBase(toDoList[2]);
  }

  Future<void> loadData() async {
    await ToDoAPIService().todo(App.userId).then((val) {
      toDoList = val;
    }).catchError((error) {
      print('todo database error: $error');
    });
  }

  /// 투두 추가
  Future<void> addDataBase(toDo) async {
    await ToDoAPIService().todoAdd(App.userId, toDo).then((val) {
      toDo.id = val;
    }).catchError((error) {
      print('todoAdd database error: $error');
    });
  }

  /// 투두 업데이트
  Future<void> updateDataBase(toDo) async {
    await ToDoAPIService().todoUpdate(App.userId, toDo).then((val) {
      //
    }).catchError((error) {
      print('todoUpdate database error: $error');
    });
  }

  /// 투두 삭제
  Future<void> deleteDataBase(toDo) async {
    await ToDoAPIService().todoDelete(App.userId, toDo).then((val) {
      //
    }).catchError((error) {
      print('todoDelete database error: $error');
    });
  }
}