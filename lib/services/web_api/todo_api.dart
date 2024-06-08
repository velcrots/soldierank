import 'package:dio/dio.dart';
import 'package:flutter_ace/models/todo_model.dart';
import 'package:flutter_ace/services/web_api/api_path.dart';

class ToDoAPIService {
  ToDoAPIService();

  // 투두 리스트 반환
  Future<List<ToDoModel>> todo(id) async {
    try {
      var url = Uri.parse(APIPath.toDo);
      Response<List<dynamic>> response = await Dio().postUri(url, data: {'id': id});
      print('data: ${response.data}');

      // 투두 리스트 반환
      List<ToDoModel> toDoList = [];
      response.data?.forEach((val){
        toDoList.add(ToDoModel.fromMap(val));
      });
      return toDoList;

    } on Exception catch (error) {
      print('todo api error: $error');
      rethrow;
    }
  }

  // 투두 추가
  Future<List<ToDoModel>> todoAdd(id) async {
    try {
      var url = Uri.parse(APIPath.toDo);
      Response<List<dynamic>> response = await Dio().postUri(url, data: {'id': id});
      print('data: ${response.data}');

      // 투두 리스트 반환
      List<ToDoModel> toDoList = [];
      response.data?.forEach((val){
        toDoList.add(ToDoModel.fromMap(val));
      });
      return toDoList;

    } on Exception catch (error) {
      print('todo api error: $error');
      rethrow;
    }
  }

}