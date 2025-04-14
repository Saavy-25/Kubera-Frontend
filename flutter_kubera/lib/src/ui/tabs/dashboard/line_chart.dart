import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LineChartWidget extends StatelessWidget {
  final Map<String, double> data;
  final bool isYearly;
  final bool isMonthly;
  final bool isWeekly;

  LineChartWidget({
    required this.data,
    this.isYearly = false,
    this.isMonthly = false,
    this.isWeekly = false,
  });

  @override
  Widget build(BuildContext context) {
    String format;
    String labelFormat;
    String chartTitle;
    if (isYearly) {
      format = 'yyyy';
      labelFormat = 'yyyy';
      chartTitle = "Yearly Spending";
    } else if (isMonthly) {
      format = 'yyyy-MM';
      labelFormat = 'MM/yy';
      chartTitle = "Monthly Spending";
    } else  {
      format = 'yyyy-MM-dd';
      labelFormat = 'MM/dd';
      chartTitle = "Weekly Spending";
    }

    final dateFormat = DateFormat(format);
    final dateToX = <DateTime, double>{};
    final xToDate = <double, DateTime>{};

    data.keys
        .map((key) => DateFormat(format).parse(key))
        .toList()
        .asMap()
        .forEach((index, date) {
      dateToX[date] = index.toDouble();
      xToDate[index.toDouble()] = date;
    });

    final spots = dateToX.entries
        .map((entry) => FlSpot(entry.value, data[dateFormat.format(entry.key)]!))
        .toList();

    // for y-axis scaling
    final maxY = data.values.reduce((a, b) => a > b ? a : b);
    final minY = data.values.reduce((a, b) => a < b ? a : b);
    final bufferedMaxY = maxY + (maxY * 0.1);
    final bufferedMinY = minY - (minY * 0.1);

    // for preventing rightmost value from being clipped
    final maxX = dateToX.length - 1.toDouble();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
      child: Column(
        children: [
          Text(
            chartTitle,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 200,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: maxX,
                minY: bufferedMinY,
                maxY: bufferedMaxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    barWidth: 2,
                    dotData: FlDotData(show: true),
                    color: Color.fromARGB(255, 152, 91, 87),
                  ),
                ],
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final date = xToDate[value];
                        if (date == null) return const SizedBox.shrink();
                        return SideTitleWidget(
                          meta: meta,
                          child: Transform.rotate(
                            angle: 45 * 3.14 / 180,
                            child: Text(
                              DateFormat(labelFormat).format(date),
                              style: const TextStyle(fontSize: 10),
                            ),
                          )
                        );
                      },
                      interval: 1,
                      reservedSize: 32,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toStringAsFixed(2),
                          style: TextStyle(fontSize: 8),
                        );
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: false,
                  verticalInterval: 1,
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: Color.fromARGB(76, 0, 0, 0),
                      strokeWidth: 0.5,
                    );
                  },
                ),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    left: BorderSide(color: Color.fromARGB(76, 0, 0, 0), width: 0.5),
                    right: BorderSide(color: Color.fromARGB(76, 0, 0, 0), width: 0.5),
                    top: BorderSide(color: Colors.transparent),
                    bottom: BorderSide(color: Colors.transparent),
                  ),
                ),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) =>
                        const Color.fromARGB(255, 221, 200, 200),
                    tooltipPadding: const EdgeInsets.all(2),
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((LineBarSpot touchedSpot) {
                        String value = touchedSpot.y.toStringAsFixed(2);
                        return LineTooltipItem(
                          '\$$value',
                          TextStyle(color: Color.fromARGB(255, 152, 91, 87), fontSize: 12),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
