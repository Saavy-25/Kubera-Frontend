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
    return Scaffold(
      appBar: AppBar(title: Text(storeProduct.storeProductName)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0), 
              child: Text("Last Reported Prices", style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.start)
            ),
            SizedBox(height: 16.0),
            Column(
              children: [
                // if (storeProduct.recentPrices != null)
                //   for (var priceTime in storeProduct.recentPrices!)
                  ItemDetailsCard(storeProduct: storeProduct)
                  // PriceHistoryCard(recentPrices: storeProduct.recentPrices),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
