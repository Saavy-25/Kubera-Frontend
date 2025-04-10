class GenericItem {
  final String? id;
  final String? genericName;
  final List<String>? productIds;
  final String? category;

  GenericItem({
    required this.id,
    required this.genericName,
    required this.productIds,
    required this.category,
  });

  factory GenericItem.fromJson(Map<String, dynamic> json) {
    return GenericItem(
      id: json['_id'],
      genericName: json['genericName'],
      productIds: json.containsKey('productIds') ? List<String>.from(json['productIds']) : [],
      category: json.containsKey('category') ? json['category'] as String? : 'No category',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id, 
      'genericName': genericName,
      'category': category,
    };
  }
}