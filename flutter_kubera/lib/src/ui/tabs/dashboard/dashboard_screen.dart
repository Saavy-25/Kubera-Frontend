import 'package:flutter/material.dart';
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
  late Future<Test> futureTest;
  late Future<DashboardData?> dashboardData;
  bool _isExpanded = false; // expanding favorite items

  @override
  void initState() {
    super.initState();
    futureTest = FlaskService().fetchTest();
    dashboardData = FlaskService().fetchDashboardData(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Test>(
      future: futureTest,
      builder: (context, testSnapshot) {
        if (testSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (testSnapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Backend connection failed: ${testSnapshot.error}')),
          );
        }

        // Fetch dashboard data
        return FutureBuilder<DashboardData?>(
          future: dashboardData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              return Scaffold(
                body: Center(child: Text('Error loading dashboard: ${snapshot.error}')),
              );
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Scaffold(
                body: Center(child: Text('No dashboard data available. Please login or scan a receipt to get started')),
              );
            }

            final dashboard = snapshot.data!;
            final dataToGraphWeekly = dashboard.weeklySpending;
            final dataToGraphMonthly = dashboard.monthlySpending;
            final dataToGraphYearly = dashboard.yearlySpending;

            final mostExpensiveItem = dashboard.mostExpensiveItem;
            final favoriteItem = dashboard.favoriteItems[0];
            final previousFavoriteItems = dashboard.favoriteItems
                .skip(1)
                .map((item) => '${item.date} ${item.name}: ${item.frequency} times ')
                .join("\n");

            return Scaffold(
              appBar: AppBar(title: const Text("Kubera")),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Line graph section
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 25.0, 0),
                      child: SizedBox(
                        height: 250,
                        child: PageView(
                          children: [
                            LineChartWidget(data: dataToGraphWeekly, isWeekly: true),
                            LineChartWidget(data: dataToGraphMonthly, isMonthly: true),
                            LineChartWidget(data: dataToGraphYearly, isYearly: true),
                          ],
                        ),
                      ),
                    ),

                    // lower dashboard data
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 8, 8),
                      child: Text(
                        "At a glance...",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),

                    // average grocery run, spent each month, priciest item
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 8, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Average Grocery Run", style: TextStyle(fontSize: 12)),
                          Text(
                            "\$${dashboard.averageGroceryRunCost}",
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text("Average Spent Each Month", style: TextStyle(fontSize: 12)),
                          Text(
                            "\$${dashboard.monthlySpending.values.reduce((a, b) => a + b) / dashboard.monthlySpending.length}",
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text("Priciest Item This Month", style: TextStyle(fontSize: 12)),
                          Text(
                            "${mostExpensiveItem.name} - \$${mostExpensiveItem.price}",
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),

                    // favorite item
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Favorite Item This Month", style: TextStyle(fontSize: 12)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).textTheme.bodyLarge?.color,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "${favoriteItem.name} ",
                                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text: "purchased ${favoriteItem.frequency} times",
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
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
                          if (_isExpanded)
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Text(previousFavoriteItems),
                            ),
                        ],
                      ),
                    ),
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
