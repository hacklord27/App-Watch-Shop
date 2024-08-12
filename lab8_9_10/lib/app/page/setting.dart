import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lab8_9_10/app/data/sharepre.dart';
import 'package:lab8_9_10/app/page/account/edit_user_info.dart';
import 'package:lab8_9_10/app/page/account/my_user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user.dart'; // Đã import UserModel

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User user = User.userEmpty();

  getDataUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? strUser = pref.getString('user'); // Thay đổi thành String?

    if (strUser != null && strUser.isNotEmpty) {
      try {
        user = User.fromJson(jsonDecode(strUser));
        setState(() {});
        print('User Information:');
        print('NumberID: ${user.idNumber}');
        print('Fullname: ${user.fullName}');
        print('Phone Number: ${user.phoneNumber}');
        print('Gender: ${user.gender}');
        print('birthDay: ${user.birthDay}');
        print('schoolYear: ${user.schoolYear}');
        print('schoolKey: ${user.schoolKey}');
        print('dateCreated: ${user.dateCreated}');
        print('imageURL: ${user.imageURL}');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Profile
              _buildUserProfile(context),
              const SizedBox(height: 20),
              // Menu Options
              _buildMenuOption(
                context,
                'Hồ sơ người dùng',
                Icons.account_circle_outlined,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyInfoScreen()),
                  );
                },
              ),

              // _buildMenuOption(
              //   context,
              //   'Danh bạ chuyển tiền',
              //   Icons.person_add_alt_1_outlined,
              //   () {
              //     // Navigator.pushNamed(context, '/saved_beneficiary');
              //   },
              // ),
              _buildMenuOption(
                context,
                'Face ID/Touch ID',
                Icons.fingerprint_outlined,
                () {
                  // Navigator.pushNamed(context, '/face_id_touch_id');
                },
              ),
              // _buildMenuOption(
              //   context,
              //   'Bảo mật 2 lớp',
              //   Icons.security_outlined,
              //   () {
              //     // Navigator.pushNamed(context, '/two_factor_authentication');
              //   },
              // ),
              _buildMenuOption(context, 'Đăng xuất', Icons.logout_outlined, () {
                logOut(context);
              }),

              const SizedBox(height: 20),

              // More Options
              const Text(
                'More',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              _buildMenuOption(
                context,
                'Hỗ trợ',
                Icons.help_outline,
                () {
                  // Navigator.pushNamed(context, '/help_support');
                },
              ),
              _buildMenuOption(
                context,
                'Giới thiệu về ứng dụng',
                Icons.info_outline,
                () {
                  // Navigator.pushNamed(context, '/about_app');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget hiển thị thông tin người dùng
  Widget _buildUserProfile(BuildContext context) {
    return user != null
        ? Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(146, 202, 221, 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                // User Avatar
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(user.imageURL ?? ''),
                ),
                const SizedBox(width: 16.0),
                // User Name
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '@${user.fullName ?? ''}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Edit Icon
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfileScreen()),
                    );
                  },
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }

  // Widget cho menu option
  Widget _buildMenuOption(BuildContext context, String title, IconData icon,
      VoidCallback onPressed) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onPressed,
    );
  }
}
