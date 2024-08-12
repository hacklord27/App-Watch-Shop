// lib/app/page/auth/edit_profile.dart

import 'package:flutter/material.dart';
import 'package:lab8_9_10/app/model/user.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late User user = User.userEmpty();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController birthDayController = TextEditingController();


  @override
  void initState() {
    super.initState();
    getDataUser();
  }

  getDataUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? strUser = prefs.getString('user');
    
    if (strUser != null && strUser.isNotEmpty) {
      try {
        setState(() {
          user = User.fromJson(jsonDecode(strUser));
          fullNameController.text = user.fullName ?? '';
          phoneNumberController.text = user.phoneNumber ?? '';
          genderController.text = user.gender ?? '';
          birthDayController.text = user.birthDay ?? '';
        });
      } catch (e) {
        print('Error decoding JSON: $e');
      }
    } else {
      print('No user data found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa hồ sơ'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: user.imageURL != null && user.imageURL!.isNotEmpty
                    ? NetworkImage(user.imageURL!)
                    : null,
                child: user.imageURL == null || user.imageURL!.isEmpty
                    ? const Icon(Icons.person, size: 50)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField('Họ và tên', fullNameController),
            const SizedBox(height: 16),
            _buildTextField('Số điện thoại', phoneNumberController),
            const SizedBox(height: 16),
            _buildTextField('Giới tính', genderController),
            const SizedBox(height: 16),
            _buildTextField('Ngày sinh', birthDayController),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  saveProfileChanges();
                  Navigator.pop(context);
                },
                child: const Text('Lưu thay đổi'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller,
      {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  void saveProfileChanges() async {
    user.fullName = fullNameController.text;
    user.phoneNumber = phoneNumberController.text;
    user.gender = genderController.text;
    user.birthDay = birthDayController.text;



    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user.toJson()));

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cật nhật hồ sơ thành công')),
    );
  }
}
