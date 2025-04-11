class DashboardData {
  final String userId;
  final Map<String, double> weeklySpending;
  final Map<String, double> monthlySpending;
  final Map<String, double> yearlySpending;
  final double averageGroceryRunCost;
  final MostExpensiveItem mostExpensiveItem;
  final List<FavoriteItem> favoriteItems;

  DashboardData({
    required this.userId,
    required this.weeklySpending,
    required this.monthlySpending,
    required this.yearlySpending,
    required this.averageGroceryRunCost,
    required this.mostExpensiveItem,
    required this.favoriteItems,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      userId: json['userId'],
      weeklySpending: Map<String, double>.from(json['weeklySpending']),
      monthlySpending: Map<String, double>.from(json['monthlySpending']),
      yearlySpending: Map<String, double>.from(json['yearlySpending']),
      averageGroceryRunCost: (json['averageGroceryRunCost'] as num).toDouble(),
      mostExpensiveItem: MostExpensiveItem.fromJson(json['mostExpensiveItem']),
      favoriteItems: (json['favoriteItems'] as List<dynamic>)
          .map((item) => FavoriteItem.fromJson(item))
          .toList(),
    );
  }
}

class MostExpensiveItem {
  final String name;
  final double price;
  final String date;

  MostExpensiveItem({
    required this.name,
    required this.price,
    required this.date,
  });

  factory MostExpensiveItem.fromJson(Map<String, dynamic> json) {
    return MostExpensiveItem(
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      date: json['date'],
    );
  }
}

class FavoriteItem {
  final String date;
  final String name;
  final int frequency;

  FavoriteItem({
    required this.date,
    required this.name,
    required this.frequency,
  });

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      date: json['date'],
      name: json['name'],
      frequency: json['frequency'],
    );
  }
}
