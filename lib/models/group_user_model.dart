class GroupUserModel {
  /// 사용자 이름
  late String name;
  /// 상태메시지
  late String message;
  /// 관련 정보
  late String info;
  /// 상호 익명 평가 점수
  late int score;

  GroupUserModel({
    required this.name,
    this.message = '상태메시지',
    this.info = '관련 정보',
    this.score = 50
  });

  /// Map 데이터 형식에서 GroupUserModel 객체로 변환
  GroupUserModel.fromMap(Map<String, dynamic> map)
      : name = map['이름'] ?? '',
        message = map['상태메시지'] ?? '',
        info = map['정보'] ?? '',
        score = map['선호도'] ?? 0;

  /// GroupUserModel 객체를 Map 데이터 형식으로 변환
  Map<String, dynamic> toMap() => {
    '이름': name,
    '상태메시지': message,
    '정보': info,
    '선호도': score
  };
}