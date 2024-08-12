import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:lab8_9_10/app/model/bill.dart';
import 'package:lab8_9_10/app/model/cart.dart';
import 'package:lab8_9_10/app/model/category.dart';
import 'package:lab8_9_10/app/model/product.dart';
import 'package:lab8_9_10/app/model/register.dart';
import 'package:lab8_9_10/app/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class API {
  final Dio _dio = Dio();
  String baseUrl = "http://10.21.14.52:3000"; // Đảm bảo URL này đúng

  API() {
    _dio.options.baseUrl = "$baseUrl/api";
  }

  Dio get sendRequest => _dio;
}

class APIRepository {
  API api = API();

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  Options getOptions(String token) {
    return Options(headers: {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*',
      'Authorization': 'Bearer $token'
    });
  }

  Future<String> register(Signup signupData) async {
    try {
      final response = await api.sendRequest.post(
        'http://10.21.14.52:3000/api/register', 
        data: {
          'accountID': signupData.accountID,
          'password': signupData.password,
          'confirmPassword': signupData.confirmPassword,
        },
      );

      if (response.statusCode == 200) {
        if (response.data['status'] == 'ok') {
          return 'ok';
        } else {
          return response.data['message'];
        }
      } else {
        return 'Đã xảy ra lỗi không xác định.';
      }
    } catch (e) {
      if (e is DioError && e.response != null) {
        return e.response!.data.toString();
      } else {
        return 'Đã xảy ra lỗi không xác định.';
      }
    }
  }

