class ToDoModel {
  /// 할 일 id
  int? id;
  /// 할 일의 이름 또는 내용
  String name;
  /// 할 일의 완료 여부
  bool isCompleted;

  ToDoModel({
    this.id,
    required this.name,
    this.isCompleted = false
  });

  /// Map 데이터 형식에서 ToDoModel 객체로 변환
  ToDoModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        isCompleted = map['isCompleted'] == 0 ? false : true;

  /// ToDoModel 객체를 Map 데이터 형식으로 변환
  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'isCompleted': isCompleted
  };
}