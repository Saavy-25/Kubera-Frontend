import 'package:flutter/material.dart';
import 'package:flutter_kubera/src/core/error_dialog.dart';
import 'package:flutter_kubera/src/models/scanned_receipt.dart';
import 'package:flutter_kubera/src/models/scanned_line_item.dart';
import 'package:flutter_kubera/src/services/flask_service.dart';

class ProductGenericConfirmationScreen extends StatefulWidget {
  final ScannedReceipt scannedReceipt;

  const ProductGenericConfirmationScreen({super.key, required this.scannedReceipt});

  @override
  _ProductGenericConfirmationScreenState createState() => _ProductGenericConfirmationScreenState();
}

class _ProductGenericConfirmationScreenState extends State<ProductGenericConfirmationScreen> {
  void _showGenericMatchDialog(ScannedLineItem product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GenericMatchDialog(
          scannedLineItem: product,
          onSelected: (String selectedMatch) {
            setState(() {
              product.genericMatch = selectedMatch;
            });
          },
        );
      },
    );
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
              'Confirm matches',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: widget.scannedReceipt.scannedLineItems.length,
                itemBuilder: (context, index) {
                  final product = widget.scannedReceipt.scannedLineItems[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.storeProductName,
                                  style: const TextStyle(fontSize: 16),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                  const Icon(Icons.arrow_forward, size: 16),
                                  const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                      product.genericMatch,
                                      style: const TextStyle(fontSize: 16),
                                      overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              TextButton(
                                onPressed: () {
                                  _showGenericMatchDialog(product);
                                },
                                child: const Text('Edit'),
                              ),
                            ],
                          ),
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
                        _confirmReceipt(context, widget.scannedReceipt);
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

  Future<void> _confirmReceipt(BuildContext context, ScannedReceipt scannedReceipt) async {
    try {
      await FlaskService().postReceipt(context, scannedReceipt);

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
                  Navigator.of(context).pop(); // Go back to the scan screen
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

class GenericMatchDialog extends StatefulWidget {
  final ScannedLineItem scannedLineItem;
  final ValueChanged<String> onSelected;

  const GenericMatchDialog({super.key, required this.scannedLineItem, required this.onSelected});

  @override
  _GenericMatchDialogState createState() => _GenericMatchDialogState();
}

class _GenericMatchDialogState extends State<GenericMatchDialog> {
  late TextEditingController customOptionController;
  late String? selectedMatch;

  @override
  void initState() {
    super.initState();
    customOptionController = TextEditingController();
    selectedMatch = widget.scannedLineItem.genericMatch;
  }

  @override
  void dispose() {
    customOptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Generic Match'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...widget.scannedLineItem.genericMatches.map((String match) {
            return RadioListTile<String>(
              title: Text(match),
              value: match,
              groupValue: selectedMatch,
              onChanged: (String? value) {
                setState(() {
                  selectedMatch = value;
                });
              },
            );
          }),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Save'),
          onPressed: () {
            setState(() {
              if (customOptionController.text.isNotEmpty) {
                widget.scannedLineItem.genericMatch = customOptionController.text;
              } else {
                widget.scannedLineItem.genericMatch = selectedMatch!;
              }
            });
            widget.onSelected(widget.scannedLineItem.genericMatch);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}