  Future<String> login(String accountID, String password) async {
    try {
      final body = {'accountID': accountID, 'password': password};
      Response res = await api.sendRequest.post(
         'http://10.21.14.52:3000/api/login',
        data: body,
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
      );

      if (res.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', res.data['token']);
        return res.data['token'];
      } else {
        return "login fail";
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> current() async {
    try {
      String token = await getToken();
      Response res = await api.sendRequest.get(
          'http://10.21.14.52:3000/api/user',
        options: getOptions(token),
      );
      return res.data;
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<List<CategoryModel>> getCategory(String accountID, String string) async {
    try {
      String token = await getToken();
      Response res = await api.sendRequest.get(
        'http://10.21.14.52:3000/Category/getList?accountID=$accountID',
        options: getOptions(token),
      );

      if (res.statusCode == 200) {
        return res.data
            .map<CategoryModel>((e) => CategoryModel.fromJson(e))
            .toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (ex) {
      print('Error fetching categories: $ex');
      rethrow;
    }
  }

  Future<bool> addCategory(CategoryModel data, String accountID, String string) async {
    try {
      String token = await getToken();
      final body = {
        'name': data.name,
        'description': data.desc,
        'imageURL': data.imageUrl,
        'accountID': accountID,
      };
      Response res = await api.sendRequest.post(
        'http://10.21.14.52:3000/addCategory',
        options: getOptions(token),
        data: body,
      );
      return res.statusCode == 200;
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<bool> updateCategory(int categoryID, CategoryModel data, String accountID, String string) async {
    try {
      String token = await getToken();
      final body = {
        'id': categoryID,
        'name': data.name,
        'description': data.desc,
        'imageURL': data.imageUrl,
        'accountID': accountID,
      };
      Response res = await api.sendRequest.put(
        'http://10.21.14.52:3000/updateCategory',
        options: getOptions(token),
        data: body,
      );
      return res.statusCode == 200;
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<bool> removeCategory(int categoryID, String accountID, String string) async {
    try {
      String token = await getToken();
      final body = {'categoryID': categoryID, 'accountID': accountID};
      Response res = await api.sendRequest.delete(
        'http://10.21.14.52:3000/removeCategory',
        options: getOptions(token),
        data: body,
      );
      return res.statusCode == 200;
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<List<ProductModel>> getProduct(String accountID, String string) async {
    try {
      String token = await getToken();
      Response res = await api.sendRequest.get(
        'http://10.21.14.52:3000/Product/getList?accountID=$accountID',
        options: getOptions(token),
      );
      
      return res.data
          .map<ProductModel>((e) => ProductModel.fromJson(e))
          .toList();
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<List<ProductModel>> getProductAdmin(String accountID, String string) async {
    try {
      String token = await getToken();
      Response res = await api.sendRequest.get(
        'http://10.21.14.52:3000/Product/getListAdmin?accountID=$accountID',
        options: getOptions(token),
      );
      return res.data
          .map<ProductModel>((e) => ProductModel.fromJson(e))
          .toList();
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

Future<List<ProductModel>> getProductByCategoryId(String accountID, String token, int categoryId) async {
  try {
    Response res = await api.sendRequest.get(
      'http://10.21.14.52:3000/Product/getListByCatId',
      queryParameters: {'categoryID': categoryId, 'accountID': accountID},
      options: getOptions(token), // Đảm bảo token là String
    );
    return res.data.map<ProductModel>((e) => ProductModel.fromJson(e)).toList();
  } catch (ex) {
    print(ex);
    rethrow;
  }
}


  Future<bool> addProduct(ProductModel data, String string) async {
    try {
      String token = await getToken();
      final body = {
        'name': data.name,
        'description': data.description,
        'imageUrl': data.imageUrl,
        'Price': data.price,
        'CategoryID': data.categoryId,
      };
      Response res = await api.sendRequest.post(
        'http://10.21.14.52:3000/addProduct',
        options: getOptions(token),
        data: body,
      );
      return res.statusCode == 200;
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<bool> updateProduct(ProductModel data, String accountID, String string) async {
    try {
      String token = await getToken();
      final body = {
        'id': data.id,
        'name': data.name,
        'description': data.description,
        'imageUrl': data.imageUrl,
        'Price': data.price,
        'categoryID': data.categoryId,
        'accountID': accountID,
      };
      Response res = await api.sendRequest.put(
        'http://10.21.14.52:3000/updateProduct',
        options: getOptions(token),
        data: body,
      );
      return res.statusCode == 200;
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<bool> removeProduct(int productID, String accountID, String string) async {
    try {
      String token = await getToken();
      final body = {'productID': productID, 'accountID': accountID};
      Response res = await api.sendRequest.delete(
        'http://10.21.14.52:3000/removeProduct',
        options: getOptions(token),
        data: body,
      );
      return res.statusCode == 200;
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<bool> addBill(List<Cart> products) async {
    try {
      String token = await getToken();
      print("token ===>$token");

      List<Map<String, dynamic>> productsJson = products.map((product) => product.toMap()).toList();
      Response res = await api.sendRequest.post(
        'http://10.21.14.52:3000/Order/addBill',
        options: getOptions(token),
        data: productsJson,
      );
      return res.statusCode == 200;
    } on DioException catch (ex) {
      if(ex.response?.statusCode == 400){
        print("Loi 400 ==> ${ex}");
      }
      print(ex);
      rethrow;
    }
  }

  Future<dynamic> getHistory() async {
    try {
      String token = await getToken();
      Response res = await api.sendRequest.get(
        'http://10.21.14.52:3000/Bill/getHistory',
        options: getOptions(token),
      );
      return res.data;
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<List<BillDetailModel>> getHistoryDetail(String billID, String string) async {
    try {
      String token = await getToken();
      Response res = await api.sendRequest.post(
        'http://10.21.14.52:3000/Bill/getByID?billID=$billID',
        options: getOptions(token),
      );
      return res.data
          .map<BillDetailModel>((e) => BillDetailModel.fromJson(e))
          .toList();
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<bool> removeBill(int billID) async {
    try {
      String token = await getToken();
      Response res = await api.sendRequest.delete(
        'http://10.21.14.52:3000/Bill/remove',
        options: getOptions(token),
        queryParameters: {'billID': billID},
      );
      return res.statusCode == 200;
    } catch (ex) {
      print("ERROR -------> ${ex}");
      rethrow;
    }
  }
}
