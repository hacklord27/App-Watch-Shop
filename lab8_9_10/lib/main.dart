import 'package:flutter/material.dart';
import 'package:lab8_9_10/app/page/auth/login.dart';
import 'package:lab8_9_10/app/route/route.dart';
import 'package:lab8_9_10/app/page/home/home_screen.dart';
import 'package:lab8_9_10/mainpage.dart';  // Thêm import Mainpage

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: Routes.generateRoute,
      home: LoginScreen(), // Đặt Mainpage làm trang chủ
    );
  }
}
