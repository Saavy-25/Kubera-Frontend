class RecentPrice {
  final double? price;
  final String? timestamp; // Converting Mongo's Date to String for now

  RecentPrice({
    required this.price,
    required this.timestamp,
  });
}

class StoreProduct {
  String lineItem;
  String count;
  double totalPrice;
  double? pricePerCount;
  final String? storeName;
  final List<RecentPrice>? recentPrices; 
  String storeProductName;
  final List<String> genericMatches;
  final String? genericMatchId;

  StoreProduct({
    required this.lineItem,
    required this.count,
    required this.totalPrice,
    this.pricePerCount,
    this.storeName,
    this.recentPrices,
    required this.storeProductName,
    required this.genericMatches,
    this.genericMatchId,
  });

  // Method to update the fields
  void updateLineItem(String newLineItem) {
    lineItem = newLineItem;
  }

  void updateProductName(String storeProductName) {
    storeProductName = storeProductName;
  }

  void updatePrice(double totalPrice) {
    totalPrice = totalPrice;
  }

  void updateGenericMatch(String newGenericMatch) {
    genericMatches[0] = newGenericMatch;
  }
  
  factory StoreProduct.fromJson(Map<String, dynamic> json) {
    var genericMatchesFromJson = json['generic_matches'] as List? ?? [];
    var genericMatches = genericMatchesFromJson.map((genericMatch) => genericMatch.toString()).toList();

    return StoreProduct(
      lineItem: json['line_item'] ?? '',
      count: json['count'] ?? '',
      totalPrice: json['total_price'] ?? 0.0,
      pricePerCount: json['price_per_count'] ?? 0.0,
      storeName: json['store_name'],
      recentPrices: (json['recentPrices'] as List<dynamic>?)
          ?.map((price) => RecentPrice(
        price: (price as List<dynamic>)[0] as double?,
        timestamp: (price[1] as String),
          ))
          .toList() ?? [],
      storeProductName: json['store_product_name'] ?? '',
      genericMatches: genericMatches,
      genericMatchId: json['generic_match_id']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'line_item': lineItem,
      'count': count,
      'total_price': totalPrice,
      'price_per_count': pricePerCount,
      'store_name': storeName,
      'recent_prices': recentPrices,
      'store_product_name': storeProductName,
      'generic_matches': genericMatches,
      'generic_match_id': genericMatchId
    };
  }
}