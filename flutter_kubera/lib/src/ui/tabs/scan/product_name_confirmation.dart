import 'package:flutter/material.dart';
import 'package:flutter_kubera/src/core/error_dialog.dart';
import 'package:flutter_kubera/src/core/store_product_card.dart';
import 'package:flutter_kubera/src/models/scanned_receipt.dart';
import 'package:flutter_kubera/src/services/flask_service.dart';
import 'package:flutter_kubera/src/ui/tabs/scan/product_generic_confirmation.dart';

class ProductNameConfirmationScreen extends StatefulWidget {
  final ScannedReceipt scannedReceipt;

  const ProductNameConfirmationScreen({super.key, required this.scannedReceipt});

  @override
  _ProductNameConfirmationScreenState createState() => _ProductNameConfirmationScreenState();
}

class _ProductNameConfirmationScreenState extends State<ProductNameConfirmationScreen> {
  late TextEditingController _storeNameController;
  late TextEditingController _dateController;
  late List<TextEditingController> _lineItemControllers;
  late List<TextEditingController> _productNameControllers;
  late List<TextEditingController> _priceControllers;

  bool _isEditingStoreName = false;
  bool _isEditingDate = false;
  bool _isLoading = false; // Added _isLoading variable

  @override
  void initState() {
    super.initState();
    _storeNameController = TextEditingController(text: widget.scannedReceipt.storeName);
    _dateController = TextEditingController(text: widget.scannedReceipt.date);
    _lineItemControllers = widget.scannedReceipt.scannedLineItems
        .map((product) => TextEditingController(text: product.lineItem))
        .toList();
    _productNameControllers = widget.scannedReceipt.scannedLineItems
        .map((product) => TextEditingController(text: product.storeProductName))
        .toList();
    _priceControllers = widget.scannedReceipt.scannedLineItems
        .map((product) => TextEditingController(text: product.totalPrice.toString()))
        .toList();
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _dateController.dispose();
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

  Future<void> _mapReceipt(BuildContext context, ScannedReceipt scannedReceipt) async {
    setState(() {
      _isLoading = true; // Set _isLoading to true
    });

    try {
      ScannedReceipt mappedReceipt = await FlaskService().mapReceipt(scannedReceipt);

      // Navigate to the next screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductGenericConfirmationScreen(scannedReceipt: mappedReceipt),
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          String userMessage = e.toString().replaceAll("Exception: ", "");
          return ErrorDialog(message: userMessage);
        },
      );
    } finally {
      setState(() {
        _isLoading = false; // Set _isLoading to false
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kubera')),
      body: Stack(
        children: [
          Padding(
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
                Card(
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
                              if (_isEditingStoreName)
                                TextField(
                                  controller: _storeNameController,
                                  decoration: const InputDecoration(labelText: 'Store Name'),
                                  onChanged: (value) {
                                    setState(() {
                                      widget.scannedReceipt.storeName = value;
                                    });
                                  },
                                )
                              else
                                Text('${widget.scannedReceipt.storeName}'),
                              const SizedBox(height: 8),
                              if (_isEditingDate)
                                TextField(
                                  controller: _dateController,
                                  decoration: const InputDecoration(labelText: 'Date', hintText: 'YYYY-MM-DD'),
                                  onChanged: (value) {
                                    setState(() {
                                      widget.scannedReceipt.date = value;
                                    });
                                  },
                                )
                              else
                                Text('${widget.scannedReceipt.date}'),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            if (_isEditingStoreName || _isEditingDate)
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isEditingStoreName = false;
                                    _isEditingDate = false;
                                  });
                                },
                                child: const Text('Save'),
                              )
                            else
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isEditingStoreName = true;
                                    _isEditingDate = true;
                                  });
                                },
                                child: const Text('Edit'),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
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
                    itemCount: widget.scannedReceipt.scannedLineItems.length,
                    itemBuilder: (context, index) {
                      final product = widget.scannedReceipt.scannedLineItems[index];
                      return StoreProductCard(
                        scannedLineItem: product,
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
                            _mapReceipt(context, widget.scannedReceipt);
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
          if (_isLoading)
            const Positioned(
              bottom: 16.0,
              left: 0,
              right: 0,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
