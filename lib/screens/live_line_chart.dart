import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LiveLineChart extends StatelessWidget {
  final List<FlSpot> points;
  final String label;

  const LiveLineChart({
    super.key,
    required this.points,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              minY: 0,
              maxY: 4095,
              gridData: FlGridData(show: true),
              borderData: FlBorderData(show: true),
              lineBarsData: [
                LineChartBarData(
                  spots: points,
                  isCurved: true,
                  dotData: FlDotData(show: false),
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
