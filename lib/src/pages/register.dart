import 'package:flutter/material.dart';
import 'package:flutter_ace/services/web_api/api.dart';
import 'package:flutter_ace/widgets/input_deco.dart';
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

  TextEditingController joinController = TextEditingController();
  TextEditingController dischargeController = TextEditingController();

  TextEditingController posController = TextEditingController();

  DateFormat format = DateFormat('yyyy-MM-dd');

  RegExp nameRegex = RegExp(r'^[0-9a-zA-Zㄱ-ㅣ가-힣]+$');
  RegExp birthRegex = RegExp(r'^[0-9]{8}$');
  RegExp idRegex = RegExp(r'^[0-9]{10}$');
  RegExp pwdRegex = RegExp(r'^[0-9a-zA-Z]+$');
  String nameMessage = "이름을 입력해주세요.";
  String birthMessage = "생년월일을 입력해주세요.";
  String idMessage = "군번을 입력해주세요.";
  String pwdMessage = "비밀번호를 입력해주세요.";
  String joinMessage = "입대일을 입력해주세요.";
  String dischargeMessage = "전역일을 입력해주세요.";

  String soldierType = '육군';

  bool isCheck = false;

  bool validName = false;
  bool validBirth = false;
  bool validId = false;
  bool validPwd = false;
  bool validJoin = false;
  bool validDischarge = false;

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
                                  decoration: InputDeco(labelText: '이름', hintText: '이름'),
                                  keyboardType: TextInputType.text,
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
                                  decoration: InputDeco(labelText: '생년월일', hintText: '생년월일 8자리'),
                                  keyboardType: TextInputType.number,
                                  onChanged: (text) {setBirthMessage(text);}
                                )),
                          ]),

                          // 이름, 생년월일 오류 메시지
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                            // 이름 오류 메시지
                                  Opacity(
                                    opacity: validName ? 0.0 : 1.0,
                                    child: Text(nameMessage,
                                      style: TextStyle(color: Colors.red,),),
                                ),

                            // 생년월일 오류 메시지
                            Opacity(
                                    opacity: validBirth ? 0.0 : 1.0,
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
                            decoration: InputDeco(labelText: '군번', hintText: '군번 (- 없이 입력하세요)'),
                            keyboardType: TextInputType.number,
                            onChanged: (text) {setIdMessage(text);}
                          ),

                          // 군번 오류 메시지
                          Opacity(
                            opacity: validId ? 0.0 : 1.0,
                            child: Text(idMessage,
                                style: TextStyle(color: Colors.red)),
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
                            onChanged: (text) {setPwdMessage(text);}
                          ),
                          
                          // 비밀번호 오류 메시지
                          Opacity(
                            opacity: validPwd ? 0.0 : 1.0,
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
                                  controller: joinController,
                                  decoration: InputDeco(labelText: '입대일', hintText: '입대일'),
                                  keyboardType: TextInputType.number,
                                  onChanged: (text) {setJoinMessage(text);}
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
                                      if (selectedDate == null) return;
                                      DateTime date = selectedDate;
                                      String joinFormat = format.format(date);
                                      joinController.text = joinFormat.toString();
                                      setJoinMessage(joinController.text);
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
                                  controller: dischargeController,
                                  decoration: InputDeco(labelText: '전역일', hintText: '전역일'),
                                  keyboardType: TextInputType.number,
                                  onChanged: (text) {setDischargeMessage(text);}
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
                                      if (selectedDate == null) return;
                                      DateTime date = selectedDate;
                                      String dischargeFormat = format.format(date);
                                      dischargeController.text = dischargeFormat.toString();
                                      setDischargeMessage(dischargeController.text);
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
                                  opacity: validJoin ? 0.0 : 1.0,
                                  child: Text(joinMessage,
                                    style: TextStyle(color: Colors.red,),),
                                ),

                                // 전역일 오류 메시지
                                Opacity(
                                  opacity: validDischarge ? 0.0 : 1.0,
                                  child: Text(dischargeMessage,
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
                              value: soldierType,
                              onChanged: (String? newValue) {
                                setState(() {
                                  soldierType = newValue!;
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
                                  decoration: InputDeco(labelText: '직별', hintText: '직별'),
                                  keyboardType: TextInputType.text,
                                )),
                          ]),

                          Padding(
                            padding: const EdgeInsets.only(left: 15, top: 15),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: isCheck,
                                  onChanged: (value) {
                                    setState(() {
                                      isCheck = value!;
                                    });
                                  },
                                ),
                                Text("지휘자")
                              ],
                            ),
                          ),

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
                                      validJoin &&
                                      validDischarge) {
                                    ProfileAPIService().register(
                                        nameController.text,
                                        birthController.text,
                                        idController.text,
                                        pwdController.text,
                                        joinController.text,
                                        dischargeController.text,
                                        soldierType,
                                        posController.text,
                                        isCheck).then((val) {
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
    validName = false;
    nameMessage = text;
  }
  void setBirthText(text) {
    validBirth = false;
    birthMessage = text;
  }
  void setIdText(text) {
    validId = false;
    idMessage = text;
  }
  void setPwdText(text) {
    validPwd = false;
    pwdMessage = text;
  }
  void setJoinText(text) {
    validJoin = false;
    joinMessage = text;
  }
  void setDischargeText(text) {
    validDischarge = false;
    dischargeMessage = text;
  }

  bool isDate(text){
    try {
      DateTime dateFormat = format.parseStrict(text);
    } catch(e){
      return false;
    }
    return true;
  }
  void compareStartEnd(){
    try {
      DateTime startFormat = format.parseStrict(joinController.text);
      DateTime endFormat = format.parseStrict(dischargeController.text);
      if(!endFormat.isAfter(startFormat)){setJoinText('날짜: 전역일이 이후여야 합니다.');validJoin=false;}
      else {validJoin=true;}
    } catch(e){
      print(e);
    }
  }
  void setNameMessage(text) {
    setState((){
      validName=false;
      if (nameController.text.isEmpty) {setNameText('이름을 입력해주세요.');}
      else if(!nameRegex.hasMatch(text)){setNameText('이름: 영문 대/소문자, \n    숫자를 사용해 주세요.');}
      else {validName=true;}
    });
  }

  void setBirthMessage(text) {
    setState((){
      validBirth=false;
      if (birthController.text.isEmpty) {setBirthText('생년월일을 입력해주세요.');}
      else if(!birthRegex.hasMatch(text)){setBirthText('숫자 8자를 입력해주세요.');}
      else {validBirth=true;}
    });
  }

  void setIdMessage(text) {
    setState((){
      validId=false;
      if (idController.text.isEmpty) {setIdText('군번을 입력해주세요.');}
      else if(!idRegex.hasMatch(text)){setIdText('군번: 숫자 10자를 입력해주세요.');}
      else {validId=true;}
    });
  }

  void setPwdMessage(text) {
    setState((){
      validPwd=false;
      if (pwdController.text.isEmpty) {setPwdText('비밀번호를 입력해주세요.');}
      else if(!pwdRegex.hasMatch(text)){setPwdText('비밀번호: 영문 대/소문자, 숫자를 사용해 주세요.');}
      else {validPwd=true;}
    });
  }

  void setJoinMessage(text) {
    setState((){
      validJoin=false;
      if (joinController.text.isEmpty) {setJoinText('입대일을 입력해주세요.');}
      else if(!isDate(text)){setJoinText('날짜: (yyyy-mm-dd)');}
      else {validJoin=true;}
      compareStartEnd();
    });
  }

  void setDischargeMessage(text) {
    setState((){
      validDischarge=false;
      if (dischargeController.text.isEmpty) {setDischargeText('전역일을 입력해주세요.');}
      else if(!isDate(text)){setDischargeText('날짜: (yyyy-mm-dd)');}
      else {validDischarge=true;}
      compareStartEnd();
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
