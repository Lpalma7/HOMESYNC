import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartWidget extends StatelessWidget {
  const BarChartWidget({super.key});


 @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[300], // Light background
        borderRadius: BorderRadius.circular(12),
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 60, // Adjust max value
          barGroups: [
            makeGroupData(0, 25, Colors.orange[200]!),
            makeGroupData(1, 35, Colors.lightBlue[200]!),
            makeGroupData(2, 10, Colors.orange[200]!),
            makeGroupData(3, 30, Colors.lightBlue[200]!),
            makeGroupData(4, 45, Colors.orange[200]!),
            makeGroupData(5, 28, Colors.lightBlue[200]!),
            makeGroupData(6, 55, Colors.lightBlue[200]!),
          ],
          titlesData: FlTitlesData(
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false, reservedSize: 40,),
            ),
            
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const days = ['M', 'T', 'W', 'TH', 'F', 'S', 'SU'];
                  return Padding(
                    padding: const EdgeInsets.only(top: 5 ),
                    child: Text(
                      days[value.toInt()],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: false),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 16,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}






