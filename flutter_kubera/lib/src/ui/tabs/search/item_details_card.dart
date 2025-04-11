import 'package:flutter/material.dart';
import 'package:flutter_kubera/src/models/store_product.dart';


class ItemDetailsCard extends StatelessWidget {
  final StoreProduct storeProduct;

  const ItemDetailsCard({super.key, required this.storeProduct});
  

  @override
  Widget build(BuildContext context) {
    final dateDiff = DateTime.now().difference(DateTime.parse(storeProduct.recentPrices!.first.lastReportDate)).inDays;
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
                // crossAxisAlignment: CrossAxisAlignment.end, // Right justify the column
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    storeProduct.storeProductName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (storeProduct.recentPrices != null && storeProduct.recentPrices!.isNotEmpty)
                    Text(
                      '\$${storeProduct.recentPrices!.first.price}',
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  else
                    const Text(
                      'No recent prices available',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.red,
                      ),
                    ),
                  if (dateDiff > 1)
                    Text(
                        'Last reported ${dateDiff} days ago',
                      style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      ),
                    )
                  else if (dateDiff == 1)
                    const Text(
                      'Last reported yesterday',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    )
                  else
                    const Text(
                      'Date not available',
                      style: TextStyle(
                      fontSize: 14,
                      color: Colors.red,
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