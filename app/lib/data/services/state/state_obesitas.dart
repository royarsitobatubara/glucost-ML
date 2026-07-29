import 'package:app/data/services/api_service.dart';
import 'package:flutter/material.dart';
import '../temp/temp_obesitas.dart';
import '../base_chat_state.dart';
import '../chat_message.dart';
import '../../../presentation/widgets/charts/chart_obesitas.dart';

class ObesitasChatState extends BaseChatState implements ChangeNotifier {
  final TempObesitas tempData = TempObesitas();

  @override
  bool isLoading = false;
  bool isUndoing = false;

  @override
  final List<ChatMessage> messages = [];

  @override
  final List<String> questions = [
    "Apa jenis kelamin Anda? (Pria/Wanita atau Male/Female)",
    "Berapa umur Anda? (Tahun)",
    "Berapa tinggi badan Anda? (Meter, contoh: 1.65)",
    "Berapa berat badan Anda? (kg, contoh: 70.0)",
    "Apakah ada riwayat obesitas di keluarga Anda? (Ya/Tidak)",
    "Apakah Anda sering mengonsumsi makanan tinggi kalori? (Ya/Tidak)",
    "Berapa kali Anda mengonsumsi sayuran dalam makanan utama? (1 - 3)",
    "Berapa kali Anda makan besar dalam sehari? (1 - 4)",
    "Apakah Anda sering ngemil di antara waktu makan? (Tidak/Kadang/Sering/Selalu)",
    "Apakah Anda merokok? (Ya/Tidak)",
    "Berapa banyak air minum yang Anda konsumsi sehari? (Liter)",
    "Apakah Anda memantau kalori yang Anda konsumsi setiap hari? (Ya/Tidak)",
    "Berapa hari dalam seminggu Anda melakukan aktivitas fisik? (0 - 3)",
    "Berapa jam waktu yang Anda habiskan di depan layar gadget per hari? (0 - 2)",
    "Apakah Anda mengonsumsi alkohol? (Tidak/Kadang/Sering/Selalu)",
    "Apa transportasi yang utama Anda gunakan sehari-hari? (Mobil/Motor/Sepeda/Transportasi Umum/Jalan Kaki)",
  ];

  // Helper untuk normalisasi teks Indonesia/Inggris ke format API Backend
  String _normalizeValue(String input) {
    final clean = input.trim().toLowerCase();
    switch (clean) {
      // Gender
      case 'pria':
      case 'laki-laki':
      case 'laki laki':
      case 'male':
        return 'Male';
      case 'wanita':
      case 'perempuan':
      case 'female':
        return 'Female';
      
      // Yes / No
      case 'ya':
      case 'yes':
        return 'yes';
      case 'tidak':
      case 'no':
        return 'no';

      // Frequency (Ngemil / Alkohol)
      case 'kadang':
      case 'kadang-kadang':
      case 'sometimes':
        return 'Sometimes';
      case 'sering':
      case 'frequently':
        return 'Frequently';
      case 'selalu':
      case 'always':
        return 'Always';

      // Transportasi
      case 'mobil':
      case 'automobile':
        return 'Automobile';
      case 'motor':
      case 'sepeda motor':
      case 'motorbike':
        return 'Motorbike';
      case 'sepeda':
      case 'bike':
        return 'Bike';
      case 'transportasi umum':
      case 'angkot':
      case 'bus':
      case 'public_transportation':
        return 'Public_Transportation';
      case 'jalan kaki':
      case 'jalan':
      case 'walking':
        return 'Walking';
        
      default:
        return input; // Kembalikan nilai asli jika berupa angka
    }
  }

  ObesitasChatState() {
    messages.add(ChatMessage(type: 'text', text: questions[0], isUser: false));
  }

  Future<void> restart() async {
    isLoading = true;
    currentQuestion = 0;
    tempData.reset();
    messages.clear();

    _addTyping();
    await Future.delayed(const Duration(milliseconds: 800));
    _removeTyping();

    messages.add(ChatMessage(type: 'text', text: questions[0], isUser: false));

    isLoading = false;
    notifyListeners();
  }

