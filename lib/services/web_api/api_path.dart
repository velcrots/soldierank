class APIPath {
  static const String  origin = 'http://soldierank.shop/';
  static const String  origin2 = 'http://soldierank.shop/database/';

  // 로그인
  static const String  login = '${origin}get.php';
  static const String  register = '${origin}register.php';

  // 메인
  static const String  main = '${origin}getInfo2.php';

  // 할 일
  static const String  toDo = '${origin}todo.php';
  static const String  toDoAdd = '${origin}todoAdd.php';
  static const String  toDoUpdate = '${origin}todoUpdate.php';
  static const String  toDoDelete = '${origin}todoDelete.php';

  // 그룹
  static const String  group = '${origin}group.php';

  // 휴가
  static const String  vacation = '${origin2}vacation/vacation.php';
  static const String  vacationAdd = '${origin2}vacation/vacationAdd.php';
  static const String  vacationUpdate = '${origin2}vacation/vacationUpdate.php';
  static const String  vacationDelete = '${origin2}vacation/vacationDelete.php';

  // 외출
  static const String  egression = '${origin2}egression/egression.php';
  static const String  egressionAdd = '${origin2}egression/egressionAdd.php';
  static const String  egressionUpdate = '${origin2}egression/egressionUpdate.php';
  static const String  egressionDelete = '${origin2}egression/egressionDelete.php';
}