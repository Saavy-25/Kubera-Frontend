
class StoreProduct {
  final String? pk;
  final String? unit;
  final String? genericPk;
  double price;
  final DateTime date;
  String lineItem;
  final List<String>? genericMatches;
  String? productName;
  String? genericName;

  StoreProduct({
    required this.pk,
    required this.unit,
    required this.genericPk,
    required this.price,
    required this.date,
    required this.lineItem,
    required this.genericMatches,
    required this.productName,
    required this.genericName,
  });

  // Method to update the fields
  void updateLineItem(String newLineItem) {
    lineItem = newLineItem;
  }

  void updateProductName(String newProductName) {
    productName = newProductName;
  }

  void updatePrice(double newPrice) {
    price = newPrice;
  }
  
  factory StoreProduct.fromJson(Map<String, dynamic> json) {
    var genericMatchesFromJson = json['generic_matches'] as List? ?? [];
    var genericMatches = genericMatchesFromJson.map((genericMatch) => genericMatch.toString()).toList();

    return StoreProduct(
      pk: json['pk'],
      unit: json['unit'],
      genericPk: json['generic_pk'],
      price: json['price']?.toDouble(),
      date: DateTime.parse(json['date']),
      lineItem: json['line_item'],
      genericMatches: genericMatches,
      productName: json['product_name'],
      genericName: json['generic_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pk': pk,
      'unit': unit,
      'generic_pk': genericPk,
      'price': price,
      'date': date.toIso8601String(),
      'line_item': lineItem,
      'generic_matches': genericMatches,
      'product_name': productName,
      'generic_name': genericName,
    };
  }
}