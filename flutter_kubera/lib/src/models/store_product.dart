class PricesTimes {
  final double? price;
  final DateTime? timestamp;

  PricesTimes({
    required this.price,
    required this.timestamp,
  });
}

class StoreProduct {
  final String pk;
  final String? unit;
  final String genericPk;
  final List<PricesTimes>? pricesTimes;
  final String? lineItem;
  final List<String>? genericMatches;
  final String productName;
  final String? genericName;
  final String? storeName;
  final String? storeAddress;

  StoreProduct({
    required this.pk,
    this.unit,
    required this.genericPk,
    this.pricesTimes,
    this.lineItem,
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
      pk: json['_id'] ?? '',
      unit: json['unit'] ?? '',
      genericPk: json['genericPk'] ?? '',
      pricesTimes: (json['pricesTimes'] as List<dynamic>?)
          ?.map((price) => PricesTimes(
        price: (price as List<dynamic>)[0] as double?,
        timestamp: DateTime.parse((price[1] as String)),
          ))
          .toList() ?? [],
      lineItem: json['lineItem'] ?? '',
      genericMatches: genericMatches.isNotEmpty ? genericMatches : [],
      productName: json['productName'] ?? '',
      genericName: json['genericName'] ?? '',
      storeName: json['storeName'] ?? '',
      storeAddress: json['storeAddress'] ?? '',
        );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': pk,
      'unit': unit,
      'genericPk': genericPk,
      'pricesTimes': pricesTimes?.map((price) => [price.price, price.timestamp?.toIso8601String()]).toList(),
      'lineItem': lineItem,
      'generic_matches': genericMatches,
      'productName': productName,
      'genericName': genericName,
      'storeName': storeName,
      'storeAddress': storeAddress,
    };
  }
}