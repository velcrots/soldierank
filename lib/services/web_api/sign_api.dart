import 'package:dio/dio.dart';
import 'package:flutter_ace/services/web_api/api_path.dart';

class SignAPIService {
  SignAPIService();

  Future<int> login(String idText, String pwdText) async {
    try {
      var url = Uri.parse(APIPath.login);
      var response = await Dio().postUri(url, data: {'username': idText, 'pwd': pwdText});
      return response.data;
    } on Exception catch (error) {
      print('login api error: $error');
      rethrow;
    }
  }

  Future<bool> register(name, birth, id, pwd, join, discharge, soldierType, pos, isCheck) async {
    try {
      var url = Uri.parse(APIPath.register);
      var response = await Dio().postUri(url, data: {
        'name': name,
        'birth': birth,
        'id': id,
        'pwd': pwd,
        'join': join,
        'discharge': discharge,
        'soldierType': soldierType,
        'pos': pos,
        'isCheck': isCheck ? 1 : 0
      });
      return response.data;
    } on Exception catch (error) {
      print('register api error: $error');
      rethrow;
    }
  }

}