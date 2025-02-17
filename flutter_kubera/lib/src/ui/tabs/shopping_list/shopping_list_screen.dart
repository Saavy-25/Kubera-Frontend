import 'package:flutter/material.dart';

import '../../../core/card.dart';

class ShoppingListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> items = [
    {'id': 1, 'price': '2.98', 'product': 'Fresh Cherry Tomatoes', 'store': 'Walmart'},
    {'id': 2, 'price': '3.54', 'product': 'Teeny Tiny Tomatoes', 'store': 'Trader Joe'},
    {'id': 3, 'price': '2.95', 'product': 'Cherry Tomatoes Organic', 'store': 'Publix'},
  ];

  ShoppingListScreen({super.key});

  void _handleAddItem(String title) {
    //TODO: Implement adding item to list
    print('$title added to the shopping list!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kubera')),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return CustomCard(
            title: item['price'] ?? 'Unknown Item',
            overhead: item['store'],
            subtitle: item['product'],
            showAddButton: true,
            onAdd: () => _handleAddItem(item['price']),
            onTap: () {
              /*Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShoppingListDetailsScreen(itemId: item['id']),
                ),
              );
              */
            },
          );
        },
      ),
    );
  }
}
