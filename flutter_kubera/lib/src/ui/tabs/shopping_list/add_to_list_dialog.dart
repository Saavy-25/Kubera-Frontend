import 'package:flutter/material.dart';
import '../../../models/shopping_list.dart';
import '../../../models/store_product.dart';
import '../../../services/flask_service.dart';

class AddToListDialog extends StatefulWidget {
  final StoreProduct storeProduct;

  const AddToListDialog({
    Key? key,
    required this.storeProduct,
  }) : super(key: key);

  @override
  _AddToListDialogState createState() => _AddToListDialogState();
}

class _AddToListDialogState extends State<AddToListDialog> {
  late Future<List<ShoppingList>> _shoppingListsFuture;
  ShoppingList? _selectedShoppingList;

  @override
  void initState() {
    super.initState();
    _shoppingListsFuture = FlaskService().getUsersShoppingLists(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Which list would you like to add this product to?',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<ShoppingList>>(
              future: _shoppingListsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No shopping lists found.'),
                  );
                } else {
                  final shoppingLists = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: shoppingLists.length,
                    itemBuilder: (context, index) {
                      final shoppingList = shoppingLists[index];
                      return RadioListTile<ShoppingList>(
                        title: Text(shoppingList.listName),
                        value: shoppingList,
                        groupValue: _selectedShoppingList,
                        onChanged: (ShoppingList? value) {
                          setState(() {
                            _selectedShoppingList = value;
                          });
                        },
                      );
                    },
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog without any action
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _selectedShoppingList != null
                      ? () {
                            FlaskService()
                              .addItemToList(_selectedShoppingList!.id, widget.storeProduct.id, widget.storeProduct.storeProductName)
                              .then((_) {
                            Navigator.pop(context, _selectedShoppingList);
                            }).catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to add item: $error')),
                            );
                            });
                        }
                      : null, // Disable the button if no list is selected
                  child: const Text('Add'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}