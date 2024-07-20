import 'package:flutter/material.dart';
import 'package:lab8_9_10/app/model/user.dart'; // Import UserModel
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late User user = User.userEmpty(); // Khởi tạo User với giá trị mặc định
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController birthDayController = TextEditingController();
  TextEditingController schoolYearController = TextEditingController();
  TextEditingController schoolKeyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getDataUser(); // Gọi hàm để lấy dữ liệu người dùng từ SharedPreferences
  }

  getDataUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? strUser =
        prefs.getString('user'); // Lấy dữ liệu từ SharedPreferences

    if (strUser != null && strUser.isNotEmpty) {
      try {
        setState(() {
          user = User.fromJson(
              jsonDecode(strUser)); // Parse JSON thành đối tượng User
          fullNameController.text = user.fullName ?? '';
          phoneNumberController.text = user.phoneNumber ?? '';
          genderController.text = user.gender ?? '';
          birthDayController.text = user.birthDay ?? '';
          schoolYearController.text = user.schoolYear ?? '';
          schoolKeyController.text = user.schoolKey ?? '';
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
        title: const Text('Edit Profile'),
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
                backgroundImage: NetworkImage(user.imageURL ?? ''),
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField('Full Name', fullNameController),
            const SizedBox(height: 16),
            _buildTextField('Phone Number', phoneNumberController),
            const SizedBox(height: 16),
            _buildTextField('Gender', genderController),
            const SizedBox(height: 16),
            _buildTextField('Birth Day', birthDayController),
            const SizedBox(height: 16),
            _buildTextField('School Year', schoolYearController),
            const SizedBox(height: 16),
            _buildTextField('School Key', schoolKeyController),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  saveProfileChanges();
                  Navigator.pop(context);
                },
                child: const Text('Save changes'),
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
    user.schoolYear = schoolYearController.text;
    user.schoolKey = schoolKeyController.text;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user.toJson()));

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );
  }
}
