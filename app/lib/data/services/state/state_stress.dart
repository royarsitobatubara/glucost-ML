import 'package:app/data/services/api_service.dart';
import 'package:app/presentation/widgets/charts/chart_stress.dart';
import 'package:flutter/material.dart';
import '../temp/temp_stress.dart'; // Sesuaikan path ini
import '../base_chat_state.dart';
import '../chat_message.dart';

class StateStress extends BaseChatState implements ChangeNotifier {
  final TempStress tempData = TempStress();

  @override
  bool isLoading = false;
  bool isUndoing = false;

  @override
  final List<ChatMessage> messages = [];

  @override
  final List<String> questions = [
    "Berapa tingkat kelembapan (Humidity) lingkungan Anda saat ini? (Contoh: 60.5)",
    "Berapa suhu (Temperature) ruangan Anda saat ini? (°C, contoh: 25.0)",
    "Berapa total jumlah langkah kaki (Step Count) Anda hari ini? (Contoh: 5000)",
  ];

  StateStress() {
    // Memulai chat dengan pertanyaan pertama
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
        text: 'Sedang menganalisis tingkat stres Anda...',
        isUser: false,
      ),
    );

    isLoading = true;
    notifyListeners();

    try {
      // Pastikan kamu punya fungsi stressPredict di ApiService
      final result = await ApiService.stressPredict(tempData.toJson());

      messages.add(
        ChatMessage(
          type: 'result',
          isUser: false,
          widget: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hasil Analisis Stres',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text('Prediksi: ${result["prediction"]}'),
              Text('Skor Keyakinan: ${result["confidence_score"] ?? "-"}%'),
              const Divider(),
              const SizedBox(height: 8),
              // Jika model kamu multiclass (0, 1, 2), akan dimunculkan detailnya
              if (result.containsKey("class_0_probability"))
                Text('Probabilitas Kelas 0: ${result["class_0_probability"]}'),
              if (result.containsKey("class_1_probability"))
                Text('Probabilitas Kelas 1: ${result["class_1_probability"]}'),
              if (result.containsKey("class_2_probability"))
                Text('Probabilitas Kelas 2: ${result["class_2_probability"]}'),
              const SizedBox(height: 8),
              const Divider(),
              ChartStress(result: result),
              const SizedBox(height: 8),
              Text(
                'Pesan: ${result["message"] ?? ""}',
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
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
          type: 'result',
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
    final number = double.tryParse(value);
    if (number == null) return "Input harus berupa angka";

    switch (questionIndex) {
      case 0: // Humidity
        if (number < 0 || number > 100) return "Masukkan nilai kelembapan antara 0 hingga 100";
        break;
      case 1: // Temperature
        if (number < -10 || number > 60) return "Masukkan nilai suhu yang masuk akal (°C)";
        break;
      case 2: // Step Count
        if (number < 0) return "Jumlah langkah tidak bisa minus";
        final intNumber = int.tryParse(value);
        if (intNumber == null) return "Jumlah langkah harus berupa bilangan bulat";
        break;
    }
    return null;
  }

  void _saveAnswer(String value) {
    final doubleValue = double.tryParse(value);
    final intValue = int.tryParse(value);

    switch (currentQuestion) {
      case 0:
        tempData.humidity = doubleValue;
        break;
      case 1:
        tempData.temperature = doubleValue;
        break;
      case 2:
        tempData.stepCount = intValue;
        break;
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

    // Menghapus jawaban user dan pertanyaan bot sebelumnya
    messages.removeLast(); 
    currentQuestion = (currentQuestion - 1).clamp(0, questions.length);

    isUndoing = false;
    notifyListeners();
  }
}