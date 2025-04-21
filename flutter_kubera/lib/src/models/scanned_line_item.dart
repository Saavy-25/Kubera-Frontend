class ScannedLineItem {
  final String id;
  String lineItem;
  int count;
  double totalPrice;
  double? pricePerCount;
  final String? storeName;
  final String? date;
  String storeProductName;
  final List<String> genericMatches;
  String genericMatch;

  ScannedLineItem({
    required this.id,
    required this.lineItem,
    required this.count,
    required this.totalPrice,
    this.pricePerCount,
    this.storeName,
    this.date,
    required this.storeProductName,
    required this.genericMatches,
    this.genericMatch = '',
  });
  
  factory ScannedLineItem.fromJson(Map<String, dynamic> json) {
    var genericMatchesFromJson = json['genericMatches'] as List? ?? [];
    var genericMatches = genericMatchesFromJson.map((genericMatch) => genericMatch.toString()).toList();

    return ScannedLineItem(
      id: json['_id'] ?? '',
      lineItem: json['lineItem'] ?? '',
      count: json['count'] ?? 1,
      totalPrice: json['totalPrice'] ?? 0.0,
      pricePerCount: json['pricePerCount'] ?? 0.0,
      storeName: json['storeName'] ?? '',
      date: json['date'],
      storeProductName: json['storeProductName'] ?? '',
      genericMatches: genericMatches,
      genericMatch: genericMatches.isNotEmpty ? genericMatches[0] : ''
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
      'storeProductName': storeProductName,
      'genericMatches': genericMatches
    };
  }
}