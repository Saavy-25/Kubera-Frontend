
import 'dart:ffi';

class StoreProduct {
  final String? pk;
  final String? genericPk;
  // final DateTime date; THIS IS NOW STORES AT THE RECEIPT LEVEL
  final String lineItem;
  final Int? count;
  final String? unit;
  final double unitPrice;
  final double totalPrice;
  final List<String>? genericMatches;
  final String? productName;
  final String? genericName;

  StoreProduct({
    required this.pk,
    required this.genericPk,
    // required this.date,
    required this.lineItem,
    required this.count,
    required this.unit,
    required this.unitPrice,
    required this.totalPrice,
    required this.genericMatches,
    required this.productName,
    required this.genericName,
  });


  factory StoreProduct.fromJson(Map<String, dynamic> json) {
    var genericMatchesFromJson = json['generic_matches'] as List? ?? [];
    var genericMatches = genericMatchesFromJson.map((genericMatch) => genericMatch.toString()).toList();

    return StoreProduct(
      pk: json['pk'],
      genericPk: json['generic_pk'],
      // date: DateTime.parse(json['date']),
      lineItem: json['line_item'],
      count: json['count']?.toInt(),
      unit: json['unit'],
      unitPrice: json['unitPrice']?.toDouble(),
      totalPrice: json['totalPrice']?.toDouble(),
      genericMatches: genericMatches,
      productName: json['product_name'],
      genericName: json['generic_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pk': pk,
      'generic_pk': genericPk,
      // 'date': date.toIso8601String(),
      'line_item': lineItem,
      'count': count,
      'unit': unit,
      'unit_price': unitPrice,
      'total_price': totalPrice,
      'generic_matches': genericMatches,
      'product_name': productName,
      'generic_name': genericName,
    };
  }
}