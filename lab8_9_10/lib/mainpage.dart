import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lab8_9_10/app/data/sharepre.dart';
import 'package:lab8_9_10/app/model/user.dart';
import 'package:lab8_9_10/app/page/cart/cart_screen.dart';
import 'package:lab8_9_10/app/page/category/category_list.dart';
import 'package:lab8_9_10/app/page/history/history_screen.dart';
import 'package:lab8_9_10/app/page/home/home_screen.dart';
import 'package:lab8_9_10/app/page/product/product_list.dart';
import 'package:lab8_9_10/app/page/setting.dart';
// ignore: depend_on_referenced_packages
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// ignore: depend_on_referenced_packages
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
        return const HomeBuilder();
      case 1:
        return const HistoryScreen();
      case 2:
        return const CartScreen();
      case 3:
        return const ProfilePage();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
               
                Color.fromARGB(255, 235, 184, 17),
                Color.fromARGB(255, 235, 184, 17).withOpacity(0.5),
               
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
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
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('History'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shop),
              title: const Text('Cart'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(2);
              },
            ),
            ListTile(
              leading: const Icon(Icons.category_outlined),
              title: const Text('Category'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(0);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CategoryList()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.production_quantity_limits_outlined),
              title: const Text('Product'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(0);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProductList()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.pages),
              title: const Text('Page3'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(0);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProductList()),
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
                    title: const Text('Logout'),
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
        backgroundColor: const  Color.fromARGB(255, 235, 184, 17),
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: _onItemTapped,
        letIndexChange: (index) => true,
      ),
      body: _loadWidget(_selectedIndex),
    );
  }
}
