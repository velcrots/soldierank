import 'package:flutter/material.dart';
import 'package:flutter_ace/services/database/group_user_database.dart';
import 'package:flutter_ace/widgets/input_deco.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({Key? key}) : super(key: key);

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  GroupUserDatabase db = GroupUserDatabase();  // 사용자 데이터베이스

  @override
  void initState() {
    super.initState();
    db.loadData();  // 화면 로드 시 데이터베이스에서 데이터를 가져옴
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


