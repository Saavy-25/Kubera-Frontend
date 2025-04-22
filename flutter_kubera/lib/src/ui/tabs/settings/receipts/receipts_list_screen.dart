import 'package:flutter/material.dart';
import 'package:flutter_kubera/src/core/receipt_card.dart';
import 'package:flutter_kubera/src/models/receipt.dart';
import 'package:flutter_kubera/src/services/flask_service.dart';
import 'receipts_details_screen.dart';

class ReceiptsListScreen extends StatefulWidget {
  const ReceiptsListScreen({super.key});

  @override
  _ReceiptsListScreenState createState() => _ReceiptsListScreenState();
}

class _ReceiptsListScreenState extends State<ReceiptsListScreen> {
  late Future<List<Receipt>> _receiptsFuture;

  @override
  void initState() {
    super.initState();
    _receiptsFuture = FlaskService().fetchReceipts(context);
  }

  void _navigateToReceiptDetails(Receipt receipt) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ReceiptsDetailsScreen(receipt: receipt),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Receipts')),
      body: FutureBuilder<List<Receipt>>(
        future: _receiptsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load receipts: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No receipts found.'));
          }

          final receipts = snapshot.data!;
          return ListView.builder(
            itemCount: receipts.length,
            itemBuilder: (context, index) {
              final receipt = receipts[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: ReceiptCard(
                  receipt: receipt,
                  onTap: () => _navigateToReceiptDetails(receipt),
                ),
              );
            },
          );
        },
      ),
    );
  }
}