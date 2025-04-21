import 'package:flutter/material.dart';
import 'package:flutter_kubera/src/models/test.dart';
import '../../../../services/flask_service.dart';
import 'package:flutter_kubera/src/core/error_dialog.dart';

// class reference: https://medium.com/@pratham.patil_23302/flutter-fundamentals-crafting-a-login-signup-page-e6e518457457

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late Future<Test> futureTest;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureTest = FlaskService().fetchTest();
  }

  // Process the image using Flask API
  Future<void> _signup(BuildContext context, String username, String password) async {
    try {
      String status = await FlaskService().signup(username, password);
      
      if(status == "Success"){
        if(context.mounted) await FlaskService().login(context, username, password);
        if(context.mounted) Navigator.pop(context);
      }
      else{
        _showErrorDialog(status);
      }
    }
    catch (e) {
      _showErrorDialog("Sorry, an unexpected error occured. Please try again.");
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

    @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Kubera")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            TextFormField(
              controller: _usernameController,
              //onSubmitted: fetchSearchResults,
              decoration: InputDecoration(
                hintText: "Enter a new username",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
              )
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              //onSubmitted: fetchSearchResults,
              decoration: InputDecoration(
                hintText: "Enter a new password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordConfirmController,
              //onSubmitted: fetchSearchResults,
              decoration: InputDecoration(
                hintText: "Confirm your password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: () {
                  if(_usernameController.text != "" && _passwordController.text != "" && _passwordConfirmController.text != ""){
                    if(_passwordController.text != _passwordConfirmController.text){
                      _showErrorDialog("Passwords do not match.");
                      return;
                    }
                    _signup(context, _usernameController.text, _passwordController.text);
                  }
                  },
                child: Text('Sign Up'),
              ),
          ],
        ),
      ),
    );
  }
}
