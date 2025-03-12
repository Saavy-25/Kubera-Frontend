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
  String lineItem;
  String count;
  double totalPrice;
  double? pricePerCount;
  final String? storeName;
  final String? date;
  final List<RecentPrice>? recentPrices; 
  String storeProductName;
  final List<String> genericMatches;
  final String? genericMatchId;

  StoreProduct({
    required this.id,
    required this.lineItem,
    required this.count,
    required this.totalPrice,
    this.pricePerCount,
    this.storeName,
    this.date,
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
    var genericMatchesFromJson = json['genericMatches'] as List? ?? [];
    var genericMatches = genericMatchesFromJson.map((genericMatch) => genericMatch.toString()).toList();
    var recentPricesFromJson = json['recentPrices'] as List? ?? [];
    List<RecentPrice> recentPrices = recentPricesFromJson.map((price) => RecentPrice(
      price: (price as List<dynamic>)[0] as double?,
      timestamp: (price[1] as String),
    )).toList();

    return StoreProduct(
      id: json['_id'],
      lineItem: json['lineItem'] ?? '',
      count: json['count'] ?? '',
      totalPrice: json['totalPrice'] ?? 0.0,
      pricePerCount: json['pricePerCount'] ?? 0.0,
      storeName: json['storeName'] ?? '',
      date: json['date'],
      recentPrices: recentPrices,
      storeProductName: json['storeProductName'] ?? '',
      genericMatches: genericMatches,
      genericMatchId: json['genericMatchId']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'lineItem': lineItem,
      'count': count,
      'totalPrice': totalPrice,
      'pricePerCount': pricePerCount,
      'storeName': storeName,
      'date': date,
      'recentPrices': recentPrices?.map((price) => [price.price, price.timestamp]).toList(),
      'storeProductName': storeProductName,
      'genericMatches': genericMatches,
      'genericMatchId': genericMatchId,
    };
  }
}