  @override
  Future<String?> sendMessage(String value) async {
    if (isLoading) return null;
    if (value.trim().isEmpty) return "Input tidak boleh kosong";

    final error = validateInput(currentQuestion, value);
    if (error != null) return error;

    messages.add(ChatMessage(type: 'text', text: value, isUser: true));

    _saveAnswer(value);
    currentQuestion++;

    if (currentQuestion < questions.length) {
      _addTyping();
      await Future.delayed(const Duration(milliseconds: 600));
      _removeTyping();

      messages.add(
        ChatMessage(
          type: 'text',
          text: questions[currentQuestion],
          isUser: false,
        ),
      );

      notifyListeners();
      return null;
    }

    messages.add(
      ChatMessage(
        type: 'text',
        text: 'Sedang menganalisis data obesitas...',
        isUser: false,
      ),
    );

    isLoading = true;
    notifyListeners();

    try {
      final result = await ApiService.obesitasPredict(tempData.toJson());

      messages.add(
        ChatMessage(
          type: 'result',
          isUser: false,
          widget: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hasil Analisis Klasifikasi',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text('Klasifikasi Utama: ${result["result"]}'),
              Text('Skor Keyakinan: ${result["confidence_score"]}%'),
              const Divider(),
              const SizedBox(height: 8),
              ObesitasChart(result: result),
              const SizedBox(height: 8),
              const Divider(),
              Text('Normal Weight: ${result["Normal_Weight"]}'),
              Text('Overweight Level I: ${result["Overweight_Level_I"]}'),
              Text('Overweight Level II: ${result["Overweight_Level_II"]}'),
              Text('Obesity Type I: ${result["Obesity_Type_I"]}'),
              Text('Obesity Type II: ${result["Obesity_Type_II"]}'),
              Text('Obesity Type III: ${result["Obesity_Type_III"]}'),
              Text('Insufficient Weight: ${result["Insufficient_Weight"]}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: restart,
                child: const Text("Mulai Ulang Analisis"),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      messages.add(
        ChatMessage(
          type: 'result', // Diubah menjadi 'result' agar UI merender properti widget di bawah
          isUser: false,
          widget: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Gagal terhubung ke server atau memproses data.',
                style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: restart,
                child: const Text("Mulai Ulang Analisis"),
              ),
            ],
          ),
        ),
      );
      debugPrint(e.toString());
    }

    isLoading = false;
    notifyListeners();
    return null;
  }

  String? validateInput(int questionIndex, String value) {
    final normalized = _normalizeValue(value);

    if ([0, 4, 5, 9, 11].contains(questionIndex)) {
      if (questionIndex == 0 && normalized != 'Male' && normalized != 'Female') {
        return "Masukkan antara 'Pria' atau 'Wanita'";
      }
      if ([4, 5, 9, 11].contains(questionIndex) && normalized != 'yes' && normalized != 'no') {
        return "Masukkan antara 'Ya' atau 'Tidak'";
      }
      return null;
    }

    if ([8, 14].contains(questionIndex)) {
      if (normalized == 'no' || normalized == 'Sometimes' || normalized == 'Frequently' || normalized == 'Always') {
        return null;
      }
      return "Pilihan valid: Tidak, Kadang, Sering, Selalu";
    }

    if (questionIndex == 15) {
      final validTrans = ['Automobile', 'Motorbike', 'Bike', 'Public_Transportation', 'Walking'];
      if (!validTrans.contains(normalized)) {
        return "Pilihan valid: Mobil, Motor, Sepeda, Transportasi Umum, Jalan Kaki";
      }
      return null;
    }

    final number = double.tryParse(value);
    if (number == null) return "Input harus berupa angka numerik";

    switch (questionIndex) {
      case 1:
        if (number < 1 || number > 120) return "Masukkan umur yang valid (1 - 120)";
        break;
      case 2:
        if (number < 0.5 || number > 2.5) return "Masukkan tinggi yang valid dalam meter (contoh: 1.65)";
        break;
      case 3:
        if (number < 10 || number > 300) return "Masukkan berat badan dalam kg yang valid";
        break;
      case 6:
        if (number < 1 || number > 3) return "Masukkan skala konsumsi sayur (1 - 3)";
        break;
      case 7:
        if (number < 1 || number > 4) return "Masukkan jumlah makan besar (1 - 4)";
        break;
      case 10:
        if (number < 0 || number > 10) return "Masukkan jumlah konsumsi air minum yang wajar (Liter)";
        break;
      case 12:
        if (number < 0 || number > 3) return "Masukkan skala aktivitas fisik (0 - 3)";
        break;
      case 13:
        if (number < 0 || number > 2) return "Masukkan skala waktu penggunaan gadget (0 - 2)";
        break;
    }
    return null;
  }

  void _saveAnswer(String value) {
    final normalized = _normalizeValue(value);
    final doubleValue = double.tryParse(value);
    final intValue = int.tryParse(value);

    switch (currentQuestion) {
      case 0: tempData.gender = normalized; break;
      case 1: tempData.age = intValue; break;
      case 2: tempData.height = doubleValue; break;
      case 3: tempData.weight = doubleValue; break;
      case 4: tempData.familyHistory = normalized; break;
      case 5: tempData.favc = normalized; break;
      case 6: tempData.fcvc = doubleValue; break;
      case 7: tempData.ncp = doubleValue; break;
      case 8: tempData.caec = normalized; break;
      case 9: tempData.smoke = normalized; break;
      case 10: tempData.ch2o = doubleValue; break;
      case 11: tempData.scc = normalized; break;
      case 12: tempData.faf = doubleValue; break;
      case 13: tempData.tue = doubleValue; break;
      case 14: tempData.calc = normalized; break;
      case 15: tempData.mtrans = normalized; break;
    }
  }

  void _addTyping() {
    messages.add(ChatMessage(type: 'typing', isUser: false));
    notifyListeners();
  }

  void _removeTyping() {
    messages.removeWhere((e) => e.type == 'typing');
    notifyListeners();
  }

  @override
  Future<void> undo() async {
    if (isUndoing || currentQuestion >= questions.length) return;

    isUndoing = true;
    notifyListeners();

    if (messages.length <= 1) {
      isUndoing = false;
      notifyListeners();
      return;
    }

    messages.removeLast();
    currentQuestion = (currentQuestion - 1).clamp(0, questions.length);

    isUndoing = false;
    notifyListeners();
  }
}