class RecentPrices {
  final double? price;
  final String? timestamp; // Converting Mongo's Date to String for now

  RecentPrices({
    required this.price,
    required this.timestamp,
  });
}

class StoreProduct {
  final String id;
  final String genericId;
  final List<RecentPrices>? recentPrices;
  final String lineItem;
  final List<String>? genericMatches;
  final String productName;
  final String? genericName;
  final String? storeName;
  final String? storeAddress;

  StoreProduct({
    required this.id,
    required this.genericId,
    this.recentPrices,
    required this.lineItem,
    this.genericMatches,
    required this.productName,
    this.genericName,
    this.storeName,
    this.storeAddress,
  });


  factory StoreProduct.fromJson(Map<String, dynamic> json) {
    var genericMatchesFromJson = json['generic_matches'] as List? ?? [];
    var genericMatches = genericMatchesFromJson.map((genericMatch) => genericMatch.toString()).toList();

    return StoreProduct(
      id: json['_id'] ?? '',
      genericId: json['genericId'] ?? '',
      recentPrices: (json['recentPrices'] as List<dynamic>?)
          ?.map((price) => RecentPrices(
        price: (price as List<dynamic>)[0] as double?,
        timestamp: (price[1] as String),
          ))
          .toList() ?? [],
      lineItem: json['lineItem'] ?? '',
      genericMatches: genericMatches.isNotEmpty ? genericMatches : [],
      productName: json['storeProductName'] ?? '',
      genericName: json['genericName'] ?? '',
      storeName: json['storeName'] ?? '',
      storeAddress: json['storeAddress'] ?? '',
        );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'genericPk': genericId,
      'pricesTimes': recentPrices?.map((price) => [price.price, price.timestamp?.toString()]).toList(),
      'lineItem': lineItem,
      'generic_matches': genericMatches,
      'productName': productName,
      'genericName': genericName,
      'storeName': storeName,
      'storeAddress': storeAddress,
    };
  }
}