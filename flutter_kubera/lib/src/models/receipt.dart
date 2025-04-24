class LineItem {
  String pricePerCount;
  String storeProductId;
  int count;

  LineItem({
    required this.pricePerCount,
    required this.storeProductId,
    required this.count,
  });

  factory LineItem.fromJson(Map<String, dynamic> json) {
    return LineItem(
      pricePerCount: json['pricePerCount'] ?? '',
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
  final String storeAddress;
  String date;
  final double totalReceiptPrice;
  List<LineItem> lineItems;

  Receipt({
    required this.id,
    required this.storeName,
    required this.storeAddress,
    required this.date,
    required this.totalReceiptPrice,
    required this.lineItems
  });

  static Receipt empty() {
    return Receipt(id: '', storeName: '', storeAddress: '', date: '', totalReceiptPrice: 0.0, lineItems: []);
  }

  void updateStoreName(String newStoreName) {
    storeName = newStoreName;
    
  }

  void updateDate(String newDate) {
    date = newDate;
  }

  factory Receipt.fromJson(Map<String, dynamic> json) {
    var lineItemsFromJson = json['scannedLineItems'] as List? ?? [];
    List<LineItem> lineItemsList = lineItemsFromJson.map((lineItem) => LineItem.fromJson(lineItem)).toList();

    return Receipt(
      id: json['_id'] ?? '',
      storeName: json['storeName'] ?? '',
      storeAddress: json['storeAddress'] ?? '',
      date: json['date']  ?? '',
      totalReceiptPrice: json['totalReceiptPrice']  ?? 0.0,
      lineItems: lineItemsList
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'storeName': storeName,
      'storeAddress': storeAddress,
      'date': date,
      'totalReceiptPrice': totalReceiptPrice,
      'scannedLineItems': lineItems.map((lineItem) => lineItem.toJson()).toList(),
    };
  }
}