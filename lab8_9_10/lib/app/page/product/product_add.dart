// import 'package:flutter/material.dart';
// import 'package:lab8_9_10/app/data/api.dart';
// import 'package:lab8_9_10/app/model/category.dart';
// import 'package:lab8_9_10/app/model/product.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ProductAdd extends StatefulWidget {
//   final bool isUpdate;
//   final ProductModel? productModel;

//   const ProductAdd({Key? key, this.isUpdate = false, this.productModel})
//       : super(key: key);

//   @override
//   State<ProductAdd> createState() => _ProductAddState();
// }

// class _ProductAddState extends State<ProductAdd> {
//   String? selectedCategoryId;
//   List<CategoryModel> categories = [];
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _desController = TextEditingController();
//   final TextEditingController _priceController = TextEditingController();
//   final TextEditingController _imgController = TextEditingController();

//   Future<void> _onSave() async {
//     final name = _nameController.text;
//     final des = _desController.text;
//     final price = double.tryParse(_priceController.text) ?? 0.0;
//     final img = _imgController.text;
//     final catId = int.tryParse(selectedCategoryId ?? '0') ?? 0;
//     var pref = await SharedPreferences.getInstance();
//     await APIRepository().addProduct(
//       ProductModel(
//         id: 0,
//         name: name,
//         imageUrl: img,
//         categoryId: catId,
//         categoryName: '',
//         price: price,
//         description: des,
//       ),
//       pref.getString('token').toString(),
//     );
//     setState(() {});
//     Navigator.pop(context);
//   }

//   Future<void> _onUpdate() async {
//     final name = _nameController.text;
//     final des = _desController.text;
//     final price = double.tryParse(_priceController.text) ?? 0.0;
//     final img = _imgController.text;
//     final catId = int.tryParse(selectedCategoryId ?? '0') ?? 0;
//     var pref = await SharedPreferences.getInstance();
//     await APIRepository().updateProduct(
//       ProductModel(
//         id: widget.productModel!.id,
//         name: name,
//         imageUrl: img,
//         categoryId: catId,
//         categoryName: '',
//         price: price,
//         description: des,
//       ),
//       pref.getString('accountID').toString(),
//       pref.getString('token').toString(),
//     );
//     setState(() {});
//     Navigator.pop(context);
//   }

//   Future<void> _fetchCategories() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var temp = await APIRepository().getCategory(
//       prefs.getString('accountID').toString(),
//       prefs.getString('token').toString(),
//     );
//     setState(() {
//       selectedCategoryId = temp.isNotEmpty ? temp.first.id.toString() : null;
//       categories = temp;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _fetchCategories();

//     if (widget.productModel != null && widget.isUpdate) {
//       _nameController.text = widget.productModel!.name;
//       _desController.text = widget.productModel!.description;
//       _priceController.text = widget.productModel!.price.toString();
//       _imgController.text = widget.productModel!.imageUrl;
//       selectedCategoryId = widget.productModel!.categoryId.toString();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Colors.cyan,
//                 Colors.cyanAccent,
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//         centerTitle: true,
//         title: const Text(
//           "Thêm sản phẩm mới",
//           style: TextStyle(fontSize: 26, color: Colors.black),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             const Text(
//               'Tên sản phẩm:',
//               style: TextStyle(
//                 fontSize: 20.0,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _nameController,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 hintText: 'Nhập tên sản phẩm',
//               ),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Giá:',
//               style: TextStyle(
//                 fontSize: 20.0,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _priceController,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 hintText: 'Nhập giá',
//               ),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Ảnh:',
//               style: TextStyle(
//                 fontSize: 20.0,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _imgController,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 hintText: 'Nhập URL ảnh',
//               ),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Mô tả:',
//               style: TextStyle(
//                 fontSize: 20.0,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _desController,
//               maxLines: 5,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 hintText: 'Nhập mô tả',
//               ),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Danh mục:',
//               style: TextStyle(
//                 fontSize: 20.0,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 10),
//             DropdownButtonFormField<String>(
//               value: selectedCategoryId,
//               items: categories.map((item) {
//                 return DropdownMenuItem<String>(
//                   value: item.id.toString(),
//                   child: Text(
//                     item.name,
//                     style: const TextStyle(fontSize: 20),
//                   ),
//                 );
//               }).toList(),
//               onChanged: (item) {
//                 setState(() {
//                   selectedCategoryId = item;
//                 });
//               },
//             ),
//             const SizedBox(height: 20),
//             SizedBox(
//               height: 50.0,
//               child: ElevatedButton(
//                 onPressed: () {
//                   widget.isUpdate ? _onUpdate() : _onSave();
//                 },
//                 style: ButtonStyle(
//                   backgroundColor:
//                       MaterialStateProperty.all<Color>(Colors.cyan),
//                 ),
//                 child: const Text(
//                   'Lưu',
//                   style: TextStyle(
//                     fontSize: 18.0,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lab8_9_10/app/data/api.dart';
import 'package:lab8_9_10/app/model/category.dart';
import 'package:lab8_9_10/app/model/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductAdd extends StatefulWidget {
  final bool isUpdate;
  final ProductModel? productModel;

  const ProductAdd({Key? key, this.isUpdate = false, this.productModel})
      : super(key: key);

  @override
  State<ProductAdd> createState() => _ProductAddState();
}

