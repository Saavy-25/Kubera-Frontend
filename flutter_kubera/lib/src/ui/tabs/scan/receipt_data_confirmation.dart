import 'package:flutter/material.dart';
import 'package:flutter_kubera/src/core/error_dialog.dart';
import 'package:flutter_kubera/src/core/store_product_card.dart';
import 'package:flutter_kubera/src/models/receipt.dart';
import 'package:flutter_kubera/src/services/flask_service.dart';

class ReceiptDataConfirmationScreen extends StatefulWidget {
  final Receipt receipt;

  const ReceiptDataConfirmationScreen({super.key, required this.receipt});

  @override
  _ReceiptDataConfirmationScreenState createState() => _ReceiptDataConfirmationScreenState();
}

class _ReceiptDataConfirmationScreenState extends State<ReceiptDataConfirmationScreen> {
  late List<TextEditingController> _lineItemControllers;
  late List<TextEditingController> _productNameControllers;
  late List<TextEditingController> _priceControllers;

  @override
  void initState() {
    super.initState();
    _lineItemControllers = widget.receipt.products
        .map((product) => TextEditingController(text: product.lineItem))
        .toList();
    _productNameControllers = widget.receipt.products
        .map((product) => TextEditingController(text: product.productName))
        .toList();
    _priceControllers = widget.receipt.products
        .map((product) => TextEditingController(text: product.price.toString()))
        .toList();
  }

  @override
  void dispose() {
    for (var controller in _lineItemControllers) {
      controller.dispose();
    }
    for (var controller in _productNameControllers) {
      controller.dispose();
    }
    for (var controller in _priceControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _confirmReceipt(BuildContext context, Receipt receipt) async {
    try {
      await FlaskService().postReceipt(receipt);

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
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(message: 'Failed to post receipt: $e');
        },
      );
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
                  // TODO: Display product data in an editable form

                  return StoreProductCard(
                    product: product,
                    onLineItemChanged: (value) {
                      setState(() {
                        product.updateLineItem(value);
                      });
                    },
                    onProductNameChanged: (value) {
                      setState(() {
                        product.updateProductName(value);
                      });
                    },
                    onPriceChanged: (value) {
                      setState(() {
                        product.updatePrice(value);
                      });
                    },
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
}
