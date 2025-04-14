import 'package:flutter/material.dart';
import 'package:flutter_kubera/src/models/store_product.dart';

class PriceHistoryCard extends StatelessWidget {
  final List<RecentPrice> recentPrices;

  const PriceHistoryCard({
    Key? key,
    required this.recentPrices,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Group prices by their latestDate
    final groupedPrices = <String, List<RecentPrice>>{};
    for (var recentPrice in recentPrices) {
      groupedPrices.putIfAbsent(recentPrice.lastReportDate, () => []).add(recentPrice);
    }

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            ...groupedPrices.entries.map((entry) {
              final date = entry.key;
              final prices = entry.value;

              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${DateTime.parse(date).month}-${DateTime.parse(date).day}-${DateTime.parse(date).year}', // Display the date in month-day-year format
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...prices.map((price) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Reported on ${price.reportCount} receipt(s)',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              '\$${price.price}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                      height: 16,
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}