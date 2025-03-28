import 'package:flutter_kubera/src/models/scanned_line_item.dart';

class ScannedReceipt {
  final String id;
  String storeName;
  final String storeAddress;
  String date;
  final double totalReceiptPrice;
  List<ScannedLineItem> scannedLineItems;

  ScannedReceipt({
    required this.id,
    required this.storeName,
    required this.storeAddress,
    required this.date,
    required this.totalReceiptPrice,
    required this.scannedLineItems
  });

  static ScannedReceipt empty() {
    return ScannedReceipt(id: '', storeName: '', storeAddress: '', date: '', totalReceiptPrice: 0.0, scannedLineItems: []);
  }

  void updateStoreName(String newStoreName) {
    storeName = newStoreName;
    
  }

  void updateDate(String newDate) {
    date = newDate;
  }

  factory ScannedReceipt.fromJson(Map<String, dynamic> json) {
    var scannedLineItemsFromJson = json['scannedLineItems'] as List? ?? [];
    List<ScannedLineItem> scannedLineItemList = scannedLineItemsFromJson.map((scannedLineItemJson) => ScannedLineItem.fromJson(scannedLineItemJson)).toList();

    return ScannedReceipt(
      id: json['_id'] ?? '',
      storeName: json['storeName'] ?? '',
      storeAddress: json['storeAddress'] ?? '',
      date: json['date']  ?? '',
      totalReceiptPrice: json['totalReceiptPrice']  ?? 0.0,
      scannedLineItems: scannedLineItemList
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'storeName': storeName,
      'storeAddress': storeAddress,
      'date': date,
      'totalReceiptPrice': totalReceiptPrice,
      'scannedLineItems': scannedLineItems.map((scannedLineItem) => scannedLineItem.toJson()).toList(),
    };
  }
}