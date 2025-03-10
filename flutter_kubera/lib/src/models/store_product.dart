
class StoreProduct {
  String lineItem;
  String count;
  double totalPrice;
  double? pricePerCount;
  final String? storeName;
  final List<String>? recentPrices; // TODO: Change to List<RecentPrice> once Vy's changes are merged in
  String storeProductName;
  final List<String>? genericMatches;
  final String? genericMatchId;
  String? genericMatch;

  StoreProduct({
    required this.lineItem,
    required this.count,
    required this.totalPrice,
    this.pricePerCount,
    this.storeName,
    this.recentPrices,
    required this.storeProductName,
    this.genericMatches,
    this.genericMatchId,
    this.genericMatch,
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
  
  factory StoreProduct.fromJson(Map<String, dynamic> json) {
    var genericMatchesFromJson = json['generic_matches'] as List? ?? [];
    var genericMatches = genericMatchesFromJson.map((genericMatch) => genericMatch.toString()).toList();

    return StoreProduct(
      lineItem: json['line_item'] ?? '',
      count: json['count'] ?? '',
      totalPrice: json['total_price'] ?? 0.0,
      pricePerCount: json['price_per_count'] ?? 0.0,
      storeName: json['store_name'],
      recentPrices: json['recent_prices']?.cast<String>(),
      storeProductName: json['store_product_name'] ?? '',
      genericMatches: genericMatches,
      genericMatchId: json['generic_match_id'],
      genericMatch: json['generic_match']
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
      'generic_match_id': genericMatchId,
      'generic_match': genericMatch,
    };
  }
}