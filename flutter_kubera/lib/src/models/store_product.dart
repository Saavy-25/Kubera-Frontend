class RecentPrice {
  final double? price;
  final String? timestamp; // Converting Mongo's Date to String for now

  RecentPrice({
    required this.price,
    required this.timestamp,
  });
}

class StoreProduct {
  final String id;
  String storeProductName;
  final String? storeName;
  final String? genericId;
  final List<RecentPrice>? recentPrices;
  

  StoreProduct({
    required this.id,
    required this.storeProductName,
    this.storeName,
    this.genericId,
    this.recentPrices,
  });

  
  factory StoreProduct.fromJson(Map<String, dynamic> json) {
    var genericMatchesFromJson = json['genericMatches'] as List? ?? [];
    var genericMatches = genericMatchesFromJson.map((genericMatch) => genericMatch.toString()).toList();
    var recentPricesFromJson = json['recentPrices'] as List? ?? [];
    List<RecentPrice> recentPrices = recentPricesFromJson.map((price) => RecentPrice(
      price: (price as List<dynamic>)[0] as double?,
      timestamp: (price[1] as String),
    )).toList();

    return StoreProduct(
      id: json['_id'] ?? '',
      recentPrices: recentPrices,
      storeName: json['storeName'] ?? '',
      storeProductName: json['storeProductName'] ?? '',
      genericId: json['genericId']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'storeName': storeName,
      'recentPrices': recentPrices?.map((price) => [price.price, price.timestamp]).toList(),
      'storeProductName': storeProductName,
      'genericId': genericId,
    };
  }
}