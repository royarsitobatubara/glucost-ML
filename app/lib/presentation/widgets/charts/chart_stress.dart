import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartStress extends StatelessWidget {
  final Map<String, dynamic> result;

  const ChartStress({
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

    // Ambil data probabilitas masing-masing kelas stres dari response JSON
    // Jika model kamu hanya 2 kelas (Binary), class_2_probability akan bernilai 0.0 otomatis
    final rawData = {
      'Stres Rendah': parsePercent(result['class_0_probability']),
      'Stres Sedang': parsePercent(result['class_1_probability']),
      'Stres Tinggi': parsePercent(result['class_2_probability']),
    };

    // Definisikan warna untuk masing-masing tingkat stres
    final colors = {
      'Stres Rendah': Colors.greenAccent.shade700,
      'Stres Sedang': Colors.orangeAccent,
      'Stres Tinggi': Colors.redAccent,
    };

    // Konfigurasi bayangan teks (Shadows) persis seperti ObesitasChart
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
            radius: 50, // Mengikuti radius ObesitasChart
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
          height: 220, // Mengikuti height ObesitasChart
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
                  entry.key, 
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