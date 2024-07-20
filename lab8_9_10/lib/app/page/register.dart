import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:lab8_9_10/app/page/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:lab8_9_10/app/data/api.dart';
import 'package:lab8_9_10/app/model/register.dart';
import 'package:lab8_9_10/app/page/auth/login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int _gender = 0;
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _numberIDController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _schoolKeyController = TextEditingController();
  final TextEditingController _schoolYearController = TextEditingController();
  final TextEditingController _birthDayController = TextEditingController();
  final TextEditingController _imageURLController = TextEditingController();

  Future<String> register() async {
    try {
      String response = await APIRepository().register(Signup(
        accountID: _accountController.text,
        birthDay: _birthDayController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        fullName: _fullNameController.text,
        phoneNumber: _phoneNumberController.text,
        schoolKey: _schoolKeyController.text,
        schoolYear: _schoolYearController.text,
        gender: getGender(),
        imageUrl: _imageURLController.text,
        numberID: _numberIDController.text,
      ));
      return response;
    } on DioError catch (e) {
      if (e.response != null) {
        // Handle DioError with response
        print(
            "DioError: ${e.response!.statusCode} - ${e.response!.statusMessage}");
        return e.response!.data.toString();
      } else {
        // Handle other DioError scenarios
        print("DioError: ${e.message}");
        return "Unknown error occurred.";
      }
    } catch (e) {
      // Handle generic error
      print("Error: $e");
      return "Unknown error occurred.";
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
                  Color.fromRGBO(0, 255, 255, 1).withOpacity(0.5),
                  Colors.transparent,
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
                    width: 100,
                    height: 50,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Thông tin Đăng ký',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                      _accountController, 'Tài khoản', Icons.person),
                  _buildTextField(_passwordController, 'Mật khẩu', Icons.lock),
                  _buildTextField(_confirmPasswordController,
                      'Xác nhận Mật khẩu', Icons.lock),
                  _buildTextField(
                      _fullNameController, 'Họ và Tên', Icons.person_outline),
                  _buildTextField(_numberIDController, 'Số CMND',
                      Icons.format_list_numbered),
                  _buildTextField(
                      _phoneNumberController, 'Số điện thoại', Icons.phone),
                  _buildTextField(
                      _birthDayController, 'Ngày sinh', Icons.date_range),
                  _buildTextField(
                      _schoolYearController, 'Năm học', Icons.school),
                  _buildTextField(
                      _schoolKeyController, 'Mã năm học', Icons.school),
                  const SizedBox(height: 16),
                  _buildGenderSelection(),
                  const SizedBox(height: 16),
                  _buildTextField(
                      _imageURLController, 'URL hình ảnh', Icons.image),
                  const SizedBox(height: 20),
                  _buildRegisterButton(),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
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
                            color: Colors.cyan, // Màu cyan
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

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
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

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Giới tính", style: TextStyle(fontSize: 16)),
        RadioListTile<int>(
          title: const Text('Nam'),
          value: 1,
          groupValue: _gender,
          onChanged: (value) {
            setState(() {
              _gender = value!;
            });
          },
        ),
        RadioListTile<int>(
          title: const Text('Nữ'),
          value: 2,
          groupValue: _gender,
          onChanged: (value) {
            setState(() {
              _gender = value!;
            });
          },
        ),
        RadioListTile<int>(
          title: const Text('Khác'),
          value: 3,
          groupValue: _gender,
          onChanged: (value) {
            setState(() {
              _gender = value!;
            });
          },
        ),
      ],
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
          backgroundColor: Colors.cyan, // Màu nền của nút
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

  String getGender() {
    if (_gender == 1) {
      return "Nam";
    } else if (_gender == 2) {
      return "Nữ";
    } else {
      return "Khác";
    }
  }
}
