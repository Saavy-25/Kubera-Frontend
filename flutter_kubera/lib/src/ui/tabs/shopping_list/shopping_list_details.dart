import 'package:flutter/material.dart';
import 'package:flutter_kubera/src/services/flask_service.dart';
import '../../../models/shopping_list.dart';

class ShoppingListDetails extends StatefulWidget {
  final ShoppingList shoppingList;

  const ShoppingListDetails({
    Key? key,
    required this.shoppingList,
  }) : super(key: key);

  @override
  _ShoppingListDetailsState createState() => _ShoppingListDetailsState();
}

class _ShoppingListDetailsState extends State<ShoppingListDetails> {
  late ShoppingList _shoppingList;

  @override
  void initState() {
    super.initState();
    _shoppingList = widget.shoppingList;
  }

  Future<void> _refreshShoppingList() async {
    try {
      final updatedList = await FlaskService().getShoppingList(_shoppingList.id);
      setState(() {
        _shoppingList = updatedList;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error refreshing list: $error')),
      );
    }
  }

  Future<void> _removeItemFromList(BuildContext context, String listId, String productId) async {
    try {
      await FlaskService().removeItemFromList(listId, productId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product removed from the list')),
      );
      _refreshShoppingList();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  Future<void> _toggleListItem(BuildContext context, String listId, String productId) async {
    try {
      await FlaskService().toggleListItem(listId, productId);
      _refreshShoppingList();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_shoppingList.listName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _shoppingList.items.length,
          itemBuilder: (context, index) {
            final item = _shoppingList.items[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16.0),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(
                  item.productName,
                  style: item.retrieved ? TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ) : TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                // subtitle: Text('${item.storeName} - ${item.price}'), TODO: query product to get price
                leading: Checkbox(
                  value: item.retrieved,
                  onChanged: (bool? value) {
                    _toggleListItem(context, _shoppingList.id, item.storeProductId);
                  },
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.remove, color: Colors.black),
                  onPressed: () {
                    _removeItemFromList(context, _shoppingList.id, item.storeProductId);
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
