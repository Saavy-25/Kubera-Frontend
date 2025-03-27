import 'package:flutter_kubera/src/models/store_address.dart';

class LineItem {
  double pricePerCount;
  String storeProductId;
  int count;

  LineItem({
    required this.pricePerCount,
    required this.storeProductId,
    required this.count,
  });

  factory LineItem.fromJson(Map<String, dynamic> json) {
    return LineItem(
      pricePerCount: json['pricePerCount'] ?? 0.0,
      storeProductId: json['storeProductId'] ?? '',
      count: json['count'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pricePerCount': pricePerCount,
      'storeProductId': storeProductId,
      'count': count,
    };
  }
}


class Receipt {
  final String id;
  String storeName;
  final StoreAddress storeAddress;
  String date;
  final double totalReceiptPrice;
  List<LineItem> products;

  Receipt({
    required this.id,
    required this.storeName,
    required this.storeAddress,
    required this.date,
    required this.totalReceiptPrice,
    required this.products
  });

  static Receipt empty() {
    return Receipt(id: '', storeName: '', storeAddress: StoreAddress(), date: '', totalReceiptPrice: 0.0, products: []);
  }

  void updateStoreName(String newStoreName) {
    storeName = newStoreName;
    
  }

  void updateDate(String newDate) {
    date = newDate;
  }

  factory Receipt.fromJson(Map<String, dynamic> json) {
    var productsFromJson = json['products'] as List? ?? [];
    List<LineItem> productList = productsFromJson.map((productJson) => LineItem.fromJson(productJson)).toList();

    return Receipt(
      id: json['_id'] ?? '',
      storeName: json['storeName'] ?? '',
      storeAddress: json['storeAddress'] ?? '',
      date: json['date']  ?? '',
      totalReceiptPrice: json['totalReceiptPrice']  ?? 0.0,
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