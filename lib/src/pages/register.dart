import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController nameController = TextEditingController();
  TextEditingController birthController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController pwdController = TextEditingController();

  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();

  TextEditingController posController = TextEditingController();

  RegExp nameRegex = RegExp(r'^[0-9a-zA-Zㄱ-ㅎ]+$');
  RegExp dateRegex = RegExp(r'^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
  RegExp idRegex = RegExp(r'^[0-9]{10}$');
  RegExp pwdRegex = RegExp(r'^[0-9a-zA-Z]+$');
  double nameMessageEnable = 1.0;
  String nameMessage = "이름을 입력해주세요.";
  double birthMessageEnable = 1.0;
  String birthMessage = "생년월일을 입력해주세요.";
  double idMessageEnable = 1.0;
  String idMessage = "군번을 입력해주세요.";
  double pwdMessageEnable = 1.0;
  String pwdMessage = "비밀번호를 입력해주세요.";
  double startMessageEnable = 1.0;
  String startMessage = "입대일을 입력해주세요.";
  double endMessageEnable = 1.0;
  String endMessage = "전역일을 입력해주세요.";

  String dropdownValue = '육군';

  bool validName = false;
  bool validBirth = false;
  bool validId = false;
  bool validPwd = false;
  bool validStart = false;
  bool validEnd = false;

  Future<bool> _callAPI(name, birth, id, pwd, start, end, dropdown, pos) async {
    var url = Uri.parse(
      'http://navy-combat-power-management-platform.shop/register.php',
    );
    var response = await Dio().postUri(url, data: {'name': name, 'birth': birth, 'id': id, 'pwd': pwd, 'start': start, 'end': end, 'dropdown': dropdown, 'pos': pos});
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

                          // 이름, 생년월일
                          Row(children: [

                            // 이름 입력 필드
                            Flexible(
                                flex: 1,
                                child: TextField(
                                  controller: nameController,
                                  decoration: decoTheme('이름', '이름'),
                                  keyboardType: TextInputType.emailAddress,
                                  onChanged: (text) {setNameMessage(text);}
                                )),

                            SizedBox(
                              width: 20,
                            ),

                            // 생년월일 입력 필드
                            Flexible(
                                flex: 1,
                                child: TextField(
                                  controller: birthController,
                                  decoration: decoTheme('생년월일', '생년월일 8자리'),
                                  keyboardType: TextInputType.emailAddress,
                                  onChanged: (text) {setBirthMessage(text);}
                                )),
                          ]),

                          // 이름, 생년월일 오류 메시지
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                            // 이름 오류 메시지
                                  Opacity(
                                    opacity: nameMessageEnable,
                                    child: Text(nameMessage,
                                      style: TextStyle(color: Colors.red,),),
                                ),

                            // 생년월일 오류 메시지
                            Opacity(
                                    opacity: birthMessageEnable,
                                    child: Text(birthMessage,
                                      style: TextStyle(color: Colors.red)),
                                ),
                          ]),

                          SizedBox(
                            height: 20,
                          ),

                          // 군번 입력 필드
                          TextField(
                            controller: idController,
                            decoration: decoTheme('군번', '군번 (- 없이 입력하세요)'),
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (text) {setIdMessage(text);}
                          ),

                          // 군번 오류 메시지
                          Opacity(
                            opacity: idMessageEnable,
                            child: Text(idMessage,
                                style: TextStyle(color: Colors.red)),
                          ),

                          SizedBox(
                            height: 10,
                          ),
                          
                          // 비밀번호 입력 필드
                          TextField(
                            controller: pwdController,
                            decoration: decoTheme('비밀번호', '비밀번호'),
                            keyboardType: TextInputType.emailAddress,
                            obscureText: true,
                            onChanged: (text) {setPwdMessage(text);}
                          ),
                          
                          // 비밀번호 오류 메시지
                          Opacity(
                            opacity: pwdMessageEnable,
                            child: Text(pwdMessage,
                                style: TextStyle(color: Colors.red)),
                          ),

                          SizedBox(
                            height: 10,
                          ),

                          // 날짜
                          Row(children: [

                            // 입대일 입력 필드
                            Flexible(
                                flex: 5,
                                child: TextField(
                                  controller: startController,
                                  decoration: decoTheme('입대일', '입대일'),
                                  keyboardType: TextInputType.emailAddress,
                                  onChanged: (text) {setStartMessage(text);}
                                )),

                            SizedBox(
                              width: 20,
                            ),

                            // 날짜 버튼
                            IconButton(
                                onPressed: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2040),
                                  ).then((selectedDate) {
                                    setState(() {
                                      startController.text =
                                      "${selectedDate!.year.toString()}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
                                      startMessageEnable = 0.0;
                                      validStart = true;
                                    });
                                  });
                                },
                                icon: Icon(Icons.calendar_month)),

                            SizedBox(
                              width: 20,
                            ),

                            // 전역일 입력 필드
                            Flexible(
                                flex: 5,
                                child: TextField(
                                  controller: endController,
                                  decoration: decoTheme('전역일', '전역일'),
                                  keyboardType: TextInputType.emailAddress,
                                  onChanged: (text) {setEndMessage(text);}
                                )),

                            SizedBox(
                              width: 20,
                            ),

                            // 날짜 버튼
                            IconButton(
                                onPressed: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2040),
                                  ).then((selectedDate) {
                                    setState(() {
                                      endController.text =
                                      "${selectedDate!.year.toString()}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
                                      endMessageEnable = 0.0;
                                      validEnd = true;
                                    });
                                  });
                                },
                                icon: Icon(Icons.calendar_month))
                          ]),

                          // 입대일, 전역일 오류 메시지
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                // 입대일 오류 메시지
                                Opacity(
                                  opacity: startMessageEnable,
                                  child: Text(startMessage,
                                    style: TextStyle(color: Colors.red,),),
                                ),

                                // 전역일 오류 메시지
                                Opacity(
                                  opacity: endMessageEnable,
                                  child: Text(endMessage,
                                      style: TextStyle(color: Colors.red)),
                                ),
                              ]),

                          SizedBox(
                            height: 20,
                          ),

                          // 군별, 직별
                          Row(children: [

                            // 군별 드랍다운
                            DropdownButton<String>(
                              value: dropdownValue,
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                });
                              },
                              items: <String>['육군', '해군', '공군']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),

                            SizedBox(
                              width: 20,
                            ),

                            // 직별 입력 필드
                            Flexible(
                                flex: 5,
                                child: TextField(
                                  controller: posController,
                                  decoration: decoTheme('직별', '직별'),
                                  keyboardType: TextInputType.emailAddress,
                                )),
                          ]),

                          SizedBox(
                            height: 20,
                          ),

                          // 가입 버튼
                          ButtonTheme(
                              minWidth: 100.0,
                              height: 50.0,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (validName &&
                                      validBirth &&
                                      validId &&
                                      validPwd &&
                                      validStart &&
                                      validEnd) {
                                    Future<bool> future = _callAPI(
                                        nameController.text, birthController.text, idController.text, pwdController.text, startController.text, endController.text, dropdownValue, posController.text);
                                    future.then((val) {
                                      if(val){
                                        Navigator.pop(context, true);
                                        showSnackBar(context, Text('가입 완료'));
                                      } else {
                                        setState((){setIdText('이미 존재하는 아이디입니다.');});
                                      }
                                    }).catchError((error) {
                                      setIdText('오류: $error');
                                      print('error: $error');
                                    });
                                  }},
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    minimumSize: Size(MediaQuery.of(context).size.width, 70),
                                    backgroundColor: Colors.white10),
                                child: Text(
                                  "가입",
                                  style: TextStyle(fontSize: 24),
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
  void setNameText(text) {
    nameMessageEnable = 1.0;
    nameMessage = text;
  }
  void setBirthText(text) {
    birthMessageEnable = 1.0;
    birthMessage = text;
  }
  void setIdText(text) {
    idMessageEnable = 1.0;
    idMessage = text;
  }
  void setPwdText(text) {
    pwdMessageEnable = 1.0;
    pwdMessage = text;
  }
  void setStartText(text) {
    startMessageEnable = 1.0;
    startMessage = text;
  }
  void setEndText(text) {
    endMessageEnable = 1.0;
    endMessage = text;
  }

  bool isDate(text){
    DateFormat format = DateFormat("yyyy-MM-dd");
    try {
      DateTime dateFormat = format.parseStrict(text);
    } catch(e){
      return false;
    }
    return true;
  }
  void setNameMessage(text) {
    setState((){
      validName=false;
      if (nameController.text.isEmpty) {setNameText('이름을 입력해주세요.');}
      else if(!nameRegex.hasMatch(text)){setNameText('이름: 영문 대/소문자, \n    숫자를 사용해 주세요.');}
      else {nameMessageEnable = 0.0;validName=true;}
    });
  }

  void setBirthMessage(text) {
    setState((){
      validBirth=false;
      if (birthController.text.isEmpty) {setBirthText('생년월일을 입력해주세요.');}
      else if(!isDate(text)){setBirthText('날짜: 올바르지 않은 날짜입니다. \n(yyyy-mm-dd)');}
      else {birthMessageEnable = 0.0;validBirth=true;}
    });
  }

  void setIdMessage(text) {
    setState((){
      validId=false;
      if (idController.text.isEmpty) {setIdText('군번을 입력해주세요.');}
      else if(!idRegex.hasMatch(text)){setIdText('군번: 숫자 10자를 입력해주세요.');}
      else {idMessageEnable = 0.0;validId=true;}
    });
  }

  void setPwdMessage(text) {
    setState((){
      validPwd=false;
      if (pwdController.text.isEmpty) {setPwdText('비밀번호를 입력해주세요.');}
      else if(!pwdRegex.hasMatch(text)){setPwdText('비밀번호: 영문 대/소문자, 숫자를 사용해 주세요.');}
      else {pwdMessageEnable = 0.0;validPwd=true;}
    });
  }

  void setStartMessage(text) {
    setState((){
      validStart=false;
      if (startController.text.isEmpty) {setStartText('입대일을 입력해주세요.');}
      else if(!isDate(text)){setStartText('날짜: 올바르지 않은 날짜입니다. \n(yyyy-mm-dd)');}
      else {startMessageEnable = 0.0;validStart=true;}
    });
  }

  void setEndMessage(text) {
    setState((){
      validEnd=false;
      if (endController.text.isEmpty) {setEndText('전역일을 입력해주세요.');}
      else if(!isDate(text)){setEndText('날짜: 올바르지 않은 날짜입니다. \n(yyyy-mm-dd)');}
      else {endMessageEnable = 0.0;validEnd=true;}
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
