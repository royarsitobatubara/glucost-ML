import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartHeartAttack extends StatelessWidget {
  final double riskPercentage;
  final double safePercentage;

  const ChartHeartAttack({
    super.key,
    required this.riskPercentage,
    required this.safePercentage,
  });

  @override
  Widget build(BuildContext context) {
    // 💡 HITUNG OTOMATIS: Sisa persentase untuk area aman

    return SizedBox(
      height: 220,
      child: PieChart(
        PieChartData(
          sectionsSpace: 3,
          centerSpaceRadius: 55,
          startDegreeOffset: -90,
          pieTouchData: PieTouchData(enabled: true),
          sections: [
            // Section 1: Berisiko Serangan Jantung
            PieChartSectionData(
              value: riskPercentage,
              color: Colors.redAccent,
              radius: 50,
              title: '${riskPercentage.toStringAsFixed(1)}%',
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
            // Section 2: Aman / Risiko Rendah
            PieChartSectionData(
              value: safePercentage,
              color: Colors.greenAccent.shade700,
              radius: 50,
              title: '${safePercentage.toStringAsFixed(1)}%',
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