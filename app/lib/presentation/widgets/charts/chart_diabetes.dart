import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DiabetesChart extends StatelessWidget {
  final double diabetes;
  final double nonDiabetes;

  const DiabetesChart({
    super.key,
    required this.diabetes,
    required this.nonDiabetes,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: PieChart(
        PieChartData(
          sectionsSpace: 3,
          centerSpaceRadius: 55,
          startDegreeOffset: -90,
          pieTouchData: PieTouchData(enabled: true),
          sections: [
            PieChartSectionData(
              value: diabetes,
              color: Colors.redAccent,
              radius: 50,
              title: '${diabetes.toStringAsFixed(1)}%',
              titleStyle: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w800,
                shadows: [
                  Shadow(
                    color: Colors.black45,
                    blurRadius: 15,
                    offset: Offset(1, 1),
                  )
                ],
              ),
            ),
            PieChartSectionData(
              value: nonDiabetes,
              color: Colors.greenAccent.shade700,
              radius: 50,
              title: '${nonDiabetes.toStringAsFixed(1)}%',
              titleStyle: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w800,
                shadows: [
                  Shadow(
                    color: Colors.black45,
                    blurRadius: 15,
                    offset: Offset(1, 1),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}