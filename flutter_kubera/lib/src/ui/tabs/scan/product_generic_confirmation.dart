import 'package:flutter/material.dart';
import 'package:flutter_kubera/src/core/error_dialog.dart';
import 'package:flutter_kubera/src/models/receipt.dart';
import 'package:flutter_kubera/src/models/store_product.dart';
import 'package:flutter_kubera/src/services/flask_service.dart';

class ProductGenericConfirmationScreen extends StatefulWidget {
  final Receipt receipt;

  const ProductGenericConfirmationScreen({super.key, required this.receipt});

  @override
  _ProductGenericConfirmationScreenState createState() => _ProductGenericConfirmationScreenState();
}

class _ProductGenericConfirmationScreenState extends State<ProductGenericConfirmationScreen> {
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
              'Confirm The Generic Matches',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            // Display receipt data
            const SizedBox(height: 16),
            Text('Store Name: ${widget.receipt.storeName}'),
            Text('Date: ${widget.receipt.date}'),
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
                itemCount: widget.receipt.products.length,
                itemBuilder: (context, index) {
                  final product = widget.receipt.products[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Product Name: ${product.storeProductName}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          if (product.genericMatches.length > 1)
                            DropdownButton<String>(
                              value: product.genericMatches[0],
                              onChanged: (String? newValue) {
                                setState(() {
                                  product.genericMatches[0] = newValue!;
                                });
                              },
                              items: product.genericMatches
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            )
                          else
                            Text(
                              'Generic Match: ${product.genericMatches[0]}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
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
                      label: const Text('Go Back'),
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
                        _confirmReceipt(context, widget.receipt);
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

  Future<void> _confirmReceipt(BuildContext context, Receipt receipt) async {
    try {
      await FlaskService().postReceipt(receipt);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Receipt saved'),
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
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(message: 'Failed to post receipt: $e');
        },
      );
    }
  }
}