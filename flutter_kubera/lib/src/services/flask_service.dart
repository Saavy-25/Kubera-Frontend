
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_kubera/src/models/dashboard.dart';
import 'package:flutter_kubera/src/models/scanned_receipt.dart';
import 'package:flutter_kubera/src/models/scanned_line_item.dart';
import 'package:flutter_kubera/src/models/shopping_list.dart';
import 'package:flutter_kubera/src/models/store_product.dart';
import 'package:flutter_kubera/src/models/user.dart';
import 'package:flutter_kubera/src/ui/tabs/settings/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_kubera/src/models/test.dart';
import 'package:flutter_kubera/src/models/generic_item.dart';
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';

class FlaskService {
  // when running on physical device use the ip address of the machine running the server (i.e your laptop )
  // static const String baseUrl = 'http://10.136.26.249:8000/flutter';

  // when running on emulator use the following
  static const String baseUrl = 'http://localhost:8000/flutter';

  Future<Test> fetchTest() async {
    final response = await http.get(Uri.parse('$baseUrl/get_data'));
    if (response.statusCode == 200) {
      return Test.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load test');
    }
  }

  Future<ScannedReceipt> processReceipt(File image) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/process_receipt'),
    );
      request.files.add(await http.MultipartFile.fromPath(
        'file', 
        image.path,
        contentType: MediaType('image', 'jpeg')
    ));

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(responseBody);
        final receiptJson = jsonResponse['receipt'];
        return ScannedReceipt.fromJson(receiptJson);
      } else {
        throw Exception('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to post data: $e');
    }

  }

  // This api will call gpt to get generic matches to be verified by the user
  Future<ScannedReceipt> mapReceipt(ScannedReceipt receipt) async {
    
        final response = await http.post(
        Uri.parse('$baseUrl/map_receipt'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(receipt.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final receiptJson = jsonResponse['receipt'];
        return ScannedReceipt.fromJson(receiptJson);
      }else if (response.statusCode == 400) {
        final jsonResponse = jsonDecode(response.body);
        final errorMessage = jsonResponse['message'];
        throw Exception(errorMessage);
      }
      else {
        throw Exception('Failed to map receipt: ${response.statusCode}');
      }

  }

  // This api will post the receipt to mongo after full confirmation (product name and generic name)
  Future<void> postReceipt(BuildContext context, ScannedReceipt receipt) async {
    Map<String, String>requestHeaders =  userCookieHeader(context);
    requestHeaders['Content-Type'] = 'application/json';

    final response = await http.post(
      Uri.parse('$baseUrl/post_receipt'),
      headers: requestHeaders,
      body: jsonEncode(receipt.toJson()),
    );

    if (response.statusCode == 401) {
      throw Exception(jsonDecode(response.body)['message']);
    }
    if (response.statusCode != 200) {
      throw Exception('Failed to send receipt: ${response.statusCode}');
    }
  }

  Future<List<GenericItem>> searchItems(String query) async {
    if (query.isEmpty) return [];

    final response = await http.get(Uri.parse('$baseUrl/search_generic?query=$query'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return List<GenericItem>.from(data.map((item) => GenericItem.fromJson(item)));
    } else {
      throw Exception('Failed to fetch search results');
    }
  }

  Future<List<StoreProduct>> fetchStoreProducts(String genericId) async {
    if (genericId.isEmpty) return [];

    final response = await http.get(
      Uri.parse('$baseUrl/get_storeProducts/$genericId'),
    );

    final data = jsonDecode(response.body);
    
    if (response.statusCode == 200) {
      if (data is List) {
        return List<StoreProduct>.from(data.map((item) => StoreProduct.fromJson(item)));
      } else {
        return List.empty();
      }
    } 
    
    else {
      throw Exception('Failed to fetch store products.');
    }
  }

  Future<StoreProduct> fetchProduct(String productId) async {
    final response = await http.get(Uri.parse('$baseUrl/get_productDetails/$productId'));

    if (response.statusCode == 200) {
      final productJson = jsonDecode(response.body);
      return StoreProduct.fromJson(productJson);
    } else {
      throw Exception('Failed to fetch product');
    }
  }
  
  Future<DashboardData?> fetchDashboardData(BuildContext context) async {
    final response = await http.get(Uri.parse(
      '$baseUrl/get_dashboard_data'), 
      headers: userCookieHeader(context),
    );

  if (response.statusCode == 200) {
    final jsonBody = jsonDecode(response.body);
    if (jsonBody is Map<String, dynamic> && jsonBody.containsKey('message')) { // No receipts scanned
      return null;
    }
    return DashboardData.fromJson(jsonBody);
  } else if (response.statusCode == 401) {  // User is not authenticated
    return null;
  } else {
    throw Exception("Failed to load dashboard data: ${response.statusCode}");
  }
}

  // This api will add a store product to a user's shopping list
  Future<void> addItemToList(String listId, String productId, String productName) async {
    var body = {
      'listId': listId,
      'storeProductId': productId,
      'productName': productName,
    };

    final response = await http.put(
      Uri.parse('$baseUrl/add_item_to_list'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add product to shopping list');
    }
  }

  Future<void> removeItemFromList(String listId, String productId) async {
    var body = {
      'listId': listId,
      'storeProductId': productId,
    };

    final response = await http.put(
      Uri.parse('$baseUrl/remove_item_from_list'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove product from shopping list');
    }
  }

  Future<void> toggleListItem(String listId, String productId) async {
    var body = {
      'listId': listId,
      'storeProductId': productId,
    };

    final response = await http.put(
      Uri.parse('$baseUrl/toggle_list_item'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to toggle list item');
    }
  }

  Future<ShoppingList> getShoppingList(String listId) async {
    final response = await http.get(Uri.parse('$baseUrl/get_list_data/$listId'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return ShoppingList.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to fetch shopping list');
    }
  }

  // This api will fetch the user's shopping list list of shopping list ID's and names
  Future<List<ShoppingList>> getUsersShoppingLists(BuildContext context) async {
    Map<String, String> headers = userCookieHeader(context);
    headers['Content-Type'] = 'application/json';
    final response = await http.get( 
      Uri.parse('$baseUrl/get_user_lists'), 
      headers: headers
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return List<ShoppingList>.from(data.map((item) => ShoppingList.fromJson(item)));
    } else {
      throw Exception('Failed to get users shopping lists');
    }
  }

  Future<void> createShoppingList(String listName, BuildContext context) async {
    Map<String, String> headers = userCookieHeader(context);
    headers['Content-Type'] = 'application/json';
    final response = await http.post(
      Uri.parse('$baseUrl/create_list'),
      headers: headers,
      body: jsonEncode({'listName': listName}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create shopping list');
    }
  }

  Future<void> deleteShoppingList(String listId, BuildContext context) async {
    Map<String, String> headers = userCookieHeader(context);
    headers['Content-Type'] = 'application/json';
    final response = await http.delete(
      Uri.parse('$baseUrl/delete_list'),
      headers: headers,
      body: jsonEncode({'listId': listId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete shopping list');
    }
  }

  // This api will post the receipt to mongo after full confirmation (product name and generic name)
  Future<String> signup(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    final jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 400) { // user input error
      return jsonResponse['message'];
    }
    else if (response.statusCode == 200){
      return "Success";
    }
    else {
      throw Exception('Failed to sign up: ${response.statusCode}');
    }
  }

  Future<String> login(BuildContext context, String username, String password) async {

    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    final jsonResponse = jsonDecode(response.body);
    
    if (response.statusCode == 400) { // user input error
        return jsonResponse['message'];
    }
    else if (response.statusCode == 200){
      User user = User.fromJson(jsonResponse['user details'], parseCookies(response.headers));

      if(context.mounted) context.read<AuthState>().login(user);
      return "Success";
    }
    else {
      throw Exception('Failed to login: ${response.statusCode}');
    }
  }

  Future<void> logout(BuildContext context) async {
    
    final response = await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: userCookieHeader(context),
    );

    if (response.statusCode == 401){
      if(context.mounted) context.read<AuthState>().logout();
      throw Exception('Unauthorized: Session out of sync');
    }
    else if (response.statusCode != 200) {
      if(context.mounted) context.read<AuthState>().logout();
      throw Exception('Failed to logout user');
    }
    else{
      if(context.mounted) context.read<AuthState>().logout();
    }
  }

  List<Cookie> parseCookies(Map<String, String> headers) {
    List<Cookie> cookies = [];
      headers.forEach((k, v) {
        if (k == 'set-cookie') {
          cookies.add(Cookie.fromSetCookieValue(v));
        }
      });
    return cookies;
  }

  Map<String,String> userCookieHeader(BuildContext context) {
    // reference for setting cookies in header: https://stackoverflow.com/questions/52241089/how-do-i-make-an-http-request-using-cookies-on-flutter

    Map<String, String> headers = {};
    List<Cookie> cookies = context.read<AuthState>().userSession();
    List<String> cookieHeaders = [];

    // extract only the name and value from the cookie
    for(final cookie in cookies) {
      cookieHeaders.add(cookie.toString());
    }

    headers['Cookie'] = cookieHeaders.join('; ');

    return headers;
  }
}
