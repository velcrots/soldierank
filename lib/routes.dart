import 'package:flutter/material.dart';
import 'package:flutter_ace/src/app.dart';
import 'package:flutter_ace/src/pages/login.dart';
import 'package:flutter_ace/src/pages/register.dart';

class Routes {
  Routes._();

  static const String login = '/login';
  static const String register = '/register';
  static const String app = '/app';

  static final routes = <String, WidgetBuilder>{
    login: (BuildContext context) => Login(),
    register: (BuildContext context) => Register(),
    app: (BuildContext context) => App(),
  };
}