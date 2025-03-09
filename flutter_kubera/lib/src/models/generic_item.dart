class GenericItem {
  final String? pk;
  final String? genericItem;
  final List<String>? productIds;
  final String? category;

  GenericItem({
    required this.pk,
    required this.genericItem,
    required this.productIds,
    required this.category,
  });

  factory GenericItem.fromJson(Map<String, dynamic> json) {
    return GenericItem(
      pk: json['_id'],
      genericItem: json['genericItem'],
      productIds: json.containsKey('productIds') ? List<String>.from(json['productIds']) : [],
      category: json.containsKey('category') ? json['category'] as String? : 'No category',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': pk, 
      'genericItem': genericItem,
      'productIds': productIds,
      'category': category,
    };
  }
}