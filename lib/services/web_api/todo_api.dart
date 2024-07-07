import 'package:dio/dio.dart';
import 'package:flutter_ace/models/todo_model.dart';
import 'package:flutter_ace/services/web_api/api_path.dart';

class ToDoAPIService {
  ToDoAPIService();

  /// 투두 리스트 반환
  Future<List<ToDoModel>> todo(id) async {
    try {
      var url = Uri.parse(APIPath.toDo);
      Response<List<dynamic>> response =
          await Dio().postUri(url, data: {'id': id});
      // print('data: ${response.data}');

      // 투두 리스트 반환
      List<ToDoModel> toDoList = [];
      response.data?.forEach((val) {
        toDoList.add(ToDoModel.fromMap(val));
      });
      return toDoList;
    } on Exception catch (error) {
      print('todo api error: $error');
      rethrow;
    }
  }

  /// 투두 추가 (투두의 인덱스값 반환)
  Future<int> todoAdd(id, ToDoModel toDo) async {
    try {
      var toDoMap = toDo.toMap();

      var url = Uri.parse(APIPath.toDoAdd);
      Response<int> response =
          await Dio().postUri(url, data: {'id': id, 'name': toDoMap['name']});
      // print('data: ${response.data}');

      return (response.data!);
    } on Exception catch (error) {
      print('todoAdd api error: $error');
      rethrow;
    }
  }

  /// 투두 업데이트
  Future<void> todoUpdate(id, ToDoModel toDo) async {
    try {
      var toDoMap = toDo.toMap();

      var url = Uri.parse(APIPath.toDoUpdate);
      Response<int> response = await Dio().postUri(url, data: {
        'id': toDoMap['id'],
        'name': toDoMap['name'],
        'isCompleted': toDoMap['isCompleted'] ? 1 : 0
      });
      // print('data: ${response.data}');
    } on Exception catch (error) {
      print('todoUpdate api error: $error');
      rethrow;
    }
  }

  /// 투두 삭제
  Future<void> todoDelete(id, ToDoModel toDo) async {
    try {
      var toDoMap = toDo.toMap();

      var url = Uri.parse(APIPath.toDoDelete);
      Response<int> response =
          await Dio().postUri(url, data: {'id': toDoMap['id']});
      // print('data: ${response.data}');
    } on Exception catch (error) {
      print('todoDelete api error: $error');
      rethrow;
    }
  }
}
