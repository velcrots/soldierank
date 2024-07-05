import 'package:dio/dio.dart';
import 'package:flutter_ace/models/vacation_model.dart';
import 'package:flutter_ace/services/web_api/api_path.dart';

class VacationAPIService {
  VacationAPIService();

  /// 휴가 리스트 반환
  Future<List<VacationModel>> vacation(user_id) async {
    try {
      var url = Uri.parse(APIPath.vacation);
      Response<List<dynamic>> response = await Dio().postUri(url, data: {
        'user_id': user_id});
      print('vacation data: ${response.data}');

      // 휴가 리스트 반환
      List<VacationModel> vacationList = [];
      response.data?.forEach((val){
        vacationList.add(VacationModel.fromMap(val));
      });
      return vacationList;

    } on Exception catch (error) {
      print('vacation api error: $error');
      rethrow;
    }
  }

  /// 휴가 추가 (휴가의 인덱스값 반환)
  Future<String> vacationAdd(VacationModel vacation) async {
    try {
      var vacationMap = vacation.toMap();

      var url = Uri.parse(APIPath.vacationAdd);
      Response<String> response = await Dio().postUri(url, data: {
        'user_id': vacationMap['user_id'],
        'start': vacationMap['start'],
        'end': vacationMap['end']});
      print('vacation index: ${response.data}');

      return(response.data!);
    } on Exception catch (error) {
      print('vacationAdd api error: $error');
      rethrow;
    }
  }

  /// 휴가 업데이트
  Future<void> vacationUpdate(VacationModel vacation) async {
    try {
      var vacationMap = vacation.toMap();

      var url = Uri.parse(APIPath.vacationUpdate);
      Response<int> response = await Dio().postUri(url, data: {
        'vacation_id': vacationMap['vacation_id'],
        'start': vacationMap['start'],
        'end': vacationMap['end']});
      // print('data: ${response.data}');

    } on Exception catch (error) {
      print('vacationUpdate api error: $error');
      rethrow;
    }
  }

  /// 휴가 삭제
  Future<void> vacationDelete(VacationModel vacation) async {
    try {
      var vacationMap = vacation.toMap();

      var url = Uri.parse(APIPath.vacationDelete);
      Response<int> response = await Dio().postUri(url, data: {
        'vacation_id': vacationMap['vacation_id']});
      // print('data: ${response.data}');

    } on Exception catch (error) {
      print('vacationDelete api error: $error');
      rethrow;
    }
  }

}