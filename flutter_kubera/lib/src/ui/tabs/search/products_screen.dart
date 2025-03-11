import 'package:flutter/material.dart';
import '../../../core/card.dart';
import 'package:flutter_kubera/src/services/flask_service.dart';
import 'package:flutter_kubera/src/models/store_product.dart';

class ProductsScreen extends StatelessWidget {
  final String itemId;
  final String itemName;
  final List<String> productIds;

  const ProductsScreen({
    super.key,
    required this.itemId,
    required this.itemName,
    required this.productIds,
  });

  //Replace with backend call
  Future<List<StoreProduct>> fetchProducts(List<String> productIds) async {
    final flaskService = FlaskService();
    try {
      return await flaskService.fetchStoreProducts(productIds);
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(itemName)),
      body: FutureBuilder<List<StoreProduct>>(
        future: fetchProducts(productIds),
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
                      onAdd: () {
                        //TODO navigate to product page
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
