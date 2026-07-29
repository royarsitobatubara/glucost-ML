import 'package:app/presentation/layouts/screen_layout.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      title: "About Us",
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.black12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.local_hospital,
                  size: 90,
                  color: Color(0xFF5D6CDA),
                ),

                const SizedBox(height: 15),

                const Text(
                  "GLUCOST",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5D6CDA),
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  "Smart Health Monitoring App",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "GLUCOST adalah aplikasi kesehatan berbasis machine learning "
                  "yang membantu pengguna untuk memantau risiko diabetes, "
                  "menghitung BMI, dan memberikan edukasi kesehatan secara cepat dan mudah.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 25),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5D6CDA).withValues(alpha: .08),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        "Fitur Aplikasi",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF5D6CDA),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text("• BMI Calculator"),
                      Text("• Prediksi Risiko Diabetes"),
                      Text("• Konsultasi AI"),
                      Text("• Edukasi Kesehatan"),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF7F32).withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        "Dikembangkan oleh",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Tim GLUCOST - Mobile App Competition",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  "Version 1.0.0",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black45,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}