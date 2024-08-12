import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lab8_9_10/app/route/route.dart'; // Import Routes
import '../register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Dio _dio = Dio();

  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      String accountID = _usernameController.text.trim();
      String password = _passwordController.text.trim();

      try {
        final response = await _dio.post(
          'http://10.21.14.52:3000/api/login', // URL của API đăng nhập
          data: {
            'accountID': accountID,
            'password': password,
          },
        );

        if (response.data['status'] == 'ok') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('token', response.data['token']);
          prefs.setString('accountID', accountID);

          Navigator.pushReplacementNamed(context, Routes.home); // Sử dụng pushReplacementNamed
        } else {
          _showErrorDialog('Tài khoản hoặc mật khẩu không đúng. Vui lòng thử lại.');
        }
      } catch (e) {
        print('Login error: $e');
        _showErrorDialog('Đăng nhập thất bại. Vui lòng đăng nhập lại.');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: const Text(
            'Đăng nhập thất bại',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6A1B9A), // Màu tím
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Màu cyan
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Color.fromRGBO(246, 229, 167, 1),
                  Colors.white70,
                ],
                radius: 1.0,
                center: Alignment.center,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Image.asset(
                    'assets/images/logoapp.png',
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.image),
                    width: 300,
                    height: 270,
                  ),
                  const Text(
                    "C'OK WATCH SHOP",
                    style: TextStyle(fontSize: 30),
                  ),
                  const SizedBox(height: 30),
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 249, 249, 249),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextFormField(
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              labelText: 'Tài khoản',
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập tài khoản của bạn';
                              }
                              return null;
                            },
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Mật khẩu',
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập mật khẩu của bạn';
                              }
                              return null;
                            },
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: login,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(150, 50),
                            backgroundColor: const Color.fromARGB(255, 230, 178, 81),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 100.0),
                            child: Text(
                              "Đăng nhập",
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const RegisterScreen()),
                            );
                          },
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Bạn chưa có tài khoản? ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              Text(
                                "Đăng ký ngay",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 168, 41, 41),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
