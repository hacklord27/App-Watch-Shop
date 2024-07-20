import 'package:flutter/material.dart';
import 'package:lab8_9_10/app/model/bill.dart';
import 'package:lab8_9_10/app/model/cart.dart';
import 'package:lab8_9_10/app/data/sqlite.dart'; // Import DatabaseHelper class

class HistoryDetail extends StatelessWidget {
  final List<BillDetailModel> bill;
  final DatabaseHelper _databaseService =
      DatabaseHelper(); // Initialize DatabaseHelper

  HistoryDetail({Key? key, required this.bill}) : super(key: key);

  Future<void> _onSave(BillDetailModel data) async {
    await _databaseService.insertProduct(Cart(
      productID: data.productId,
      name: data.productName,
      des: "",
      price: data.price,
      img: data.imageUrl,
      count: 1,
    ));
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = bill.fold(0, (sum, item) => sum + item.total);
    int totalQuantity = bill.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chi tiết hóa đơn',
          style: const TextStyle(fontSize: 26, color: Colors.black),
        ),
        backgroundColor: Colors.cyan,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: bill.length,
              itemBuilder: (context, index) {
                var data = bill[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Card(
                    elevation: 6.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.productName,
                            style: const TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              image: DecorationImage(
                                image: NetworkImage(data.imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.price_check, color: Colors.red),
                              const SizedBox(width: 5),
                              Text(
                                'Giá: ${data.price} VND',
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(Icons.attach_money,
                                  color: Colors.green),
                              const SizedBox(width: 5),
                              Text(
                                'Tổng: ${data.total} VND',
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Divider(
                            color: Colors.grey,
                            height: 1,
                            thickness: 1,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () async {
                                  await _onSave(data);
                                },
                                icon: const Icon(Icons.shopping_cart),
                                label: const Text('Mua lại',
                                    style: TextStyle(fontSize: 18)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.cyanAccent,
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  // Xử lý khi bấm nút này
                                },
                                icon: const Icon(Icons.share),
                                label: const Text('Chia sẻ',
                                    style: TextStyle(fontSize: 18)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.greenAccent,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            color: Colors.white,
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tổng tiền: $totalPrice VND',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Tổng số sản phẩm: $totalQuantity',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
