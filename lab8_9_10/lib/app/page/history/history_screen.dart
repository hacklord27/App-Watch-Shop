import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lab8_9_10/app/data/api.dart';
import 'package:lab8_9_10/app/model/bill.dart';
import 'package:lab8_9_10/app/page/history/history_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Future<List<dynamic>> _getBills() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await APIRepository()
        .getHistory();
  }
  String formatDate(int timestamp) {
  if(timestamp == 0){
    return 'No data date';
  }
  // Convert timestamp to DateTime
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

  // Format DateTime to string
  String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);

  return formattedDate;
}

  void _removeBill(int billID) async {
    bool success = await APIRepository().removeBill(billID);
    if (success) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Xóa hóa đơn thành công!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Xóa hóa đơn thất bại!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: _getBills(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Không có dữ liệu'),
            );
          }
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final itemBill = snapshot.data![index];
                return _billWidget(itemBill, context, index + 1);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _billWidget(dynamic bill, BuildContext context, int orderNumber) {
    return InkWell(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var temp = await APIRepository()
            .getHistoryDetail(bill.id, prefs.getString('token').toString());
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => HistoryDetail(bill: temp)));
      },
      child: Card(
        elevation: 4.0,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.cyan,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  orderNumber.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bill['id'].toString(),
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "Id:${bill['id']}",
                      style: const TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      '${NumberFormat('#,##0').format(bill['total'])} VND',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Ngày tạo: ${formatDate(bill['dateCreated'] ?? 0)}',
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _removeBill(bill['id']);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
