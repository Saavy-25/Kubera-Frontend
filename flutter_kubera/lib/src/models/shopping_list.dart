class ListItem {
  String productName;
  String storeProductId;
  bool retrieved;

  ListItem({
    required this.productName,
    required this.storeProductId,
    this.retrieved = false,
  });

  factory ListItem.fromJson(Map<String, dynamic> json) {
    return ListItem(
      productName: json['productName'] ?? '',
      storeProductId: json['storeProductId'] ?? '',
      retrieved: json['retrieved'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'storeProductId': storeProductId,
      'retrieved': retrieved,
    };
  }

  void toggleChecked() {
    retrieved = !retrieved;
  }
}

class ShoppingList {
  String id;
  String listName;
  List<ListItem> items;
  String date;

  ShoppingList({
    required this.id,
    required this.listName,
    required this.items,
    required this.date,
  });

  factory ShoppingList.fromJson(Map<String, dynamic> json) {
    var itemsFromJson = json['items'] as List? ?? [];
    List<ListItem> items = itemsFromJson.map((item) => ListItem.fromJson(item)).toList();

    return ShoppingList(
      id: json['id'] ?? '',
      listName: json['listName'] ?? '',
      items: items,
      date: json['date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'listName': listName,
      'items': items.map((item) => item.toJson()).toList(),
      'date': date,
    };
  }
}