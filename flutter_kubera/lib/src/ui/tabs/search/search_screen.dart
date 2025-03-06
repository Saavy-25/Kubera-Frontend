import 'package:flutter/material.dart';
import 'package:flutter_kubera/src/core/card.dart';
import 'package:flutter_kubera/src/services/flask_service.dart';
import 'package:flutter_kubera/src/models/generic_item.dart';
import 'products_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  final FlaskService flaskService = FlaskService();
  List<GenericItem> searchResults = [];
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();

  void fetchSearchResults(String query) async {
    if (query.isEmpty) {
      setState(() => searchResults = []);
      return;
    }

    setState(() => isLoading = true);

    try {
      List<GenericItem> results = await flaskService.searchItems(query);
      setState(() => searchResults = results);
    } catch (e) {
      print("Error: $e");
    }

    setState(() => isLoading = false);
  }

  void _navigateToItemPage(BuildContext context, String itemId, String itemName, List<String> productIds) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductsScreen(itemId: itemId, itemName: itemName, productIds: productIds),
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
              controller: searchController,
              onSubmitted: fetchSearchResults,
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
            isLoading
                ? CircularProgressIndicator()
                : searchResults.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: searchResults.length,
                          itemBuilder: (context, index) {
                            final item = searchResults[index];
                            return ListTile(
                              title: Text(item.genericItem ?? "Unknown Item"),
                              subtitle: Text("Category: ${item.category}"),
                              onTap: () => _navigateToItemPage(context, item.pk ?? "", item.genericItem ?? "", item.productIds ?? []),
                            );
                          },
                        ),
                      )
                    : Expanded(child: Center(child: Text("No results found"))),
          ],
        ),
      ),
    );
  }
}
