import 'package:flutter/material.dart';
import 'package:flutter_kubera/src/models/store_product.dart';

class PriceHistoryCard {
  final List<RecentPrice> recentPrices;

  const PriceHistoryCard({
    required this.recentPrices,
  });

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
                crossAxisAlignment: CrossAxisAlignment.end,
                children: recentPrices.map((recentPrice) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      '\$${recentPrice.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  );
                }).toList()
              ),
            ),
          ],
        ),
      ),
    );
  }
}