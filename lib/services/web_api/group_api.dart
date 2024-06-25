import 'package:dio/dio.dart';
import 'package:flutter_ace/models/group_user_model.dart';
import 'package:flutter_ace/services/web_api/api_path.dart';

class GroupAPIService {
  GroupAPIService();

  // 그룹에 속한 유저리스트 반환
  Future<List<GroupUserModel>> group(id) async {
    try {
      var url = Uri.parse(APIPath.group);
      Response<List<dynamic>> response = await Dio().postUri(url, data: {'id': id});
      //print('data: ${response.data}');

      // 그룹에 속한 유저리스트 반환
      List<GroupUserModel> userList = [];
      response.data?.forEach((val){
        userList.add(GroupUserModel.fromMap(val));
      });
      return userList;

    } on Exception catch (error) {
      print('group api error: $error');
      rethrow;
    }
  }
}