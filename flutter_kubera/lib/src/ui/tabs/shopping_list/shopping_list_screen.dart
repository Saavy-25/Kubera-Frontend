import 'package:flutter/material.dart';
import 'package:flutter_kubera/src/models/shopping_list.dart';
import 'package:flutter_kubera/src/services/flask_service.dart';
import 'package:flutter_kubera/src/ui/tabs/shopping_list/shopping_list_details.dart';
import 'package:flutter_kubera/src/ui/tabs/shopping_list/create_shopping_list_dialog.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({Key? key}) : super(key: key);

  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  late Future<List<ShoppingList>> _shoppingListsFuture;

  @override
  void initState() {
    super.initState();
    _shoppingListsFuture = FlaskService().getUsersShoppingLists();
  }

  Future<void> _refreshShoppingLists() async {
    setState(() {
      _shoppingListsFuture = FlaskService().getUsersShoppingLists();
    });
  }

  Future<void> _showCreateShoppingListDialog() async {
    final createdListName = await showDialog<String>(
      context: context,
      builder: (context) => const CreateShoppingListDialog(),
    );

    if (createdListName != null) {
      // Refresh the shopping lists after creating a new one
      _refreshShoppingLists();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Lists'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Create New Shopping List'), // TODO: make clickable
                IconButton(
                  onPressed: _showCreateShoppingListDialog,
                  icon: const Icon(Icons.add_task),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ShoppingList>>(
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
                    padding: const EdgeInsets.all(16.0),
                    itemCount: shoppingLists.length,
                    itemBuilder: (context, index) {
                      final shoppingList = shoppingLists[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16.0),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(
                            shoppingList.listName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            // Navigate to the detailed view of the shopping list
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ShoppingListDetails(shoppingList: shoppingList),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}