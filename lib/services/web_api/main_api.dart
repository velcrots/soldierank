import 'package:dio/dio.dart';
import 'package:flutter_ace/models/main_user_model.dart';
import 'package:flutter_ace/services/web_api/api_path.dart';

class MainAPIService {
  MainAPIService();

  // 메인에서 사용할 사용자 정보 반환
  Future<MainUserModel> main(String idText) async {
    try {
      var url = Uri.parse(APIPath.main);
      final response = await Dio().postUri(url, data: {'username': idText});
      print('data: ${response.data}');
      return MainUserModel.fromMap(response.data);
    } on Exception catch (error) {
      print('main api error: $error');
      rethrow;
    }
  }

}