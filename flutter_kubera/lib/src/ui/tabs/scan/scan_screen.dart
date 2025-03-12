import 'package:flutter/material.dart';
import 'package:flutter_kubera/src/core/error_dialog.dart';
import 'package:flutter_kubera/src/models/receipt.dart';
import 'package:flutter_kubera/src/ui/tabs/scan/product_name_confirmation.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../services/flask_service.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  //Take photo with camera
  Future<void> _takePicture() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  //Choose image from gallery
  Future<void> _choosePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  // Process the image using Flask API
  Future<Receipt> _processReceipt(File image) async {
    setState(() {
      _isLoading = true;
    });
    final processedReceipt = await FlaskService().processReceipt(image);
    setState(() {
      _isLoading = false;
    });
    return processedReceipt;
  }

  // Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorDialog(message: message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kubera')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Scan Receipt',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: Center(
                child: _image == null
                    ? const Text(
                        'No image selected. Please make sure the photo is clear and the receipt is smoothed as much as possible!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Image.file(
                          _image!,
                          fit: BoxFit.contain,
                          width: double.infinity,
                        ),
                      ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _takePicture,
                      child: const Text('Take Photo'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _choosePhoto,
                      child: const Text('Choose Photo'),
                    ),
                  ),
                ],
              ),
            ),

            if (_image != null)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: SizedBox(
                  width: double.infinity,
                  child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton.icon(
                    onPressed: () async { //Go to receipt confirmation page
                      if (_image != null) {
                        // final receipt = await _processImage(_image!);
                        // TODO: Remove this hardcoded receipt and uncomment the above line before PR!!
                        final receipt = Receipt.fromJson(
                          {
                            "_id":"",
                            "storeName":"TRADER JOE'S",
                            "storeAddress":"1234 ABCD ST",
                            "date":"2025-01-30",
                            "totalReceiptPrice":"9.48",
                            "products":[
                              {
                                "_id":"",
                                "lineItem":"YOGURT GREEK PLAIN 32 OZ",
                                "count":"1",
                                "totalPrice":5.49,
                                "pricePerCount":5.49,
                                "storeName":"TRADER JOE'S",
                                "storeProductName":"Plain Greek Yogurt", // This hypothetically comes from gpt (this is what we want the user to confirm mainly)
                                "genericMatches":[
                                  "Greek Yogurt",
                                  "Yogurt",
                                  "Dairy"
                                ]
                              },
                              {
                                "_id":"",
                                "lineItem":"KIMBAP KOREAN SEAWEED RI",
                                "count":"2",
                                "totalPrice":3.99,
                                "pricePerCount":1.99,
                                "storeName":"TRADER JOE'S",
                                "storeProductName":"Korean Kimbap",
                                "genericMatches":["Kimbap"],
                              },
                            ]
                          }
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductNameConfirmationScreen(receipt: receipt),
                          ),
                        );
                      } else {
                        _showErrorDialog('No image selected. Please select an image first.');
                      }
                    },
                    label: const Text('Proceed'),
                    icon: const Icon(Icons.arrow_forward),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
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