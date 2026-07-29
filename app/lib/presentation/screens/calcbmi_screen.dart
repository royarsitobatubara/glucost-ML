import 'package:app/presentation/layouts/screen_layout.dart';
import 'package:flutter/material.dart';

class CalcbmiScreen extends StatefulWidget {
  const CalcbmiScreen({super.key});

  @override
  State<CalcbmiScreen> createState() => _CalcbmiScreenState();
}

class _CalcbmiScreenState extends State<CalcbmiScreen> {
  final TextEditingController beratController = TextEditingController();
  final TextEditingController tinggiController = TextEditingController();
  final TextEditingController umurController = TextEditingController();

  String jenisKelamin = 'Laki-laki';

  String bmiResult = '--';
  String kategori = '';
  String rekomendasi = '';

  void hitungBMI() {
    final berat = double.tryParse(beratController.text);
    final tinggi = double.tryParse(tinggiController.text);
    final umur = int.tryParse(umurController.text);

    if (berat == null ||
        tinggi == null ||
        umur == null ||
        tinggi <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon isi semua data dengan benar'),
        ),
      );
      return;
    }

    final tinggiMeter = tinggi / 100;
    final bmi = berat / (tinggiMeter * tinggiMeter);

    String status;
    String saran;

    if (bmi < 18.5) {
      status = "Kurus";
      saran =
          "Perbanyak asupan nutrisi dan konsultasikan dengan ahli gizi.";
    } else if (bmi < 25) {
      status = "Normal";
      saran =
          "Berat badan Anda ideal. Pertahankan pola hidup sehat.";
    } else if (bmi < 30) {
      status = "Gemuk";
      saran =
          "Mulailah mengatur pola makan dan rutin berolahraga.";
    } else {
      status = "Obesitas";
      saran =
          "Disarankan berkonsultasi dengan tenaga kesehatan untuk mendapatkan penanganan lebih lanjut.";
    }

    setState(() {
      bmiResult = bmi.toStringAsFixed(1);
      kategori = status;
      rekomendasi = saran;
    });
  }

  @override
  void dispose() {
    beratController.dispose();
    tinggiController.dispose();
    umurController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      title: 'Calc BMI',
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
                  Icons.monitor_weight_outlined,
                  size: 80,
                  color: Color(0xFF5D6CDA),
                ),

                const SizedBox(height: 15),

                const Text(
                  "BMI Calculator",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5D6CDA),
                  ),
                ),

                const SizedBox(height: 25),

                TextField(
                  controller: beratController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Berat Badan (kg)",
                    prefixIcon: const Icon(Icons.fitness_center),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: tinggiController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Tinggi Badan (cm)",
                    prefixIcon: const Icon(Icons.height),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: umurController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Umur (Tahun)",
                    prefixIcon: const Icon(Icons.cake_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                DropdownButtonFormField<String>(
                  initialValue: jenisKelamin,
                  decoration: InputDecoration(
                    labelText: "Jenis Kelamin",
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Laki-laki',
                      child: Text('Laki-laki'),
                    ),
                    DropdownMenuItem(
                      value: 'Perempuan',
                      child: Text('Perempuan'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      jenisKelamin = value!;
                    });
                  },
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: hitungBMI,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5D6CDA),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Hitung BMI",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF7F32).withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Hasil BMI",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        bmiResult,
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5D6CDA),
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        kategori,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xFFFF7F32),
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const Divider(height: 30),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Jenis Kelamin",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(jenisKelamin),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Umur",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            umurController.text.isEmpty
                                ? "-"
                                : "${umurController.text} Tahun",
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      Text(
                        rekomendasi,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
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