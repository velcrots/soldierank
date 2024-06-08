import 'package:flutter/material.dart';
import 'package:flutter_ace/routes.dart';
import 'package:flutter_ace/services/web_api/api.dart';
import '../../widgets/input_deco.dart';
import '../app.dart';
import './register.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController idController = TextEditingController();
  TextEditingController pwdController = TextEditingController();

  double loginMessageEnable = 0.0;
  String loginMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log in'),
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 50)),
              Center(
                child: Icon(Icons.account_circle_outlined),
              ),
              Form(
                  child: Theme(
                data: ThemeData(
                    primaryColor: Colors.grey,
                    inputDecorationTheme: InputDecorationTheme(
                        labelStyle:
                            TextStyle(color: Colors.teal, fontSize: 15.0))),
                child: Container(
                    padding: EdgeInsets.all(40.0),
                    child: Builder(builder: (context) {
                      return Column(
                        children: [

                          // 군번 입력 필드
                          TextField(
                            controller: idController,
                            autofocus: true,
                            decoration: InputDeco(labelText: '군번', hintText: '군번 (- 없이 입력하세요)'),
                            keyboardType: TextInputType.number,
                          ),

                          SizedBox(
                            height: 10,
                          ),

                          // 비밀번호 입력 필드
                          TextField(
                            controller: pwdController,
                            decoration: InputDeco(labelText: '비밀번호', hintText: '비밀번호'),
                            keyboardType: TextInputType.text,
                            obscureText: true,
                          ),

                          // 오류 메시지
                          Opacity(
                            opacity: loginMessageEnable,
                            child: Text(loginMessage, style: TextStyle(color: Colors.red)),
                          ),
                          SizedBox(
                            height: 40.0,
                          ),

                          // 로그인 버튼
                          ButtonTheme(
                              child: ElevatedButton(
                                onPressed: () {
                                  ProfileAPIService().login(idController.text, pwdController.text).then((val) {
                                    if (val == 1) {
                                      Navigator.of(context).pushNamed(Routes.app, arguments: idController.text); //idController.text
                                      loginMessageEnable = 0.0;
                                    } else {
                                      setState(() {setMessage('군번 또는 비밀번호를 잘못 입력했습니다. \n입력하신 내용을 다시 확인해주세요.');});
                                    }
                                  }).catchError((error) {
                                    setState(() {setMessage('서버 오류: $error');});
                                    print('error: $error');
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    minimumSize: Size(MediaQuery.of(context).size.width, 70),
                                    backgroundColor: Colors.white10),
                                child: Text(
                                  "로그인",
                                  style: TextStyle(fontSize: 24),
                                ),
                              )),
                          SizedBox(
                            height: 40.0,
                          ),

                          // 회원가입 버튼
                          ButtonTheme(
                              minWidth: 100.0,
                              height: 50.0,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed(Routes.register);
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    minimumSize: Size(200, 50),
                                    backgroundColor: Colors.white70),
                                child: Text("회원가입",),
                              ))
                        ],
                      );
                    })),
              ))
            ],
          ),
        ),
      ),
    );
  }
  void setMessage(text) {
    loginMessageEnable = 1.0;
    loginMessage = text;
  }
}

void showSnackBar(BuildContext context, Text text) {
  final snackBar = SnackBar(
    content: text,
    backgroundColor: Color.fromARGB(255, 75, 75, 75),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
