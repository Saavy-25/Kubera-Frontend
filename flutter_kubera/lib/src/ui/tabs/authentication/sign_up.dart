import 'package:flutter/material.dart';

import '../../../models/test.dart';
import '../../../services/flask_service.dart';
import 'package:flutter_kubera/src/core/error_dialog.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late Future<Test> futureTest;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    futureTest = FlaskService().fetchTest();
  }

  // Process the image using Flask API
  Future<void> _signup(String username, String password) async {
    try {
      setState(() {
        _isLoading = true;
      });
      await FlaskService().signup(username, password);
      setState(() {
        _isLoading = false;
      });
      return;
    }
    catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Error registering user. Please try again.');
    }
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

  // Sample code: https://github.com/toliksadovnichiy/Flutter-lab4/blob/08aadb19b0c20f5e439dc20173b5f6b03e4e4b1c/lib/parse_json_widget.dart
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kubera")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: _usernameController,
              //onSubmitted: fetchSearchResults,
              decoration: InputDecoration(
                hintText: "username",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a username';
                }
                return null;
              }
            ),
            TextFormField(
              controller: _passwordController,
              //onSubmitted: fetchSearchResults,
              decoration: InputDecoration(
                hintText: "password",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a password';
                }
                return null;
              }
            ),
            ElevatedButton(
                onPressed: () async {
                  _signup(_usernameController.text, _passwordController.text);
                  },
                child: Text('Sign Up'),
              ),
          ],
        ),
      ),
    );
  }
}
