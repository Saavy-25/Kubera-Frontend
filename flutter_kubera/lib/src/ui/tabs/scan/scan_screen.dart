import 'package:flutter/material.dart';
import 'package:flutter_kubera/src/models/receipt.dart';
import 'package:flutter_kubera/src/ui/tabs/scan/receipt_data_confirmation.dart';
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
  Future<Receipt> _processImage(File image) async {
    final processedReceipt = await FlaskService().processReceipt(image);
    return processedReceipt;
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
                  child: ElevatedButton.icon(
                    onPressed: () async { //Go to receipt confirmation page
                      if (_image != null) {
                        final receipt = await _processImage(_image!);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReceiptDataConfirmationScreen(receipt: receipt),
                          ),
                        );
                      } else {
                      // TODO: Show error message
                        print('No image selected');
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