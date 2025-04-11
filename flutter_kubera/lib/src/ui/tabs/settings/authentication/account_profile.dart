import 'package:flutter/material.dart';
import 'package:flutter_kubera/src/ui/tabs/settings/authentication/login.dart';
import 'package:flutter_kubera/src/ui/tabs/settings/authentication/sign_up.dart';
import 'package:provider/provider.dart';

import 'package:flutter_kubera/src/models/test.dart';
import '../../../../services/flask_service.dart';
import 'package:flutter_kubera/src/core/error_dialog.dart';
import '../auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Test> futureTest;

  @override
  void initState() {
    super.initState();
    futureTest = FlaskService().fetchTest();
  }

  void _navigateToLoginPage(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }

  void _navigateToSignUpPage(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignUpScreen(),
      ),
    );
  }

  void _logout(BuildContext context) async {
    try{
      await FlaskService().logout(context);
    }
    catch (e) {
      _showErrorDialog("Sorry! We lost your session. Please login again.");
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
    return 
        Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, ${context.read<AuthState>().username()}!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                context.read<AuthState>().isAuthorized
                ? ElevatedButton(
                    onPressed: () {
                    _logout(context);
                    },
                    child: Text('Logout'),
                  ) 
                  : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded( // https://api.flutter.dev/flutter/widgets/Expanded-class.html
                        child: ElevatedButton(
                                onPressed: () => _navigateToLoginPage(context),
                                child: Text('Login'),
                              ),
                      ), 
                      Expanded(
                        child: ElevatedButton(
                                onPressed: () => _navigateToSignUpPage(context),
                                child: Text('Sign Up'),
                                )
                      )
                    ]
                  )
              ]
      );
  }
}
