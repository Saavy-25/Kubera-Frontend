
import 'dart:convert';
import 'dart:io';
import 'package:flutter_kubera/src/models/receipt.dart';
import 'package:flutter_kubera/src/models/store_product.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_kubera/src/models/test.dart';
import 'package:flutter_kubera/src/models/generic_item.dart';
import 'package:http_parser/http_parser.dart';

class FlaskService {
  // when running on physical device use the ip address of the machine running the server (i.e your laptop )
  static const String baseUrl = 'http://10.136.17.109:5000/flutter';

  // when running on emulator use the following
  // static const String baseUrl = 'http://localhost:5000/flutter';

  Future<Test> fetchTest() async {
    final response = await http.get(Uri.parse('$baseUrl/get_data'));
    if (response.statusCode == 200) {
      return Test.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load test');
    }
  }

  Future<Receipt> processReceipt(File image) async {
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
        return Receipt.fromJson(receiptJson);
      } else {
        throw Exception('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to post data: $e');
    }

  }

  // This api will call gpt to get generic matches to be verified by the user
  Future<Receipt> mapReceipt(Receipt receipt) async {
    try {
        final response = await http.post(
        Uri.parse('$baseUrl/map_receipt'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(receipt.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final receiptJson = jsonResponse['receipt'];
        return Receipt.fromJson(receiptJson);
      }
      else {
        throw Exception('Failed to map receipt: ${response.statusCode}');
      }

    }
    catch (e) {
      throw Exception('Failed to map receipt: $e');
    }
  }

  // This api will post the receipt to mongo after full confirmation (product name and generic name)
  Future<void> postReceipt(Receipt receipt) async {
    final response = await http.post(
      Uri.parse('$baseUrl/post_receipt'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(receipt.toJson()),
    );

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
}