import 'package:flutter/material.dart';
import 'package:lab8_9_10/app/model/user.dart'; // Import UserModel
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MyInfoScreen extends StatefulWidget {
  const MyInfoScreen({super.key});

  @override
  State<MyInfoScreen> createState() => _MyInfoScreenState();
}

class _MyInfoScreenState extends State<MyInfoScreen> {
  late User user = User.userEmpty();

  getDataUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? strUser = prefs.getString('user');

    if (strUser != null && strUser.isNotEmpty) {
      try {
        setState(() {
          user = User.fromJson(jsonDecode(strUser));
        });
      } catch (e) {
        print('Error decoding JSON: $e');
      }
    } else {
      print('No user data found');
    }
  }

  @override
  void initState() {
    super.initState();
    getDataUser();
  }

  void logOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Information'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, '/edit_profile');
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // shareUserInfo();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(user.imageURL ?? ''),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                user.fullName ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                '@${user.fullName ?? ''}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildInfoItem('NumberID', user.idNumber ?? ''),
            _buildInfoItem('Họ và tên ', user.fullName ?? ''),
            _buildInfoItem('Số điện thoại', user.phoneNumber ?? ''),
            _buildInfoItem('Giới tính', user.gender ?? ''),
            _buildInfoItem('Ngày sinh', user.birthDay ?? ''),
            _buildInfoItem('Ngày tạo', user.dateCreated ?? ''),
            const SizedBox(height: 20),
            user.accountId == ''
                ? const SizedBox()
                : ListTile(
                    leading: const Icon(Icons.exit_to_app),
                    title: const Text('Đăng xuất'),
                    onTap: () {
                      logOut(context);
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
