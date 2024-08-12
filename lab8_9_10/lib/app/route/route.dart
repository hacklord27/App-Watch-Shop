import 'package:flutter/material.dart';
import 'package:lab8_9_10/app/page/auth/login.dart';
import 'package:lab8_9_10/app/page/home/home_screen.dart';
import 'package:lab8_9_10/app/page/register.dart';
import 'package:lab8_9_10/mainpage.dart';

class Routes {
  static const String login = '/login';
  static const String home = '/home';
  static const String register = '/register';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case home:
        return MaterialPageRoute(builder: (_) => Mainpage());
      case register:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
