import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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

  Future<int> _callAPI(String idText, String pwdText) async {
    var url = Uri.parse(
      'http://navy-combat-power-management-platform.shop/get.php',
    );
    var response = await Dio().postUri(url, data: {'username': idText, 'pwd': pwdText});
    return response.data;
  }


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
                            decoration: decoTheme('군번', '군번 (- 없이 입력하세요)'),
                            keyboardType: TextInputType.number,
                          ),

                          SizedBox(
                            height: 10,
                          ),

                          // 비밀번호 입력 필드
                          TextField(
                            controller: pwdController,
                            decoration: decoTheme('비밀번호', '비밀번호'),
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
                                  Future<int> future = _callAPI(idController.text, pwdController.text);
                                  future.then((val) {
                                    if (val == 1) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  MainPage(idController.text)));
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
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              RegisterPage()));
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

class MainPage extends StatelessWidget {
  String userId = '';
  MainPage(this.userId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return App(userId);
  }
}

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Register();
  }
}


InputDecoration decoTheme(title, placeholder) {
  InputDecoration deco = InputDecoration(
    labelText: title,
    hintText: placeholder,
    labelStyle: TextStyle(color: Colors.grey),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(width: 1, color: Colors.grey),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(width: 1, color: Colors.grey),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
  );
  return deco;
}