import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lab8_9_10/app/data/api.dart';
import 'package:lab8_9_10/app/data/sqlite.dart';
import 'package:lab8_9_10/app/model/cart.dart';
import 'package:intl/intl.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> _handlePayment() async {
    List<Cart> temp = await _databaseHelper.products();
    try {
      await APIRepository().addBill(temp);
      _databaseHelper.clear();
      _showMessage('Thanh toán thành công');
    } catch (e) {
      print("Thanh toán error $e");
      _showMessage('Thanh toán thất bại');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán'),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Chi tiết đơn hàng',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: FutureBuilder<List<Cart>>(
                future: _databaseHelper.products(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text("Không có sản phẩm trong giỏ hàng"),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final itemProduct = snapshot.data![index];
                      return ListTile(
                        title: Text(itemProduct.name),
                        subtitle: Text(
                          'Giá: ${NumberFormat('#,##0').format(itemProduct.price)} VND\nSố lượng: ${itemProduct.count}',
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _handlePayment,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                
                ),
              ),
              child: const Text(
                "Xác nhận thanh toán",
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
