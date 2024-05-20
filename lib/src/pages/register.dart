import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  RegExp idRegex = RegExp(r'^[0-9]{2}-[0-9]{8}$');
  RegExp pwdRegex = RegExp(r'^[0-9a-zA-Z]+$');
  double messageOffstage = 1.0;
  String message = "군번을 입력해주세요.";
  double messageOffstage2 = 1.0;
  String message2 = "비밀번호를 입력해주세요.";

  Future<bool> _callAPI(String idText, String pwdText) async {
    var url = Uri.parse(
      'http://navy-combat-power-management-platform.shop/register.php',
    );
    var response = await Dio().postUri(url, data: {'username': idText, 'pwd': pwdText});
    return response.data;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
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
                          TextField(
                            controller: controller,
                            autofocus: true,
                            decoration: InputDecoration(labelText: '군번'),
                            keyboardType: TextInputType.number,
                            onChanged: (text) {
                              setState((){
                                if (controller.text.isEmpty) {
                                  messageOffstage = 1.0;
                                  message = '군번을 입력해주세요.';
                                } else if(!idRegex.hasMatch(text)){
                                  messageOffstage = 1.0;
                                  message = '군번: 12-12345678 형태가 와야 합니다.';
                                } else {
                                  messageOffstage = 0.0;
                                }
                              });
                            },
                          ),
                          Opacity(
                            opacity: messageOffstage,
                            child: Text(message, style: TextStyle(color: Colors.red)),

                          ),
                          TextField(
                            controller: controller2,
                            decoration: InputDecoration(labelText: '비밀번호'),
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            onChanged: (text) {
                              setState((){
                                if (controller2.text.isEmpty) {
                                  messageOffstage2 = 1.0;
                                  message2 = '비밀번호를 입력해주세요.';
                                } else if(!pwdRegex.hasMatch(text)){
                                  messageOffstage2 = 1.0;
                                  message2 = '비밀번호: 영문 대/소문자, 숫자를 사용해 주세요.';
                                } else {
                                  messageOffstage2 = 0.0;
                                }
                              });
                            },
                          ),
                          Opacity(
                            opacity: messageOffstage2,
                            child: Text(message2, style: TextStyle(color: Colors.red)),
                          ),
                          SizedBox(
                            height: 40.0,
                          ),
                          ButtonTheme(
                              minWidth: 100.0,
                              height: 50.0,
                              child: ElevatedButton(
                                onPressed: () {

                                  if (controller.text.isEmpty) {
                                  } else if (controller2.text.isEmpty) {
                                  } else if(!idRegex.hasMatch(controller.text)){
                                  } else if(!pwdRegex.hasMatch(controller2.text)){
                                  } else {
                                    Future<bool> future = _callAPI(
                                        controller.text, controller2.text);
                                    future.then((val) {
                                      if(val){
                                        Navigator.pop(context, true);
                                        showSnackBar(context, Text('가입 완료'));
                                      } else {
                                        setState((){
                                          messageOffstage = 1.0;
                                          message = '이미 존재하는 아이디입니다.';
                                        });
                                      }
                                    }
                                    ).catchError((error) {
                                      messageOffstage = 1.0;
                                      message = '오류: ${error}';
                                      print('error: ${error}');
                                    });
                                  }},
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    minimumSize: Size(MediaQuery.of(context).size.width, 70),
                                    backgroundColor: Colors.white10),
                                child: Text(
                                  "가입",
                                ),
                              )),
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
}

void showSnackBar(BuildContext context, Text text) {
  final snackBar = SnackBar(
    content: text,
    backgroundColor: Color.fromARGB(255, 75, 75, 75)
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}