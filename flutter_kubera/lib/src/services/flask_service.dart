
import 'dart:convert';
import 'dart:io';
import 'package:flutter_kubera/src/models/receipt.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_kubera/src/models/test.dart';

import 'package:http_parser/http_parser.dart';

class FlaskService {
  // when running on physical device use the ip address of the machine running the server (i.e your laptop )
  // static const String baseUrl = 'http://10.188.80.50:5000/flutter';

  // when running on emulator use the following
  static const String baseUrl = 'http://localhost:5000/flutter';

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
}