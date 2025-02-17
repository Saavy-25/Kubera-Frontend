import 'package:flutter/material.dart';
import '../../../core/card.dart';

class ItemScreen extends StatelessWidget {
  final String itemId;
  final String itemName;

  const ItemScreen({
    super.key,
    required this.itemId,
    required this.itemName,
  });

  //Replace with backend call
  Future<List<Map<String, dynamic>>> _fetchProducts(String itemId) async {
    await Future.delayed(const Duration(seconds: 2));

    return [
      {
        'product_id': 'store1#Butter#1',
        'store': 'Store 1',
        'product_name': 'Butter',
        'unit': 'kg',
        'prices': [
          {'price': 4.99, 'timestamp': '2025-01-01'},
          {'price': 5.49, 'timestamp': '2025-02-01'},
        ],
      },
      {
        'product_id': 'store2#Milk#2',
        'store': 'Store 2',
        'product_name': 'Milk',
        'unit': 'liter',
        'prices': [
          {'price': 1.99, 'timestamp': '2025-01-01'},
          {'price': 2.19, 'timestamp': '2025-02-01'},
        ],
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$itemName')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchProducts(itemId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            var products = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: products.map((product) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CustomCard(
                      overhead: product['store'],
                      title: '\$${product['prices'][0]['price']}',
                      subtitle: product['product_name'],
                      showAddButton: true,
                      onAdd: () {
                        //TODO navigate to product page
                      },
                    ),
                  );
                }).toList(),
              ),
            );
          }

          return const Center(child: Text('No product details available.'));
        },
      ),
    );
  }
}
