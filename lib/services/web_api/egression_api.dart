import 'package:dio/dio.dart';
import 'package:flutter_ace/models/egression_model.dart';
import 'package:flutter_ace/services/web_api/api_path.dart';

class EgressionAPIService {
  EgressionAPIService();

  /// 외출 리스트 반환
  Future<List<EgressionModel>> egression(user_id) async {
    try {
      var url = Uri.parse(APIPath.egression);
      Response<List<dynamic>> response = await Dio().postUri(url, data: {
        'user_id': user_id});
      print('egression data: ${response.data}');

      // 외출 리스트 반환
      List<EgressionModel> egressionList = [];
      response.data?.forEach((val){
        egressionList.add(EgressionModel.fromMap(val));
      });
      return egressionList;

    } on Exception catch (error) {
      print('egression api error: $error');
      rethrow;
    }
  }

  /// 외출 추가 (외출의 인덱스값 반환)
  Future<String> egressionAdd(EgressionModel egression) async {
    try {
      var egressionMap = egression.toMap();

      var url = Uri.parse(APIPath.egressionAdd);
      Response<String> response = await Dio().postUri(url, data: {
        'user_id': egressionMap['user_id'],
        'start': egressionMap['start'],});
      print('egression index: ${response.data}');

      return(response.data!);
    } on Exception catch (error) {
      print('egressionAdd api error: $error');
      rethrow;
    }
  }

  /// 외출 업데이트
  Future<void> egressionUpdate(EgressionModel egression) async {
    try {
      var egressionMap = egression.toMap();

      var url = Uri.parse(APIPath.egressionUpdate);
      Response<int> response = await Dio().postUri(url, data: {
        'egression_id': egressionMap['egression_id'],
        'start': egressionMap['start'],});
      // print('data: ${response.data}');

    } on Exception catch (error) {
      print('egressionUpdate api error: $error');
      rethrow;
    }
  }

  /// 외출 삭제
  Future<void> egressionDelete(EgressionModel egression) async {
    try {
      var egressionMap = egression.toMap();

      var url = Uri.parse(APIPath.egressionDelete);
      Response<int> response = await Dio().postUri(url, data: {
        'egression_id': egressionMap['egression_id']});
      // print('data: ${response.data}');

    } on Exception catch (error) {
      print('egressionDelete api error: $error');
      rethrow;
    }
  }

}