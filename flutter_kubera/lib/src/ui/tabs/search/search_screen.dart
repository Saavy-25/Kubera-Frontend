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
  bool hasSearched = false; // Track whether a search has been performed
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {}); // Trigger a rebuild to show/hide the suffix icon
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void fetchSearchResults(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
        hasSearched = false; // Reset search state if query is empty
      });
      return;
    }

    setState(() {
      isLoading = true;
      hasSearched = true; // Mark that a search has been performed
    });

    try {
      List<GenericItem> results = await flaskService.searchItems(query);
      setState(() => searchResults = results);
    } catch (e) {
      print("Error: $e");
    }

    setState(() => isLoading = false);
  }

  Widget buildHighlightedText(GenericItem item) {
    if (item.highlightTexts != null && item.highlightTexts!.isNotEmpty) {
      final highlightTexts = item.highlightTexts as List<dynamic>;
      return RichText(
        text: TextSpan(
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.0,
          ),
          children: highlightTexts.map((text) {
            final value = text['value'] ?? '';
            final type = text['type'] ?? '';
            return TextSpan(
              text: value,
              style: TextStyle(
                fontWeight: type == 'hit' ? FontWeight.bold : FontWeight.normal,
              ),
            );
          }).toList(),
        ),
      );
    } else {
      return Text(item.genericName ?? "Unknown Item", 
        style: const TextStyle(
          fontSize: 16.0,
          color: Color.fromARGB(255, 100, 100, 100),
        ),
      );
    }
  }

  void _navigateToProductsPage(BuildContext context, String itemName, String genericId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductsScreen(itemName: itemName, genericId: genericId),
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
                          setState(() {
                            searchResults = [];
                            hasSearched = false; // Reset search state
                          });
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
                : hasSearched
                    ? searchResults.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                              itemCount: searchResults.length,
                              itemBuilder: (context, index) {
                                final genericResult = searchResults[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0), // Reduced vertical padding
                                  child: ListTile(
                                    visualDensity: VisualDensity(),
                                    title: buildHighlightedText(genericResult),
                                    onTap: () => _navigateToProductsPage(
                                      context,
                                      genericResult.genericName ?? "",
                                      genericResult.id ?? '',
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : const Expanded(
                            child: Center(child: Text("No results found")),
                          )
                    : const Expanded(
                        child: Center(child: Text("Search for a general item (e.g. Beef)")),
                      ),
          ],
        ),
      ),
    );
  }
}
