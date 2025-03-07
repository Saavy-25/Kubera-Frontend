import 'package:flutter_kubera/src/models/store_product.dart';

class Receipt {
  final String? pk;
  final String? sk;
  final String storeName;
  final String date;
  List<StoreProduct> products;

  Receipt({
    required this.pk,
    required this.sk,
    required this.storeName,
    required this.date,
    required this.products,
  });

  factory Receipt.fromJson(Map<String, dynamic> json) {
    var productsFromJson = json['products'] as List? ?? [];
    List<StoreProduct> productList = productsFromJson.map((productJson) => StoreProduct.fromJson(productJson)).toList();

    return Receipt(
      pk: json['pk'],
      sk: json['sk'],
      storeName: json['store_name'],
      date: json['date'],
      products: productList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pk': pk,
      'sk': sk,
      'store_name': storeName,
      'date': date,
      'products': products.map((product) => product.toJson()).toList(),
    };
  }
}