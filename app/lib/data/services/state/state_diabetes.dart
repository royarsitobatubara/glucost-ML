import 'package:app/data/services/api_service.dart';
import 'package:flutter/material.dart';
import '../temp/temp_diabetes.dart';
import '../../../presentation/widgets/charts/chart_diabetes.dart';
import '../../../presentation/widgets/chats/button_retry.dart';
import '../base_chat_state.dart';
import '../chat_message.dart';

class DiabetesChatState extends BaseChatState implements ChangeNotifier {
  TempDiabetes tempData = TempDiabetes();

  bool isUndoing = false;
  @override
  bool isLoading = false;
  @override
  final List<ChatMessage> messages = [];

  @override
  // ignore: overridden_fields
  int currentQuestion = 0;

   @override
  final List<String> questions = [
    "Berapa jumlah kehamilan (Pregnancies)?",
    "Berapa kadar Glucose (mg/dL)?",
    "Berapa Blood Pressure (mmHg)?",
    "Berapa Skin Thickness (mm)?",
    "Berapa Insulin (mu U/ml)?",
    "Berapa BMI?",
    "Berapa Diabetes Pedigree Function?",
    "Berapa umur Anda?",
  ];

  DiabetesChatState() {
    messages.add(ChatMessage(
      type: 'text',
      text: questions[0],
      isUser: false,
    ));
  }

  Future<void> restart() async {
    isLoading = true;
    currentQuestion = 0;

    tempData.reset();
    messages.clear();

    _addTyping();
    await _thinkingDelay(800);
    _removeTyping();

    messages.add(ChatMessage(
      type: 'text',
      text: questions[0],
      isUser: false,
    ));

    isLoading = false;
    notifyListeners();
  }

  @override
  Future<String?> sendMessage(String value) async {
    if (isLoading) return null;
    if (value.trim().isEmpty) return "Input tidak boleh kosong";

    final error = validateInput(currentQuestion, value);
    if (error != null) return error;

    messages.add(ChatMessage(
      type: 'text',
      text: value,
      isUser: true,
    ));

    _saveAnswer(value);
    currentQuestion++;

    if (currentQuestion < questions.length) {
      _addTyping();
      await _thinkingDelay(600);
      _removeTyping();

      messages.add(ChatMessage(
        type: 'text',
        text: questions[currentQuestion],
        isUser: false,
      ));

      notifyListeners();
      return null;
    }

    messages.add(ChatMessage(
      type: 'text',
      text: 'Sedang menganalisis data...',
      isUser: false,
    ));

    isLoading = true;
    notifyListeners();

    try {
      final inputPasien = tempData.toJson();
      final result = await ApiService.diabetesPredict(inputPasien);

      messages.add(ChatMessage(
        type: 'result',
        isUser: false,
        widget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DiabetesChart(
              diabetes: result["probability_diabetes"].toDouble(),
              nonDiabetes: result["probability_non_diabetes"].toDouble(),
            ),
            const SizedBox(height: 16),
            const Text('Hasil Analisis',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('Status: ${result["status"]}'),
            Text('Diabetes: ${result["probability_diabetes"]}%'),
            Text('Non Diabetes: ${result["probability_non_diabetes"]}%'),
            const SizedBox(height: 16),
            RestartButton(
              onRestart: restart,
            ),
          ],
        ),
      ));
    } catch (e) {
      messages.add(ChatMessage(
        type: 'result', // Diubah ke 'result' agar UI merender properti widget Anda
        isUser: false,
        widget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Gagal terhubung ke server atau memproses data.',
              style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            RestartButton(
              onRestart: restart,
            ),
          ],
        ),
      ));
      debugPrint(e.toString());
    }

    isLoading = false;
    notifyListeners();
    return null;
  }

  String? validateInput(int questionIndex, String value) {
    final number = double.tryParse(value);

    if (number == null) return "Input harus berupa angka";

    String limit = "Mohon masukkan jumlah yang benar";

    switch (questionIndex) {
      case 0:
        if (number < 0 || number > 20) return limit;
        break;
      case 1:
        if (number < 0 || number > 300) return limit;
        break;
      case 2:
        if (number < 0 || number > 250) return limit;
        break;
      case 3:
        if (number < 0 || number > 100) return limit;
        break;
      case 4:
        if (number < 0 || number > 1000) return limit;
        break;
      case 5:
        if (number < 0 || number > 100) return limit;
        break;
      case 6:
        if (number < 0 || number > 3) return "DPF harus 0 - 3";
        break;
      case 7:
        if (number < 1 || number > 150) return limit;
        break;
    }
    return null;
  }

  void _saveAnswer(String value) {
    switch (currentQuestion) {
      case 0:
        tempData.pregnancies = int.tryParse(value);
        break;
      case 1:
        tempData.glucose = double.tryParse(value);
        break;
      case 2:
        tempData.bloodPressure = double.tryParse(value);
        break;
      case 3:
        tempData.skinThickness = double.tryParse(value);
        break;
      case 4:
        tempData.insulin = double.tryParse(value);
        break;
      case 5:
        tempData.bmi = double.tryParse(value);
        break;
      case 6:
        tempData.diabetesPedigreeFunction = double.tryParse(value);
        break;
      case 7:
        tempData.age = int.tryParse(value);
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

  Future<void> _thinkingDelay([int ms = 800]) async {
    await Future.delayed(Duration(milliseconds: ms));
  }

  @override
  Future<void> undo() async {
    if (isUndoing) return;
    
    // JIKA HASIL CHART SUDAH MUNCUL (Semua pertanyaan selesai dijawab), KUNCI TOMBOL UNDO
    if (currentQuestion >= questions.length) return; 

    isUndoing = true;
    notifyListeners();

    if (messages.length <= 1) {
      isUndoing = false;
      notifyListeners();
      return;
    }

    // Mengikuti logika hapus bubble chat (pesan user)
    messages.removeLast();
    currentQuestion = (currentQuestion - 1).clamp(0, questions.length);

    isUndoing = false;
    notifyListeners();
  }
}