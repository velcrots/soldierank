import 'package:flutter/material.dart';
import 'package:flutter_ace/routes.dart';
import 'package:flutter_ace/src/binding/init_bindings.dart';
import 'package:flutter_ace/src/pages/main_page/main_page.dart';
import 'package:get/get.dart';
import 'package:flutter_ace/src/pages/login.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('hivebox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      routes: Routes.routes,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            titleTextStyle: TextStyle(color: Colors.black),
          )),
      initialBinding: InitBinding(),
      //home: const App(),
      home: MainPage(),
    );
  }
}
