import 'package:intl/intl.dart';

class EgressionModel {
  /// 외출 id
  String? egression_id;
  /// 유저 id
  String user_id;
  /// 외출 출발일
  DateTime start;

  /// 날짜 형식
  static const format = 'yyyy-MM-dd';

  EgressionModel({
    this.egression_id,
    required this.user_id,
    required this.start,
  });

  /// Map 데이터 형식에서 EgressionModel 객체로 변환
  EgressionModel.fromMap(Map<String, dynamic> map)
      : egression_id = map['egression_id'],
        user_id = map['user_id'],
        start = DateFormat(format).parse(map['start']);

  /// EgressionModel 객체를 Map 데이터 형식으로 변환
  Map<String, dynamic> toMap() => {
    'egression_id': egression_id,
    'user_id': user_id,
    'start': start.toString(),
  };
}