class RecentPrice {
  final String price;
  final String lastReportDate; // Converting Mongo's Date to String for now
  final int reportCount;

  RecentPrice({
    required this.price,
    required this.lastReportDate,
    required this.reportCount,
  });

  factory RecentPrice.fromJson(Map<String, dynamic> json) {
    
    return RecentPrice(
      price: json['price'] as String,
      lastReportDate: json['lastReportDate'] as String,
      reportCount: json['reportCount'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'lastReportDate': lastReportDate,
      'reportCount': reportCount,
    };
  }
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
    var recentPricesFromJson = json['recentPrices'] as List? ?? [];
    
    // Validate each price object before adding it to the list
    List<RecentPrice> recentPrices = recentPricesFromJson.map((price) {
      try {
        // Ensure the price conforms to the RecentPrice schema
        if (price.containsKey('price')) {
          return RecentPrice.fromJson(price);
        } else {
          throw Exception('Invalid RecentPrice schema');
        }
      } catch (e) {
        // Skip invalid entries
        return null;
      }
    }).whereType<RecentPrice>().toList(); // Filter out null values

    return StoreProduct(
      id: json['id'] ?? '',
      recentPrices: recentPrices,
      storeName: json['storeName']?.toString().toUpperCase() ?? '',
      storeProductName: json['storeProductName'] ?? '',
      genericId: json['genericId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'storeName': storeName,
      'recentPrices': recentPrices?.map((price) => price.toJson()).toList(),
      'storeProductName': storeProductName,
      'genericId': genericId,
    };
  }
}