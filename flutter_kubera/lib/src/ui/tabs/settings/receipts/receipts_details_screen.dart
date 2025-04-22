import 'package:flutter/material.dart';
import 'package:flutter_kubera/src/models/receipt.dart';
import 'package:flutter_kubera/src/services/flask_service.dart';

class ReceiptsDetailsScreen extends StatefulWidget {
  final Receipt receipt;

  const ReceiptsDetailsScreen({
    super.key,
    required this.receipt,
  });

  @override
  _ReceiptsDetailsScreenState createState() => _ReceiptsDetailsScreenState();
}

class _ReceiptsDetailsScreenState extends State<ReceiptsDetailsScreen> {
  final FlaskService _flaskService = FlaskService();
  late Future<Map<String, String>> _productNamesFuture;

  @override
  void initState() {
    super.initState();
    _productNamesFuture = _fetchProductNames();
  }

  Future<Map<String, String>> _fetchProductNames() async {
    final Map<String, String> productNames = {};
    for (var lineItem in widget.receipt.lineItems) {
      try {
        final productJson = await _flaskService.fetchProductJson(lineItem.storeProductId);
        productNames[lineItem.storeProductId] = productJson["storeProductName"];
      } catch (e) {
        productNames[lineItem.storeProductId] = 'Unknown Product';
      }
    }
    return productNames;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receipt.storeName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Receipt Details Section
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.receipt.storeName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Date: ${widget.receipt.date}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Address: ${widget.receipt.storeAddress}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total: \$${widget.receipt.totalReceiptPrice.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            // Line Items Section
            Text(
              'Line Items',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: FutureBuilder<Map<String, String>>(
                future: _productNamesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Failed to load product names: ${snapshot.error}'));
                  }

                  final productNames = snapshot.data!;
                  return ListView.builder(
                    itemCount: widget.receipt.lineItems.length,
                    itemBuilder: (context, index) {
                      final lineItem = widget.receipt.lineItems[index];
                      final productName = productNames[lineItem.storeProductId] ?? 'Unknown Product';
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    productName,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Count: ${lineItem.count}',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                              Text(
                                '\$${lineItem.pricePerCount}',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}