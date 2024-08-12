import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lab8_9_10/app/data/api.dart';
import 'package:lab8_9_10/app/data/sqlite.dart';
import 'package:lab8_9_10/app/model/cart.dart';
import 'package:lab8_9_10/app/model/category.dart';
import 'package:lab8_9_10/app/model/product.dart';
import 'package:lab8_9_10/app/page/product/product_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeBuilder extends StatefulWidget {
  const HomeBuilder({Key? key}) : super(key: key);

  @override
  State<HomeBuilder> createState() => _HomeBuilderState();
}

class _HomeBuilderState extends State<HomeBuilder> {
  final DatabaseHelper _databaseService = DatabaseHelper();
  late Future<List<ProductModel>> _products;
  late Future<List<CategoryModel>> _categories;
  int _selectedCategoryId = 0;

  @override
  void initState() {
    super.initState();
    _products = _getAllProducts();
    _categories = _getCategories();
  }

  Future<List<ProductModel>> _getAllProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await APIRepository().getProductAdmin(
      prefs.getString('accountID').toString(),
      prefs.getString('token').toString(),
    );
  }

  Future<List<CategoryModel>> _getCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await APIRepository().getCategory(
      prefs.getString('accountID').toString(),
      prefs.getString('token').toString(),
    );
  }

  Future<void> _onSave(ProductModel pro) async {
    _databaseService.insertProduct(Cart(
      productID: pro.id,
      name: pro.name,
      des: pro.description,
      price: pro.price,
      img: pro.imageUrl,
      count: 1,
    ));
    setState(() {});
  }

  Future<void> _onCategorySelected(int categoryId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedCategoryId = categoryId;
      _products = APIRepository().getProductByCategoryId(
        prefs.getString('accountID').toString(),
        prefs.getString('token').toString(),
        categoryId,
      );
    });
  }

  Future<void> _onAllProductsSelected() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedCategoryId = 0;
      _products = _getAllProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductModel>>(
      future: _products,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(
            child: Text('Không có sản phẩm nào'),
          );
        }
        for(var item in snapshot.data!){
          print('image produc ${item.name}${item.imageUrl}');
        }
        return Scaffold(
          body: Container(
            height: 1000,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Color.fromRGBO(243, 246, 246, 1).withOpacity(0.5),
                  Colors.transparent,
                ],
                radius: 1.0,
                center: Alignment.center,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 170.0,
                      child: CarouselSlider(
                        items: [
                          'assets/images/banner5.jpg',
                          'assets/images/banner10.png',
                          'assets/images/banner11.png',
                          'assets/images/banner12.png',
                        ].map((imagePath) {
                          return Container(
                            margin: const EdgeInsets.all(5.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                imagePath,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }).toList(),
                        options: CarouselOptions(
                          height: 170.0,
                          enlargeCenterPage: true,
                          autoPlay: true,
                          aspectRatio: 16 / 9,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 1000),
                          viewportFraction: 0.95,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: _onAllProductsSelected,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _selectedCategoryId == 0
                                  ? const Color.fromARGB(255, 235, 184, 17)
                                  : Colors.grey[800],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(200),
                              ),
                            ),
                            child: Text(
                              'Tất cả',
                              style: TextStyle(
                                color: _selectedCategoryId == 0
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: Container(
                              height: 40,
                              child: FutureBuilder<List<CategoryModel>>(
                                future: _categories,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Center(
                                      child: Text('Lỗi: ${snapshot.error}'),
                                    );
                                  } else if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return const Center(
                                      child: Text('Không có danh mục nào.'),
                                    );
                                  } else {
                                    return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        final category = snapshot.data![index];
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: GestureDetector(
                                            onTap: () => _onCategorySelected(
                                                category.id),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 8,
                                                horizontal: 16,
                                              ),
                                              decoration: BoxDecoration(
                                                color: _selectedCategoryId ==
                                                        category.id
                                                    ? Colors.cyan
                                                    : Colors.grey[800],
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                category.name,
                                                style: TextStyle(
                                                  color: _selectedCategoryId ==
                                                          category.id
                                                      ? Colors.white
                                                      : Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        childAspectRatio: 0.575,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final itemProduct = snapshot.data![index];
                        return _buildProduct(itemProduct, context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProduct(ProductModel pro, BuildContext context) {
    print('image:${pro.imageUrl}');
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailScreen(product: pro),
                ),
              );
            },
            child: Container(
              height: 185,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: NetworkImage(pro.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      pro.name,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Center(
                    child: Text(
                      '${NumberFormat('#,##0').format(pro.price)} VND',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.normal,
                        color: Color.fromARGB(255, 7, 7, 7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                _onSave(pro);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 230, 178, 81),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Mua ngay',
                style: TextStyle(
                  color: Color.fromARGB(255, 10, 10, 10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: HomeBuilder(),
      ),
    );
  }
}
