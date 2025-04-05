import 'package:flutter/material.dart';
import 'package:flutter_kubera/src/models/store_product.dart';


class ItemDetailsCard extends StatelessWidget {
  final StoreProduct storeProduct;

  const ItemDetailsCard({super.key, required this.storeProduct});

  @override
  Widget build(BuildContext context) {
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
                crossAxisAlignment: CrossAxisAlignment.end, // Right justify the column
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
                      '\$${storeProduct.recentPrices!.first.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}