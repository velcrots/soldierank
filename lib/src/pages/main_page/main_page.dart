import 'package:flutter/material.dart';
import 'package:flutter_ace/services/database/main_user_database.dart';
import 'package:flutter_ace/src/pages/main_page/soldierank_main.dart';
import 'package:intl/intl.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  MainUserDatabase db = MainUserDatabase(); // 사용자 데이터베이스

  String soldierType = '';
  late DateFormat format;

  DateTime? joinDate;
  DateTime? dischargeDate;
  DateTime? preOutingDate;
  DateTime? nextVacationDate;
  DateTime? nextEgressionDate;

  @override
  void initState() {
    super.initState();
    format = DateFormat('yyyy-MM-dd HH:mm:ss');
    db.loadData().then((a) {
      // 화면 로드 시 데이터베이스에서 데이터를 가져옴
      if (db.user == null) {
        // 로드된 데이터가 없다면
        db.createInitialData(); // 초기 데이터 생성
      }
      _fetchUserData(); // 데이터 가져오기가 완료되면 함수 실행
    }).catchError((error) {
      print('main initState error: $error');
    });
  }

  void _fetchUserData() {
    try {
      setState(() {
        soldierType = db.user!.soldierType;
        joinDate = db.user!.joinDate;
        dischargeDate = db.user!.dischargeDate;
        preOutingDate = db.user!.preOutingDate;
        nextVacationDate = db.user!.nextVacationDate;
        nextEgressionDate = db.user!.nextEgressionDate;
      });
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: SoldierankMain(
            soldierType: soldierType,
            joinDate: joinDate,
            dischargeDate: dischargeDate,
            preOutingDate: preOutingDate,
            nextVacationDate: nextVacationDate,
            nextEgressionDate: nextEgressionDate,
          ),
        ),
      ),
    );
  }
}
