class GenericItem {
  final String? id;
  final String? genericName;
  final List<dynamic>? highlightTexts;

  GenericItem({
    required this.id,
    required this.genericName,
    this.highlightTexts,
  });

  factory GenericItem.fromJson(Map<String, dynamic> json) {
    return GenericItem(
      id: json['_id'],
      genericName: json['genericName'],
      highlightTexts: json.containsKey('highlights') && json['highlights'].isNotEmpty
    ? json['highlights']
        .where((highlight) => highlight is Map<String, dynamic> && highlight.containsKey('texts'))
        .expand((highlight) => highlight['texts'] as List)
        .map((text) => {
          'value': text['value'] ?? '',
          'type': text['type'] ?? '',
        })
        .toList()
    : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id, 
      'genericName': genericName,
    };
  }
}