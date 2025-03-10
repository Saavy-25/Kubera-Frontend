import 'package:flutter_kubera/src/models/store_product.dart';

class Receipt {
  final String storeName;
  final String storeAddress;
  final String date;
  final String totalReceiptPrice;
  List<StoreProduct> products;

  Receipt({
    required this.storeName,
    required this.storeAddress,
    required this.date,
    required this.totalReceiptPrice,
    required this.products,
  });

  factory Receipt.fromJson(Map<String, dynamic> json) {
    var productsFromJson = json['products'] as List? ?? [];
    List<StoreProduct> productList = productsFromJson.map((productJson) => StoreProduct.fromJson(productJson)).toList();

    return Receipt(
      storeName: json['store_name'] ?? '',
      storeAddress: json['store_address'] ?? '',
      date: json['date']  ?? '',
      totalReceiptPrice: json['total_receipt_price']  ?? '',
      products: productList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'store_name': storeName,
      'store_address': storeAddress,
      'date': date,
      'total_receipt_price': totalReceiptPrice,
      'products': products.map((product) => product.toJson()).toList(),
    };
  }
}