class ListItem {
  String productName;
  String storeProductId;
  bool isChecked;

  ListItem({
    required this.productName,
    required this.storeProductId,
    this.isChecked = false,
  });

  factory ListItem.fromJson(Map<String, dynamic> json) {
    return ListItem(
      productName: json['productName'] ?? '',
      storeProductId: json['storeProductId'] ?? '',
      isChecked: json['isChecked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'storeProductId': storeProductId,
      'isChecked': isChecked,
    };
  }

  void toggleChecked() {
    isChecked = !isChecked;
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
    if (items.isEmpty) {
      items = [ListItem(productName: '', storeProductId: '')];
    }

    return ShoppingList(
      id: json['_id'] ?? '',
      listName: json['listName'] ?? '',
      items: items,
      date: json['date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'listName': listName,
      'items': items.map((item) => item.toJson()).toList(),
      'date': date,
    };
  }
}