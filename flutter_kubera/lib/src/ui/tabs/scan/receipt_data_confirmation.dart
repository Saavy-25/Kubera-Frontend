import 'package:flutter/material.dart';
import 'package:flutter_kubera/src/models/scanned_receipt.dart';
import 'package:flutter_kubera/src/services/flask_service.dart';

class ReceiptDataConfirmationScreen extends StatelessWidget {
  final ScannedReceipt receipt;

  const ReceiptDataConfirmationScreen({super.key, required this.receipt});

  Future<void> _confirmReceipt(BuildContext context, ScannedReceipt receipt) async {
    try {
      await FlaskService().postReceipt(context, receipt);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Receipt added to database'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pop(); // Go back to the previous screen
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Failed to post receipt: $e');
    }
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
              'Does this look correct?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            // Display receipt data
            const SizedBox(height: 16),
            Text('Store Name: ${receipt.storeName}'),
            Text('Date: ${receipt.date}'),
            const SizedBox(height: 16),
            Text(
              'Products:',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: receipt.scannedLineItems.length,
                itemBuilder: (context, index) {
                  final product = receipt.scannedLineItems[index];
                  return ListTile(
                    title: Text(product.lineItem),
                    subtitle: Text('Price: \$${product.totalPrice}'),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () { //Go to scan screen
                        Navigator.pop(context);
                      },
                      label: const Text('Retry'),
                      icon: const Icon(Icons.arrow_back),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () { //Go to scan screen
                        _confirmReceipt(context, this.receipt);
                      },
                      label: const Text('Confirm'),
                      icon: const Icon(Icons.check),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