class _ProductAddState extends State<ProductAdd> {
  String? selectedCategoryId;
  List<CategoryModel> categories = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _desController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  //String? _image;

  // Future<void> _pickImage() async {
  //   final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

  //   if (pickedFile != null) {
  //     setState(() {
  //       _image = File(pickedFile.path);
  //     });
  //   }
  // }

  Future<void> _onSave() async {
    final name = _nameController.text;
    final des = _desController.text;
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final catId = int.tryParse(selectedCategoryId ?? '0') ?? 0;
    final image = _imageController.text;
    var pref = await SharedPreferences.getInstance();
    await APIRepository().addProduct(
      ProductModel(
        id: 0,
        name: name,
        imageUrl: image,
        categoryId: catId,
        categoryName: '',
        price: price,
        description: des,
      ),
      pref.getString('token').toString(),
    );
    setState(() {});
    Navigator.pop(context);
  }

  Future<void> _onUpdate() async {
    final name = _nameController.text;
    final des = _desController.text;
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final catId = int.tryParse(selectedCategoryId ?? '0') ?? 0;
        final image = _imageController.text;

    var pref = await SharedPreferences.getInstance();
    await APIRepository().updateProduct(
      ProductModel(
        id: widget.productModel!.id,
        name: name,
        imageUrl: image,
        categoryId: catId,
        categoryName: '',
        price: price,
        description: des,
      ),
      pref.getString('accountID').toString(),
      pref.getString('token').toString(),
    );
    setState(() {});
    Navigator.pop(context);
  }

  Future<void> _fetchCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var temp = await APIRepository().getCategory(
      prefs.getString('accountID').toString(),
      prefs.getString('token').toString(),
    );
    setState(() {
      selectedCategoryId = temp.isNotEmpty ? temp.first.id.toString() : null;
      categories = temp;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchCategories();

    if (widget.productModel != null && widget.isUpdate) {
      _nameController.text = widget.productModel!.name;
      _desController.text = widget.productModel!.description;
      _priceController.text = widget.productModel!.price.toString();
      selectedCategoryId = widget.productModel!.categoryId.toString();
    }
  }

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
        title: Text(
          widget.isUpdate ? "Cập nhật sản phẩm" : "Thêm sản phẩm mới",
          style: const TextStyle(fontSize: 26, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Tên sản phẩm:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nhập tên sản phẩm',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Giá:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nhập giá',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ảnh:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            _imageController.text.isNotEmpty
                ? Image.network(
                    _imageController.text,
                    height: 150,
                  )
                : const SizedBox(),
            TextField(
              controller: _imageController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nhập link ảnh',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Mô tả:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _desController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nhập mô tả',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Danh mục:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedCategoryId,
              items: categories.map((item) {
                return DropdownMenuItem<String>(
                  value: item.id.toString(),
                  child: Text(
                    item.name,
                    style: const TextStyle(fontSize: 20),
                  ),
                );
              }).toList(),
              onChanged: (item) {
                setState(() {
                  selectedCategoryId = item;
                });
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 50.0,
              child: ElevatedButton(
                onPressed: () {
                  widget.isUpdate ? _onUpdate() : _onSave();
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.cyan),
                ),
                child: const Text(
                  'Lưu',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
