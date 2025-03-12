import 'package:flutter/material.dart';
import 'package:flutter_kubera/src/ui/tabs/search/item_screen.dart';
import '../../../core/card.dart';
import 'package:flutter_kubera/src/services/flask_service.dart';
import 'package:flutter_kubera/src/models/store_product.dart';

class ProductsScreen extends StatelessWidget {
  final String itemId;
  final String itemName;
  final String genericId;

  const ProductsScreen({
    super.key,
    required this.itemId,
    required this.itemName,
    required this.genericId,
  });

  Future<List<StoreProduct>> fetchProducts(String genericId) async {
    final flaskService = FlaskService();
    try {
      return await flaskService.fetchStoreProducts(genericId);
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  // Navigate to item page
  void navigateToItemPage(BuildContext context, StoreProduct storeProduct) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemScreen(storeProduct: storeProduct),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(itemName)),
      body: FutureBuilder<List<StoreProduct>>(
        future: fetchProducts(genericId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            var products = snapshot.data!;

            if (products.isEmpty) {
              return const Center(child: Text('No product of this type has been submitted'));
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: products.map((product) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CustomCard(
                      overhead: product.storeName ?? '',
                      title: product.storeProductName,
                      onTap: () {
                        navigateToItemPage(context, product);
                      },
                    ),
                  );
                }).toList(),
              ),
            );
          } 
          
          else {
            return const Center(child: Text('No product of this type has been submitted.'));
          }
        },
      ),
    );
  }
}
