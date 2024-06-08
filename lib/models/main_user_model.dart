import 'package:intl/intl.dart';

class MainUserModel {
  /// 군별
  late String soldierType;
  /// 입대일
  late DateTime joinDate;
  /// 전역일
  late DateTime dischargeDate;
  /// 최근 복귀일 (최초 값은 입대일임)
  late DateTime preOutingDate;
  /// 다음 휴가 (null 값이 올 수 있음)
  DateTime? nextVacationDate;
  /// 다음 외출 (null 값이 올 수 있음)
  DateTime? nextEgressionDate;

  /// 날짜 형식
  static const format = 'yyyy-MM-dd';

  MainUserModel({
    required this.soldierType,
    required this.joinDate,
    required this.dischargeDate,
    required this.preOutingDate,
    this.nextVacationDate,
    this.nextEgressionDate,
  });

  /// Map 데이터 형식에서 GroupUserInfo 객체로 변환
  MainUserModel.fromMap(Map<String, dynamic> map)
      : soldierType = map['군별'],
        joinDate = DateFormat(format).parse(map['입대일']),
        dischargeDate = DateFormat(format).parse(map['전역일']),
        preOutingDate = DateFormat(format).parse(map['최근_복귀일']),
        nextVacationDate = map['휴가_출발_날짜'] == null ? null : DateFormat(format).parse(map['휴가_출발_날짜']),
        nextEgressionDate = map['외출_출발_날짜'] == null ? null : DateFormat(format).parse(map['외출_출발_날짜']);

  /// GroupUserInfo 객체를 Map 데이터 형식으로 변환
  Map<String, dynamic> toMap() => {
    '군별': soldierType,
    '입대일': joinDate,
    '전역일': dischargeDate,
    '최근_복귀일': preOutingDate,
    '휴가_출발_날짜': nextVacationDate,
    '외출_출발_날짜': nextEgressionDate
  };
}