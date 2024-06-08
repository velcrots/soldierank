class ToDoModel {
  /// 할 일의 이름 또는 내용
  String name;
  /// 할 일의 완료 여부
  bool isCompleted;

  ToDoModel({
    required this.name,
    this.isCompleted = false
  });

  /// Map 데이터 형식에서 ToDoItem 객체로 변환
  ToDoModel.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        isCompleted = map['isCompleted'] == 0 ? false : true;

  /// ToDoItem 객체를 Map 데이터 형식으로 변환
  Map<String, dynamic> toMap() => {
    'name': name,
    'isCompleted': isCompleted
  };
}