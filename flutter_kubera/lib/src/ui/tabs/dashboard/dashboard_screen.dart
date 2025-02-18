import 'package:flutter/material.dart';

import '../../../models/test.dart';
import '../../../services/flask_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<Test> futureTest;

  @override
  void initState() {
    super.initState();
    futureTest = FlaskService().fetchTest();
  }

  // Sample code: https://github.com/toliksadovnichiy/Flutter-lab4/blob/08aadb19b0c20f5e439dc20173b5f6b03e4e4b1c/lib/parse_json_widget.dart
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: Center(
        child: FutureBuilder<Test>(
          future: futureTest,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!.message);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
