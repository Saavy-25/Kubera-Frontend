import 'package:flutter/material.dart';
import 'package:flutter_kubera/src/models/test.dart';
import '../../../../services/flask_service.dart';
import 'package:flutter_kubera/src/core/error_dialog.dart';

// class reference: https://medium.com/@pratham.patil_23302/flutter-fundamentals-crafting-a-login-signup-page-e6e518457457

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late Future<Test> futureTest;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureTest = FlaskService().fetchTest();
  }

  // Process the image using Flask API
  Future<void> _login(BuildContext context, String username, String password) async {
    try {

      String status = await FlaskService().login(context, username, password);
      
      if(status == "Success"){
        if(context.mounted) Navigator.pop(context);
      }
      else {
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

  // Sample code: https://github.com/toliksadovnichiy/Flutter-lab4/blob/08aadb19b0c20f5e439dc20173b5f6b03e4e4b1c/lib/parse_json_widget.dart
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
                hintText: "Enter your username",
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
                hintText: "Enter your password",
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
                  if(_usernameController.text != "" && _passwordController.text != ""){
                    _login(context, _usernameController.text, _passwordController.text);
                  }
                  },
                child: Text('Login'),
              ),
          ],
        ),
      ),
    );
  }
}
