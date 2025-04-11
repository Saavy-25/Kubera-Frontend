import 'package:flutter/material.dart';
import '../../../models/shopping_list.dart';

class ShoppingListDetails extends StatelessWidget {
  final ShoppingList shoppingList;

  const ShoppingListDetails({
    Key? key,
    required this.shoppingList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(shoppingList.listName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: shoppingList.items.length,
          itemBuilder: (context, index) {
            final item = shoppingList.items[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16.0),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(
                  item.productName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text('Product ID: ${item.storeProductId}'),
                trailing: Checkbox(
                  value: item.isChecked,
                  onChanged: (bool? value) {
                    // Handle checkbox toggle (if needed)
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}