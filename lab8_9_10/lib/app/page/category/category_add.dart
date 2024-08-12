import 'package:flutter/material.dart';
import 'package:lab8_9_10/app/data/api.dart';
import 'package:lab8_9_10/app/model/category.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

class CategoryAdd extends StatefulWidget {
  final bool isUpdate;
  final CategoryModel? categoryModel;
  const CategoryAdd({super.key, this.isUpdate = false, this.categoryModel});

  @override
  State<CategoryAdd> createState() => _CategoryAddState();
}

class _CategoryAddState extends State<CategoryAdd> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String titleText = "";

  Future<void> _onSave() async {
    final name = _nameController.text;
    final description = _descController.text;
    final image = _imageController.text;
    var pref = await SharedPreferences.getInstance();
    await APIRepository().addCategory(
        CategoryModel(id: 0, name: name, imageUrl: image, desc: description),
        pref.getString('accountID').toString(),
        pref.getString('token').toString());
    setState(() {});
    Navigator.pop(context);
  }

  Future<void> _onUpdate(int id) async {
    final name = _nameController.text;
    final description = _descController.text;
    final image = _imageController.text;
    var pref = await SharedPreferences.getInstance();

    await APIRepository().updateCategory(
        id,
        CategoryModel(
            id: widget.categoryModel!.id,
            name: name,
            imageUrl: image,
            desc: description),
        pref.getString('accountID').toString(),
        pref.getString('token').toString());
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    if (widget.categoryModel != null && widget.isUpdate) {
      _nameController.text = widget.categoryModel!.name;
      _descController.text = widget.categoryModel!.desc;
    }
    if (widget.isUpdate) {
      titleText = "Cập nhật thông tin sản phấm";
    } else {
      titleText = "Thêm sản phẩm ";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          titleText,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nhập tên sản phẩm',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _imageController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nhập hình ảnh',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _descController,
              maxLines: 7,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nhập mô tả',
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              height: 45.0,
              child: ElevatedButton(
                onPressed: () {
                  widget.isUpdate
                      ? _onUpdate(widget.categoryModel!.id)
                      : _onSave();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                ),
                child: const Text(
                  'Lưu sản phẩm ',
                  style: TextStyle(
                    fontSize: 16.0,
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
