import 'package:intl/intl.dart';

class VacationModel {
  /// 휴가 id
  String? vacation_id;
  /// 유저 id
  String user_id;
  /// 휴가 출발일
  DateTime start;
  /// 휴가 복귀일
  DateTime end;

  /// 날짜 형식
  static const format = 'yyyy-MM-dd';

  VacationModel({
    this.vacation_id,
    required this.user_id,
    required this.start,
    required this.end
  });

  /// Map 데이터 형식에서 VacationModel 객체로 변환
  VacationModel.fromMap(Map<String, dynamic> map)
      : vacation_id = map['vacation_id'],
        user_id = map['user_id'],
        start = DateFormat(format).parse(map['start']),
        end = DateFormat(format).parse(map['end']);

  /// VacationModel 객체를 Map 데이터 형식으로 변환
  Map<String, dynamic> toMap() => {
    'vacation_id': vacation_id,
    'user_id': user_id,
    'start': start.toString(),
    'end': end.toString()
  };
}