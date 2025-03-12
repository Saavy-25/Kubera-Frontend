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
  int count;
  double totalPrice;
  double? pricePerCount;
  final String? storeName;
  final String? date;
  final List<RecentPrice>? recentPrices; 
  String storeProductName;
  final List<String> genericMatches;
  String genericMatch;
  final String? genericId;

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
    this.genericMatch = '',
    this.genericId,
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
    genericMatch = newGenericMatch;
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
      id: json['_id'] ?? '',
      recentPrices: recentPrices,
      lineItem: json['lineItem'] ?? '',
      count: json['count'] ?? 1,
      totalPrice: json['totalPrice'] ?? 0.0,
      pricePerCount: json['pricePerCount'] ?? 0.0,
      storeName: json['storeName'] ?? '',
      date: json['date'],
      storeProductName: json['storeProductName'] ?? '',
      genericMatches: genericMatches,
      genericMatch: genericMatches.isNotEmpty ? genericMatches[0] : '',
      genericId: json['genericId']
    );
  }

  Map<String, dynamic> toJson() {
    if (genericMatches.isNotEmpty) {
      genericMatches[0] = genericMatch;
    }
    
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
      'genericId': genericId,
    };
  }
}