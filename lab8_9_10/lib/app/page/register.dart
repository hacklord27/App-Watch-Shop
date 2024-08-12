import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:lab8_9_10/app/page/auth/login.dart';
import 'package:lab8_9_10/app/data/api.dart';
import 'package:lab8_9_10/app/model/register.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

 Future<String> register() async {
  try {
    var signupData =Signup(
      accountID: _accountController.text,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
    );

    var response = await APIRepository().register(signupData);
    return response; // Giả sử response là một chuỗi trả về từ API
  } on DioError catch (e) {
    if (e.response != null) {
      // Xử lý DioError với phản hồi
      print("DioError: ${e.response!.statusCode} - ${e.response!.statusMessage}");
      return e.response!.data.toString();
    } else {
      // Xử lý các trường hợp DioError khác
      print("DioError: ${e.message}");
      return "Đã xảy ra lỗi không xác định.";
    }
  } catch (e) {
    // Xử lý lỗi chung
    print("Error: $e");
    return "Đã xảy ra lỗi không xác định.";
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
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
                  const SizedBox(height: 20),
                  Image.asset(
                    'assets/images/logoapp.png',
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image),
                    width: 300,
                    height: 270,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Đăng ký',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(_accountController, 'Tài khoản', Icons.person),
                  _buildTextField(_passwordController, 'Mật khẩu', Icons.lock),
                  _buildTextField(_confirmPasswordController, 'Xác nhận Mật khẩu', Icons.lock),
                  _buildRegisterButton(),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
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
                          "Bạn đã có tài khoản? ",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        Text(
                          "Đăng nhập",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 230, 178, 81),
                            fontSize: 16,
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

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        obscureText: label.toLowerCase().contains('mật khẩu'),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          filled: true,
          fillColor: const Color.fromARGB(255, 249, 249, 249),
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          String response = await register();
          if (response == "ok") {
            // Đăng ký thành công
            print("Đăng ký thành công");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          } else {
            // Xử lý lỗi
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Đăng ký thất bại"),
                  content: Text(response), // Hiển thị thông báo lỗi từ API
                  actions: <Widget>[
                    TextButton(
                      child: const Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 230, 178, 81),
          foregroundColor: Colors.white,
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
          child: Text(
            "Đăng ký",
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      ),
    );
  }
}
