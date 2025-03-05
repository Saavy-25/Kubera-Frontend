import 'package:flutter/material.dart';
import '../../../core/card.dart';
import 'package:flutter_kubera/src/services/flask_service.dart';

class ItemScreen extends StatelessWidget {
  final String itemId;
  final String itemName;

  const ItemScreen({
    super.key,
    required this.itemId,
    required this.itemName,
  });

  //Replace with backend call
  Future<List<Map<String, dynamic>>> fetchProducts(List<String> productIds) async {
    final flaskService = FlaskService();
    try {
      final products = await flaskService.fetchStoreProducts([itemId]);
      return products.map((product) => product.toJson()).toList();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(itemName)),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchProducts(itemId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            var products = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: products.map((product) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CustomCard(
                      overhead: product['store'],
                      title: '\$${product['prices'][0]['price']}',
                      subtitle: product['product_name'],
                      showAddButton: true,
                      onAdd: () {
                        //TODO navigate to product page
                      },
                    ),
                  );
                }).toList(),
              ),
            );
          }

          return const Center(child: Text('No product details available.'));
        },
      ),
    );
  }
}
