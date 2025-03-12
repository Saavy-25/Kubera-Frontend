import 'package:flutter_kubera/src/models/store_product.dart';

class Receipt {
  final String id;
  String storeName;
  final String storeAddress;
  String date;
  final String totalReceiptPrice;
  List<StoreProduct> products;

  Receipt({
    required this.id,
    required this.storeName,
    required this.storeAddress,
    required this.date,
    required this.totalReceiptPrice,
    required this.products
  });

  void updateStoreName(String newStoreName) {
    storeName = newStoreName;
    
  }

  void updateDate(String newDate) {
    date = newDate;
  }

  factory Receipt.fromJson(Map<String, dynamic> json) {
    var productsFromJson = json['products'] as List? ?? [];
    List<StoreProduct> productList = productsFromJson.map((productJson) => StoreProduct.fromJson(productJson)).toList();

    return Receipt(
      id: json['_id'] ?? '',
      storeName: json['storeName'] ?? '',
      storeAddress: json['storeAddress'] ?? '',
      date: json['date']  ?? '',
      totalReceiptPrice: json['totalReceiptPrice']  ?? '',
      products: productList
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'storeName': storeName,
      'storeAddress': storeAddress,
      'date': date,
      'totalReceiptPrice': totalReceiptPrice,
      'products': products.map((product) => product.toJson()).toList(),
    };
  }
}