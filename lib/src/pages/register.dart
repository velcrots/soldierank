import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController idController = TextEditingController();
  TextEditingController pwdController = TextEditingController();

  RegExp idRegex = RegExp(r'^[0-9]{2}-[0-9]{8}$');
  RegExp pwdRegex = RegExp(r'^[0-9a-zA-Z]+$');
  double idMessageEnable = 1.0;
  String idMessage = "군번을 입력해주세요.";
  double pwdMessageEnable = 1.0;
  String pwdMessage = "비밀번호를 입력해주세요.";

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

                          // 군번 입력 필드
                          TextField(
                            controller: idController,
                            autofocus: true,
                            decoration: InputDecoration(labelText: '군번', hintText: "군번 (- 없이 입력하세요)"),
                            keyboardType: TextInputType.number,
                            onChanged: (text) {idMessage3(text);},
                          ),
                          
                          // 군번 오류 메시지
                          Opacity(
                            opacity: idMessageEnable,
                            child: Text(idMessage, style: TextStyle(color: Colors.red)),
                          ),
                          
                          // 군번 입력 필드
                          TextField(
                            controller: idController,
                            autofocus: true,
                            decoration: InputDecoration(labelText: '군번', hintText: "군번 (- 없이 입력하세요)"),
                            keyboardType: TextInputType.number,
                            onChanged: (text) {setIdMessage(text);},
                          ),
                          
                          // 군번 오류 메시지
                          Opacity(
                            opacity: idMessageEnable,
                            child: Text(idMessage, style: TextStyle(color: Colors.red)),
                          ),
                          
                          // 비밀번호 입력 필드
                          TextField(
                            controller: pwdController,
                            decoration: InputDecoration(labelText: '비밀번호'),
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            onChanged: (text) {setPwdMessage(text);},
                          ),
                          
                          // 비밀번호 오류 메시지
                          Opacity(
                            opacity: pwdMessageEnable,
                            child: Text(pwdMessage, style: TextStyle(color: Colors.red)),
                          ),
                          SizedBox(
                            height: 40.0,
                          ),
                          
                          // 가입 버튼
                          ButtonTheme(
                              minWidth: 100.0,
                              height: 50.0,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (idController.text.isNotEmpty &&
                                  pwdController.text.isNotEmpty &&
                                  idRegex.hasMatch(idController.text) &&
                                  pwdRegex.hasMatch(pwdController.text)) {
                                    Future<bool> future = _callAPI(idController.text, pwdController.text);
                                    future.then((val) {
                                      if(val){
                                        Navigator.pop(context, true);
                                        showSnackBar(context, Text('가입 완료'));
                                      } else {
                                        setState((){setMessage('이미 존재하는 아이디입니다.');});
                                      }
                                    }
                                    ).catchError((error) {
                                      setMessage('오류: $error');
                                      print('error: $error');
                                    });
                                  }},
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    minimumSize: Size(MediaQuery.of(context).size.width, 70),
                                    backgroundColor: Colors.white10),
                                child: Text("가입",),
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
  void setMessage(text) {
    idMessageEnable = 1.0;
    idMessage = text;
  }
  void setMessage2(text) {
    pwdMessageEnable = 1.0;
    pwdMessage = text;
  }
  void idMessage3(text) {
    setState((){
      if (idController.text.isEmpty) {setMessage('군번을 입력해주세요.');}
      else if(!idRegex.hasMatch(text)){setMessage('군번: 12-12345678 형태가 와야 합니다.');}
      else {idMessageEnable = 0.0;}
    });
  }

  void setIdMessage(text) {
    setState((){
      if (idController.text.isEmpty) {setMessage('군번을 입력해주세요.');}
      else if(!idRegex.hasMatch(text)){setMessage('군번: 12-12345678 형태가 와야 합니다.');}
      else {idMessageEnable = 0.0;}
    });
  }

  void setPwdMessage(text) {
    setState((){
      if (pwdController.text.isEmpty) {setMessage2('비밀번호를 입력해주세요.');}
      else if(!pwdRegex.hasMatch(text)){setMessage2('비밀번호: 영문 대/소문자, 숫자를 사용해 주세요.');}
      else {pwdMessageEnable = 0.0;}
    });
  }
}



void showSnackBar(BuildContext context, Text text) {
  final snackBar = SnackBar(
    content: text,
    backgroundColor: Color.fromARGB(255, 75, 75, 75)
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}