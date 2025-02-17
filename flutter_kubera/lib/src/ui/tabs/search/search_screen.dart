import 'package:flutter/material.dart';
import 'package:flutter_kubera/src/core/card.dart';
import 'item_screen.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final Map<String, List<Map<String, String>>> categoryItems = {
    'Produce': [
      {'item_id': '1', 'item_name': 'Apple'},
      {'item_id': '2', 'item_name': 'Banana'},
      {'item_id': '3', 'item_name': 'Carrot'},
    ],
    'Dairy': [
      {'item_id': '4', 'item_name': 'Butter'},
      {'item_id': '5', 'item_name': 'Milk'},
      {'item_id': '6', 'item_name': 'Cheese'},
    ],
  };

  void _navigateToItemPage(BuildContext context, String itemId, String itemName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemScreen(itemId: itemId, itemName: itemName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kubera")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: categoryItems.entries.map((entry) {
                  String category = entry.key;
                  List<Map<String, String>> items = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          category,
                        ),
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: 2,
                        ),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          var item = items[index];
                          return CustomCard(
                            title: item['item_name']!,
                            onTap: () => _navigateToItemPage(context, item['item_id']!, item['item_name']!),
                          );
                        },
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
