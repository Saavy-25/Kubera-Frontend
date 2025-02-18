import 'package:flutter/material.dart';
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

  //Upload image from gallery/files
  Future<void> _uploadPhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  // Process the image using Flask API
  Future<void> _processImage(File image) async {
    // Implement the logic to send the image to your Flask API
    // and handle the response.

    final response = await FlaskService().processReceipt(image);

    if (response.statusCode == 200) {
      print('Image uploaded successfully');
    } else {
      print('Failed to upload image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Receipt'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: _takePicture,
                child: const Text('Take photo'),
              ),
              ElevatedButton(
                onPressed: _uploadPhoto,
                child: const Text('Upload photo'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_image != null) {
                    _processImage(_image!);
                  } else {
                    print('No image selected');
                  }
                },
                child: const Text('Post photo'),
              ),
              const SizedBox(height: 20),
              _image == null
                  ? const Text('No image selected.')
                  : SafeArea(
                      child: Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Image.file(
                            _image!,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
