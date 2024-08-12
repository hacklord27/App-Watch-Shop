import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lab8_9_10/app/data/sharepre.dart';
import 'package:lab8_9_10/app/model/user.dart';
import 'package:lab8_9_10/app/page/auth/login.dart';
import 'package:lab8_9_10/app/page/cart/cart_screen.dart';
import 'package:lab8_9_10/app/page/category/category_list.dart';
import 'package:lab8_9_10/app/page/history/history_screen.dart';
import 'package:lab8_9_10/app/page/home/home_screen.dart';
import 'package:lab8_9_10/app/page/product/product_list.dart';
import 'package:lab8_9_10/app/page/setting.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({Key? key}) : super(key: key);

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  User user = User.userEmpty();
  int _selectedIndex = 0;

  getDataUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? strUser = pref.getString('user');

    if (strUser != null && strUser.isNotEmpty) {
      try {
        user = User.fromJson(jsonDecode(strUser));
        setState(() {});
      } catch (e) {
        print('Error parsing user data: $e');
      }
    } else {}
  }

  @override
  void initState() {
    super.initState();
    getDataUser();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String getTitle(int index) {
    switch (index) {
      case 0:
        return 'C OK Watch ';
      case 1:
        return 'Lịch sử mua hàng';
      case 2:
        return 'Giỏ hàng';
      case 3:
        return 'Cài đặt';
      default:
        return 'C OK Watch';
    }
  }

  Widget _loadWidget(int index) {
    switch (index) {
      case 0:
        return HomeScreen();
      case 1:
        return HistoryScreen();
      case 2:
        return CartScreen();
      case 3:
        return ProfilePage();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          centerTitle: true,
          title: Text(
            getTitle(_selectedIndex),
            style: const TextStyle(fontSize: 26, color: Colors.black),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(146, 202, 221, 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    user.imageURL!.isNotEmpty
                        ? CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(
                              user.imageURL!,
                            ),
                          )
                        : const SizedBox(),
                    const SizedBox(height: 8),
                    Text(user.fullName ?? ''),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Trang chủ'),
                onTap: () {
                  Navigator.pop(context);
                  _onItemTapped(0);
                },
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Lịch sử mua hàng'),
                onTap: () {
                  Navigator.pop(context);
                  _onItemTapped(1);
                },
              ),
              ListTile(
                leading: const Icon(Icons.shop),
                title: const Text('Giỏ hàng'),
                onTap: () {
                  Navigator.pop(context);
                  _onItemTapped(2);
                },
              ),
              ListTile(
                leading: const Icon(Icons.category_outlined),
                title: const Text('Danh mục'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CategoryList()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.production_quantity_limits_outlined),
                title: const Text('Sản phẩm'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProductList()),
                  );
                },
              ),
               ListTile(
                 leading: const Icon(Icons.pages),
                 title: const Text('Đăng xuất'),
                 onTap: () {
                   Navigator.pop(context);
                   Navigator.push(
                     context,
                     MaterialPageRoute(builder: (context) => const LoginScreen()),
                   );
                 },
              ),
              const Divider(
                color: Colors.black,
              ),
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
        bottomNavigationBar: CurvedNavigationBar(
          index: _selectedIndex,
          height: 60.0,
          items: const <Widget>[
            Icon(Icons.home, size: 30),
            Icon(Icons.history, size: 30),
            Icon(Icons.shop, size: 30),
            Icon(Icons.person, size: 30),
          ],
          color: Colors.white,
          buttonBackgroundColor: Colors.white,
          backgroundColor: const Color.fromARGB(255, 235, 184, 17),
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 600),
          onTap: _onItemTapped,
          letIndexChange: (index) => true,
        ),
        body: _loadWidget(_selectedIndex),
      ),
    );
  }
}

void logOut(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => LoginScreen()));
}


