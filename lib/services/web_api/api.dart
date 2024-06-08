import 'package:dio/dio.dart';
import 'package:flutter_ace/models/group_user_model.dart';
import 'package:flutter_ace/models/main_user_model.dart';

class ProfileAPIService {
  ProfileAPIService();

  Future<int> login(String idText, String pwdText) async {
    try {
      var url = Uri.parse(
        'http://navy-combat-power-management-platform.shop/get.php',
      );
      var response = await Dio().postUri(url, data: {'username': idText, 'pwd': pwdText});
      return response.data;
    } on Exception catch (error) {
      print('login api error: $error');
      rethrow;
    }
  }

  Future<bool> register(name, birth, id, pwd, join, discharge, soldierType, pos, isCheck) async {
    try {
      var url = Uri.parse(
        'http://navy-combat-power-management-platform.shop/register.php',
      );
      var response = await Dio().postUri(url, data: {'name': name, 'birth': birth, 'id': id, 'pwd': pwd, 'join': join, 'discharge': discharge, 'soldierType': soldierType, 'pos': pos, 'isCheck': isCheck ? 1 : 0});
      return response.data;
    } on Exception catch (error) {
      print('register api error: $error');
      rethrow;
    }
  }

  Future<MainUserModel> main(String idText) async {
    try {
      final url = Uri.parse(
          'http://navy-combat-power-management-platform.shop/getInfo2.php');
      final response = await Dio().postUri(url, data: {'username': idText});
      print('data: ${response.data}');
      return MainUserModel.fromMap(response.data);
    } on Exception catch (error) {
      print('main api error: $error');
      rethrow;
    }
  }

  Future<List<GroupUserModel>> group(id) async {
    try {
      var url = Uri.parse(
        'http://navy-combat-power-management-platform.shop/group.php',
      );
      Response<List<dynamic>> response = await Dio().postUri(url, data: {'id': id});
      //print('data: ${response.data}');
      List<GroupUserModel> userList = [];
      response.data?.forEach((va){
        userList.add(GroupUserModel.fromMap(va));
      });
      return userList;
    } on Exception catch (error) {
      print('group api error: $error');
      rethrow;
    }
  }

  Future<void> _update(String idText, String pwdText) async {
    try {
      var url = Uri.parse(
        'http://navy-combat-power-management-platform.shop/get.php',
      );
      var response = await Dio().postUri(url, data: {'username': idText, 'pwd': pwdText});
    } on Exception catch (error) {
      print('update api error: $error');
    }
  }
}