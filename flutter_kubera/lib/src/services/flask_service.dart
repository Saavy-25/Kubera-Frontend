
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_kubera/src/models/test.dart';

import 'package:http_parser/http_parser.dart';

class FlaskService {
  // when running on physical device use the ip address of your machine
  static const String baseUrl = 'http://10.188.80.234:5000/flutter';

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

  Future<http.StreamedResponse> processReceipt(File image) async {
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
      return response;
    } catch (e) {
      throw Exception('Failed to post data: $e');
    }

  }
}