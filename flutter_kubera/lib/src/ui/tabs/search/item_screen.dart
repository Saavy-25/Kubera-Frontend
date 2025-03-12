import 'package:flutter/material.dart';
import 'package:flutter_kubera/src/models/store_product.dart';
import '../../../core/card.dart';

class ItemScreen extends StatelessWidget {
  final StoreProduct storeProduct;

  const ItemScreen({
    super.key,
    required this.storeProduct,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(storeProduct.productName)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // Add a table to display prices and timestamps from storeProduct.recentPrices
        child: Column(
          children: [
            CustomCard(
              title: storeProduct.productName,
              overhead: storeProduct.storeName
            ),
            SizedBox(height: 16.0),
            Table(
              border: TableBorder.all(),
              columnWidths: const {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(2),
              },
              children: [
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Price', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Timestamp', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          if (storeProduct.recentPrices != null)
            for (var priceTime in storeProduct.recentPrices!)
            TableRow(
              children: [
                Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(priceTime.price.toString()),
                ),
                Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(priceTime.timestamp.toString()),
                ),
              ],
            ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
