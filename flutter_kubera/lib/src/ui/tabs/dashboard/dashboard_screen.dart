import 'package:flutter/material.dart';
import 'package:flutter_kubera/src/ui/tabs/settings/authentication/account_profile.dart';
import '../../../models/dashboard.dart';
import '../../../models/test.dart';
import '../../../services/flask_service.dart';
import 'line_chart.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<Test> futureTest; // For development checking whether backend is connected
  late Future<DashboardData?> dashboardData;
  late PageController _pageController; // For swipe indicator
  int _currentPage = 0;
  bool _isExpanded = false; // For favorite item

  @override
  void initState() {
    super.initState();
    futureTest = FlaskService().fetchTest();
    dashboardData = FlaskService().fetchDashboardData(context);
    _pageController = PageController();
    _pageController.addListener(() {
      final page = _pageController.page?.round();
      if (page != null && page != _currentPage) {
        setState(() {
          _currentPage = page;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

 // Section UI helpers
  Widget _buildSection(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 12)),
          Text(value, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildFavoriteItemSection(FavoriteItem favoriteItem, String previousFavoritesText) {
    final isEmpty = favoriteItem.name.isEmpty || favoriteItem.date.isEmpty;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 8, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Favorite Item This Month", style: TextStyle(fontSize: 12)),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: isEmpty
                    ? const Text("No purchases this month",
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))
                    : RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                          children: [
                            TextSpan(
                              text: "${favoriteItem.name} ",
                            ),
                            TextSpan(
                              text: "purchased ${favoriteItem.frequency} times",
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
              ),
              IconButton(
                icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
              ),
            ],
          ),
          if (_isExpanded && !isEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(previousFavoritesText),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Test>(
      future: futureTest,
      builder: (context, testSnapshot) {
        if (testSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (testSnapshot.hasError) {
          return Scaffold(
              body: Center(child: Text('Backend connection failed: ${testSnapshot.error}')));
        } else if (!testSnapshot.hasData) {
          return const Scaffold(body: Center(child: Text('No test data received from backend.')));
        }

        return FutureBuilder<DashboardData?>(
          future: dashboardData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            } else if (snapshot.hasError) {
              return Scaffold(
                  body: Center(child: Text('Error loading dashboard: ${snapshot.error}')));
            } else if (!snapshot.hasData) {
              return Scaffold(
                appBar: AppBar(title: const Text("Kubera")),
                body: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0), // Add horizontal padding
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ProfileScreen(),
                        SizedBox(height: 16),
                        Text(
                          'Sign in to view your spending analytics',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            final dashboard = snapshot.data!;
            final dataToGraphWeekly = dashboard.weeklySpending;
            final dataToGraphMonthly = dashboard.monthlySpending;
            final dataToGraphYearly = dashboard.yearlySpending;

            final mostExpensiveItem = dashboard.mostExpensiveItem;
            final favoriteItem = dashboard.favoriteItems.isNotEmpty
                ? dashboard.favoriteItems[0]
                : FavoriteItem(date: '', name: '', frequency: 0);

            final previousFavoriteItems = dashboard.favoriteItems.length > 1
                ? dashboard.favoriteItems
                    .skip(1)
                    .map((item) => '${item.date} ${item.name}: ${item.frequency} times ')
                    .join("\n")
                : 'No previous favorite items';

            final avgMonthlySpending = dashboard.monthlySpending.isNotEmpty
                ? dashboard.monthlySpending.values.reduce((a, b) => a + b) /
                    dashboard.monthlySpending.length
                : 0.0;

            return Scaffold(
              appBar: AppBar(title: const Text("Kubera")),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Line chart section and dot indicator
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 25.0, 0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 250,
                            child: PageView(
                              controller: _pageController,
                              children: [
                                LineChartWidget(data: dataToGraphWeekly, isWeekly: true),
                                LineChartWidget(data: dataToGraphMonthly, isMonthly: true),
                                LineChartWidget(data: dataToGraphYearly, isYearly: true),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(3, (index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _currentPage == index
                                      ? Color.fromARGB(255, 152, 91, 87)
                                      : Color.fromARGB(106, 143, 141, 141),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 2, 8, 0),
                      child: Text("At a glance...",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),

                    // Avg grocery run, avg spent, most expensive item sections
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 8, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSection("Average Grocery Run",
                              "\$${dashboard.averageGroceryRunCost.toStringAsFixed(2)}"),
                          _buildSection("Average Spent Each Month",
                              "\$${avgMonthlySpending.toStringAsFixed(2)}"),
                          _buildSection(
                            "Priciest Item This Month",
                            mostExpensiveItem.name.isEmpty || mostExpensiveItem.date.isEmpty
                                ? "No purchases this month"
                                : "${mostExpensiveItem.name} - \$${mostExpensiveItem.price.toStringAsFixed(2)}",
                          ),
                        ],
                      ),
                    ),

                    // Favorite item section
                    _buildFavoriteItemSection(favoriteItem, previousFavoriteItems),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
