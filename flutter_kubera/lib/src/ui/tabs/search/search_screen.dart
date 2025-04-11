import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    // Add a listener to update the UI when text changes
    searchController.addListener(() {
      setState(() {}); // Trigger a rebuild to show/hide the suffix icon
    });
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is removed
    searchController.dispose();
    super.dispose();
  }

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

  void _navigateToProductsPage(BuildContext context, String itemId, String itemName, String genericId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductsScreen(itemId: itemId, itemName: itemName, genericId: genericId),
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
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          setState(() => searchResults = []); // Clear results
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
              ),
            ),
            const SizedBox(height: 10),
            isLoading
                ? const CircularProgressIndicator()
                : searchResults.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: searchResults.length,
                          itemBuilder: (context, index) {
                            final item = searchResults[index];
                            return ListTile(
                              title: Text(item.genericName ?? "Unknown Item"),
                              onTap: () => _navigateToProductsPage(context, item.id ?? "", item.genericName ?? "", item.id ?? ''),
                              minTileHeight: 1,
                            );
                          },
                        ),
                      )
                    : const Expanded(
                        child: Center(child: Text("No results found")),
                      ),
          ],
        ),
      ),
    );
  }
}
