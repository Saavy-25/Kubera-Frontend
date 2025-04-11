import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../models/dashboard.dart';
import '../../../models/test.dart';
import '../../../services/flask_service.dart';
import 'line_chart.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({super.key});

  final DashboardData fakeData = DashboardData(
    userId: "fakeUserID",
    weeklySpending: {
      "2024-03-31": 30.0,
      "2024-04-07": 25.0,
      "2024-04-14": 35.0,
      "2024-04-21": 40.0,
      "2024-04-28": 50.0,
    },
    monthlySpending: {
      "2024-03": 30.0,
      "2024-04": 150.0,
    },
    yearlySpending: {
      "2024": 180.0,
    },
    averageGroceryRunCost: 40.0,
    mostExpensiveItem: MostExpensiveItem(
      name: "Organic Avocados",
      price: 5.99,
      date: "2024-04-05",
    ),
    favoriteItems: [
      FavoriteItem(date: "2024-04", name: "Apples", frequency: 15),
      FavoriteItem(date: "2024-03", name: "Bananas", frequency: 12),
    ],
  );

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<Test> futureTest;
  bool _isExpanded = false; // expanding favorite items

  @override
  void initState() {
    super.initState();
    futureTest = FlaskService().fetchTest();
  }

  @override
  Widget build(BuildContext context) {
    final dataToGraphWeekly = widget.fakeData.weeklySpending;
    final dataToGraphMonthly = widget.fakeData.monthlySpending;
    final dataToGraphYearly = widget.fakeData.yearlySpending;

    final mostExpensiveItem = widget.fakeData.mostExpensiveItem;
    final favoriteItem = widget.fakeData.favoriteItems[0]; 
    final previousFavoriteItems = widget.fakeData.favoriteItems
        .skip(1)
        .map((item) => '${item.date} ${item.name}: ${item.frequency} times ')
        .join("\n");

    return Scaffold(
      appBar: AppBar(title: const Text("Kubera")),
      body: Center(
        child: FutureBuilder<Test>(
          future: futureTest,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // line graph section
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
                          Text(
                            "Average Grocery Run",
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            "\$${widget.fakeData.averageGroceryRunCost}",
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Average Spent Each Month",
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            "\$${widget.fakeData.monthlySpending.values.reduce((a, b) => a + b) / widget.fakeData.monthlySpending.length}",
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Priciest Item This Month",
                            style: TextStyle(fontSize: 12),
                          ),
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
                          Text(
                            "Favorite Item This Month",
                            style: TextStyle(fontSize: 12),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color,),
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
                                icon: Icon(
                                  _isExpanded
                                      ? Icons.expand_less
                                      : Icons.expand_more,
                                ),
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
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
