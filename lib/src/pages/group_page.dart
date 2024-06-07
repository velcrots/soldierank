import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ace/src/components/image_data.dart';
import 'package:flutter_ace/widgets/input_deco.dart';
import 'package:hive_flutter/hive_flutter.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({Key? key}) : super(key: key);

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  UserDatabase db = UserDatabase();  // 사용자 데이터베이스

  @override
  void initState() {
    super.initState();
    db.loadData();  // 화면 로드 시 데이터베이스에서 할 일 데이터를 가져옴
    if (db.userList.isEmpty) {  // 로드된 데이터가 없다면
      db.createInitialData();  // 초기 데이터 생성
      db.updateDataBase();  // 생성된 초기 데이터를 데이터베이스에 저장
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Page'),
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: db.userList.length+1+1,
        itemBuilder: (context, index) {
          int dbIndex = index-1-1;
          if (index == 0) {
            return Padding(
              padding: EdgeInsets.all(20),
              child: Text('멤버 ${db.userList.length}명', textAlign: TextAlign.right,)  // 멤버 수
            );
          } if (index == 1) {
            return TextButton(  // 초대 버튼
              child: Text('초대하기'),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                        builder: (context, setState) {
                          return AlertDialog(
                            title: Text('초대하기'),
                            content: Text('초대하기'),
                            actions: [
                              TextField(
                                //controller: idController,
                                autofocus: true,
                                decoration: InputDeco(labelText: '군번', hintText: '군번 (- 없이 입력하세요)'),
                                keyboardType: TextInputType.number,
                              ),
                              TextButton(
                                child: Text('초대하기'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('Close'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        }
                    );
                  },
                );
              },
            );
          } else {
            return ListTile(
              leading: db.getImage(dbIndex),  // 사용자 이미지
              title: db.getName(dbIndex),  // 사용자 이름
              subtitle: db.getMessage(dbIndex),  // 사용자 상태메시지
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          title: db.getName(dbIndex),
                          content: db.getInfo(dbIndex),
                          actions: [
                            TextButton(  // 점수 올리기 버튼
                              child: Icon(Icons.arrow_upward),
                              onPressed: () {
                                setState(() {
                                  db.upScore(dbIndex);
                                });
                              },
                          ),
                            TextButton(  // 점수 내리기 버튼
                              child: Icon(Icons.arrow_downward),
                              onPressed: () {
                                setState(() {
                                  db.downScore(dbIndex);
                                });
                              },
                            ),
                            TextButton(
                              child: Text('Close'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                        ],
                                          );
                      }
                    );
                },
              );
            },
          );
          }
        },
      ),
    );
  }


}

class UserItem {
  String name;  // 사용자 이름
  String message;  // 상태메시지
  String info;  // 관련 정보
  int score;  // 상호 익명 평가 점수

  UserItem({required this.name, this.message = '상태메시지', this.info = '관련 정보', this.score = 50});

  /// Map 데이터 형식에서 UserItem 객체로 변환
  UserItem.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        message = map['message'],
        info = map['info'],
        score = map['score'];

  /// UserItem 객체를 Map 데이터 형식으로 변환
  Map<String, dynamic> toMap() => {'name': name, 'message': message, 'info': info, 'score': score};
}

class UserDatabase {
  List<UserItem> userList = [];  // 사용자 목록을 저장하는 리스트
  final _myBox = Hive.box('hivebox');  // Hive 데이터베이스의 'hivebox' 박스

  /// 초기 데이터 생성
  void createInitialData() {
    userList = [
      UserItem(name: "이름", message: '상태메시지', info: '관련 정보'),
      UserItem(name: "이름", message: '상태메시지', info: '관련 정보'),
      UserItem(name: "이름", message: '상태메시지', info: '관련 정보'),
      UserItem(name: "이름", message: '상태메시지', info: '관련 정보'),
      UserItem(name: "이름", message: '상태메시지', info: '관련 정보'),
      UserItem(name: "이름", message: '상태메시지', info: '관련 정보'),
      UserItem(name: "이름", message: '상태메시지', info: '관련 정보'),
      UserItem(name: "이름", message: '상태메시지', info: '관련 정보'),
      UserItem(name: "이름", message: '상태메시지', info: '관련 정보'),
      UserItem(name: "이름", message: '상태메시지', info: '관련 정보'),
      UserItem(name: "이름", message: '상태메시지', info: '관련 정보'),
    ];
  }

  Icon getImage(int index){  // 사용자 이미지
    return Icon(Icons.account_circle);
  }

  Text getName(int index){  // 사용자 이름
    return Text('${userList[index].name} $index');
  }

  Text getMessage(int index){  // 사용자 상태메시지
    return Text('${userList[index].message} $index');
  }

  SizedBox getInfo(int index){  // 사용자 관련정보
    return SizedBox(
      height: 200,
      child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Text('${userList[index].info} $index'),
        SizedBox(height: 50,),
        Text('익명 평가 점수 : ${userList[index].score}')
      ]),
    );
  }

  void upScore(int index){  // 점수 올리기
    userList[index].score++;
  }

  void downScore(int index){  // 점수 내리기
    userList[index].score--;
  }

  void loadData() {
    var loadedData = _myBox.get("USERLIST") as List<dynamic>? ?? [];
    userList = loadedData.map((item) {
      if (item is Map) {
        return UserItem.fromMap(item.cast<String, dynamic>());
      }
      return null;  // 잘못된 데이터 타입에 대한 처리.
    }).where((item) => item != null).cast<UserItem>().toList();
  }

  void updateDataBase() {
    _myBox.put("USERLIST", userList.map((e) => e.toMap()).toList());  // 'USERLIST' 키에 리스트 데이터 저장
  }
}
