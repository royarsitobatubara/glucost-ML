import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ObesitasChart extends StatelessWidget {
  final Map<String, dynamic> result;

  const ObesitasChart({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    // Fungsi pembantu untuk membersihkan string "%" menjadi double numerik
    double parsePercent(dynamic val) {
      if (val == null) return 0.0;
      return double.tryParse(val.toString().replaceAll('%', '')) ?? 0.0;
    }

    // Ambil data probabilitas masing-masing kelas
    final rawData = {
      'Normal Weight': parsePercent(result['Normal_Weight']),
      'Overweight Level I': parsePercent(result['Overweight_Level_I']),
      'Overweight Level II': parsePercent(result['Overweight_Level_II']),
      'Obesity Type I': parsePercent(result['Obesity_Type_I']),
      'Obesity Type II': parsePercent(result['Obesity_Type_II']),
      'Obesity Type III': parsePercent(result['Obesity_Type_III']),
      'Insufficient Weight': parsePercent(result['Insufficient_Weight']),
    };

    // Definisikan warna yang senada dengan gaya visual Anda
    final colors = {
      'Normal Weight': Colors.greenAccent.shade700,
      'Overweight Level I': Colors.orangeAccent,
      'Overweight Level II': Colors.orange.shade800,
      'Obesity Type I': Colors.redAccent.shade200,
      'Obesity Type II': Colors.redAccent,
      'Obesity Type III': Colors.purpleAccent,
      'Insufficient Weight': Colors.blueAccent,
    };

    // Konfigurasi bayangan teks (Shadows) persis seperti DiabetesChart Anda
    const textShadows = [
      Shadow(
        color: Colors.black45,
        blurRadius: 15,
        offset: Offset(1, 1),
      )
    ];

    // Filter data: Hanya tampilkan kategori yang persentasenya > 0%
    final sections = rawData.entries
        .where((entry) => entry.value > 0)
        .map((entry) {
          return PieChartSectionData(
            value: entry.value,
            color: colors[entry.key] ?? Colors.grey,
            radius: 50, // Mengikuti radius Anda
            title: '${entry.value.toStringAsFixed(1)}%',
            titleStyle: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w800,
              shadows: textShadows,
            ),
          );
        }).toList();

    return Column(
      children: [
        SizedBox(
          height: 220, // Mengikuti height Anda
          child: PieChart(
            PieChartData(
              sectionsSpace: 3, // Mengikuti spesifikasi Anda
              centerSpaceRadius: 55, // Mengikuti spesifikasi Anda
              startDegreeOffset: -90, // Mengikuti spesifikasi Anda
              pieTouchData: PieTouchData(enabled: true),
              sections: sections,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Legend Dinamis untuk kategori yang muncul (> 0%)
        Wrap(
          spacing: 12,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: rawData.entries.where((e) => e.value > 0).map((entry) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: colors[entry.key],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  entry.key.replaceAll('_', ' '), // Mengganti underscore dengan spasi agar rapi
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}