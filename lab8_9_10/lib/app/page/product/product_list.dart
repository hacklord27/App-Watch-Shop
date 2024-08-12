import 'package:flutter/material.dart';
import 'package:lab8_9_10/app/page/product/product_add.dart';
import 'package:lab8_9_10/app/page/product/product_data.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.cyan,
                Colors.cyanAccent,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          "Danh sách sản phẩm",
          style: const TextStyle(fontSize: 26, color: Colors.black),
        ),
      ),
      body: const Center(child: ProductBuilder()),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan,
        onPressed: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (_) => const ProductAdd(),
                  fullscreenDialog: true,
                ),
              )
              .then((_) => setState(() {}));
        },
        tooltip: 'Thêm mới',
        child: const Icon(Icons.add),
      ),
    );
  }
}
