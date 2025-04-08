import 'package:flutter/material.dart';
import 'package:flutter_kubera/src/models/store_product.dart';
import 'package:flutter_kubera/src/ui/tabs/search/item_details_card.dart';
import 'package:flutter_kubera/src/ui/tabs/search/price_history_card.dart';
import '../../../core/card.dart';

class ItemScreen extends StatelessWidget {
  final StoreProduct storeProduct;

  const ItemScreen({
    super.key,
    required this.storeProduct,
  });

  @override
  Widget build(BuildContext context) {
    // Mock data for recent prices
    // final recPrice = [
    //   RecentPrice(
    //     price: 120.50,
    //     lastReportDate: '2025-04-01',
    //     reportCount: 5,
    //   ),
    //   RecentPrice(
    //     price: 123.50,
    //     lastReportDate: '2025-04-01',
    //     reportCount: 6,
    //   ),
    //   RecentPrice(
    //     price: 122.00,
    //     lastReportDate: '2025-04-02',
    //     reportCount: 3,
    //   ),
    //   RecentPrice(
    //     price: 119.75,
    //     lastReportDate: '2025-04-03',
    //     reportCount: 7,
    //   ),
    // ];
    // storeProduct.recentPrices = recPrice;
    return Scaffold(
      appBar: AppBar(title: Text(storeProduct.storeProductName)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Item Details",
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.left,
                      ),
                  ),
            ),
            SizedBox(height: 16.0),
            ItemDetailsCard(storeProduct: storeProduct),
            Padding(
            padding: const EdgeInsets.all(5.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Price History at ${storeProduct.storeName}",
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.left,
                ),
              ),
            ),
            PriceHistoryCard(recentPrices: storeProduct.recentPrices ?? []),
              
          ],
        ),
      ),
    );
  }
}
