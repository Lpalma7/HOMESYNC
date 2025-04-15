import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ElectricityUsageChart extends StatelessWidget {
  const ElectricityUsageChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
       padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 60,
          minY: 0,
          groupsSpace: 10,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const days = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
                  return Text(
                    days[value.toInt()],
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  );
                },
                reservedSize: 30,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 10,
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: [
            _generateBarGroup(0, 25), // Sat
            _generateBarGroup(1, 35), // Sun
            _generateBarGroup(2, 20), // Mon
            _generateBarGroup(3, 30), // Tue
            _generateBarGroup(4, 40), // Wed
            _generateBarGroup(5, 30), // Thu
            _generateBarGroup(6, 45), // Fri
          ],
        ),
      ),
    );
  }

  BarChartGroupData _generateBarGroup(int x, double value) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: value,
          color: value > 35 ? const Color(0xFFB0D4F8) : const Color(0xFFEDC2A0),
          width: 15,
        ),
      ],
    );
  }
}
