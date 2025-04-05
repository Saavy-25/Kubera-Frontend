class RecentPrice {
  final double price;
  final String latestDate; // Converting Mongo's Date to String for now
  final String oldestDate;
  final int reports;

  RecentPrice({
    required this.price,
    required this.latestDate,
    required this.oldestDate,
    required this.reports,
  });

  factory RecentPrice.fromJson(Map<String, dynamic> json) {
    
    return RecentPrice(
      price: json['price'] as double,
      latestDate: json['latestDate'] as String,
      oldestDate: json['oldestDate'] as String,
      reports: json['reports'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'latestDate': latestDate,
      'oldestDate': oldestDate,
      'reports': reports,
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
        if (price is Map<String, dynamic> &&
            price.containsKey('price') &&
            price.containsKey('latestDate') &&
            price.containsKey('oldestDate') &&
            price.containsKey('reports') &&
            price['price'] is double &&
            price['latestDate'] is String &&
            price['oldestDate'] is String &&
            price['reports'] is int) {
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
      id: json['_id'] ?? '',
      recentPrices: recentPrices,
      storeName: json['storeName'] ?? '',
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