import 'package:app/data/services/api_service.dart';
import 'package:app/data/services/base_chat_state.dart';
import 'package:app/data/services/chat_message.dart';
import 'package:app/data/services/temp/temp_heart_attack.dart';
import 'package:app/presentation/widgets/charts/chart_heart_attack.dart';
import 'package:app/presentation/widgets/chats/button_retry.dart'; // Menggunakan RestartButton Anda
import 'package:flutter/material.dart';

class StateHeartAttack extends BaseChatState implements ChangeNotifier {
  final TempHeartAttack tempData = TempHeartAttack();

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
    "Apa jenis kelamin Anda? (Pria/Wanita)",
    "Berapa umur Anda? (Tahun)",
    "Berapa indeks massa tubuh (BMI) Anda? (Boleh dikosongkan/diisi jika tahu, contoh: 24.5)",
    "Apakah Anda merokok? (Ya/Tidak)",
    "Berapa tekanan darah sistolik Anda? (Boleh dikosongkan, angka depan tensi contoh: 120)",
    "Apakah Anda sedang menjalani pengobatan untuk hipertensi/darah tinggi? (Ya/Tidak)",
    "Apakah ada riwayat penyakit kardiovaskular (jantung/pembuluh darah) di keluarga kandung Anda? (Ya/Tidak)",
    "Apakah Anda memiliki riwayat Fibrilasi Atrium (gangguan irama jantung)? (Ya/Tidak)",
    "Apakah Anda memiliki riwayat penyakit ginjal kronis? (Ya/Tidak)",
    "Apakah Anda memiliki riwayat Penyakit Artritis Reumatoid (rematik)? (Ya/Tidak)",
    "Apakah Anda mengidap penyakit Diabetes? (Ya/Tidak)",
    "Apakah Anda memiliki riwayat penyakit paru obstruktif kronis (PPOK)? (Ya/Tidak)",
    "Berapa nilai Forced Expiratory Volume 1 (FEV1) Anda? (Boleh dikosongkan, tes tiupan nafas fungsi paru)",
  ];

  StateHeartAttack() {
    messages.add(ChatMessage(type: 'text', text: questions[0], isUser: false));
  }

  Future<void> restart() async {
    isLoading = true;
    currentQuestion = 0;
    tempData.reset();
    messages.clear();

    _addTyping();
    await _thinkingDelay(800);
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
      await _thinkingDelay(600);
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
        text: 'Sedang menganalisis data penyakit jantung...',
        isUser: false,
      ),
    );

    isLoading = true;
    notifyListeners();

    try {
      final inputPasien = tempData.toJson();
      final result = await ApiService.heartAttackPredict(inputPasien);

      debugPrint("=== RESPONS SERVER SILAKAN CEK DI SINI ===");
      debugPrint(result.toString());

      messages.add(
        ChatMessage(
          type: 'result',
          isUser: false,
          widget: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ChartHeartAttack(
                riskPercentage: result["risk_percentage"].toDouble(),
                safePercentage: result["safe_percentage"].toDouble(),
              ),
              const SizedBox(height: 16),
              const Text(
                'Hasil Analisis Klasifikasi',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text('Resiko : ${result["is_risk"] == 1 ? "Iya" : "Tidak"}'),
              Text('Persentasi Resiko : ${result["risk_percentage"]}%'),
              Text('Persentasi Aman : ${result["safe_percentage"]}%'),
              Text('Pesan : ${result["message"]}'),
              const SizedBox(height: 16),
              RestartButton(onRestart: restart),
            ],
          ),
        ),
      );
    } catch (e) {
      // PERBAIKAN: Ganti type ke 'error' atau pastikan widget memisahkan dari diagram sukses
      messages.add(
        ChatMessage(
          type: 'error', 
          isUser: false,
          widget: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Gagal terhubung ke server atau memproses data.',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              RestartButton(onRestart: restart),
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
    final trimmedValue = value.trim();

    // Jika input kosong untuk pertanyaan opsional, langsung lolos
    if ([2, 4, 12].contains(questionIndex) && trimmedValue.isEmpty) {
      return null;
    }

    // 1. Validasi Gender
    if (questionIndex == 0) {
      final clean = trimmedValue.toLowerCase();
      if (clean != 'pria' &&
          clean != 'laki-laki' &&
          clean != 'laki laki' &&
          clean != 'male' &&
          clean != 'wanita' &&
          clean != 'perempuan' &&
          clean != 'female') {
        return "Masukkan antara 'Pria' atau 'Wanita'";
      }
      return null;
    }

    // 2. Validasi Jawaban Biner (Ya atau Tidak)
    if ([3, 5, 6, 7, 8, 9, 10, 11].contains(questionIndex)) {
      final clean = trimmedValue.toLowerCase();
      if (clean != 'ya' &&
          clean != 'yes' &&
          clean != '1' &&
          clean != 'tidak' &&
          clean != 'no' &&
          clean != '0') {
        return "Masukkan antara 'Ya' atau 'Tidak'";
      }
      return null;
    }

    // 3. Validasi Angka Positif
    if ([1, 2, 4, 12].contains(questionIndex)) {
      final doubleValue = double.tryParse(trimmedValue);
      if (doubleValue == null || doubleValue <= 0) {
        return "Masukkan angka positif yang valid";
      }

      switch (questionIndex) {
        case 1:
          if (doubleValue < 1 || doubleValue > 120) return "Masukkan umur yang logis (1 - 120 tahun)";
          return null;
        case 2:
          if (doubleValue < 10 || doubleValue > 60) return "Masukkan BMI yang logis (10 - 60)";
          return null;
        case 4:
          if (doubleValue < 70 || doubleValue > 250) return "Masukkan tekanan darah sistolik yang logis (70 - 250 mmHg)";
          return null;
        case 12:
          if (doubleValue < 0 || doubleValue > 150) return "Masukkan nilai FEV1 yang logis (0% - 150%)";
          return null;
      }
    }
    return null;
  }

 void _saveAnswer(String value) {
  final trimmed = value.trim();

  if (trimmed.isEmpty) {
    switch (currentQuestion) {
      case 2:
        tempData.bodyMassIndex = null;
        break;
      case 4:
        tempData.systolicBloodPressure = null;
        break;
      case 12:
        tempData.forcedExpiratoryVolume1 = null;
        break;
    }
    return;
  }

  final clean = trimmed.toLowerCase();

  final bool isYes =
      clean == 'ya' ||
      clean == 'yes' ||
      clean == '1';

  final bool isMale =
      clean == 'pria' ||
      clean == 'laki-laki' ||
      clean == 'laki laki' ||
      clean == 'male';

  final doubleValue = double.tryParse(trimmed);
  final intValue = int.tryParse(trimmed);

  switch (currentQuestion) {
    case 0:
      tempData.gender = isMale ? 1 : 0;
      break;

    case 1:
      tempData.age = intValue;
      break;

    case 2:
      tempData.bodyMassIndex = doubleValue;
      break;

    case 3:
      tempData.smoker = isYes ? 1 : 0;
      break;

    case 4:
      tempData.systolicBloodPressure = doubleValue;
      break;

    case 5:
      tempData.hypertensionTreated = isYes ? 1 : 0;
      break;

    case 6:
      tempData.familyHistoryOfCardiovascularDisease =
          isYes ? 1 : 0;
      break;

    case 7:
      tempData.atrialFibrillation = isYes ? 1 : 0;
      break;

    case 8:
      tempData.chronicKidneyDisease = isYes ? 1 : 0;
      break;

    case 9:
      tempData.rheumatoidArthuritis = isYes ? 1 : 0;
      break;

    case 10:
      tempData.diabetes = isYes ? 1 : 0;
      break;

    case 11:
      tempData.chronicObstructivePulmonaryDisorder =
          isYes ? 1 : 0;
      break;

    case 12:
      tempData.forcedExpiratoryVolume1 = doubleValue;
      break;
  }

  debugPrint("DATA TERSIMPAN:");
  debugPrint(tempData.toJson().toString());
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
    if (currentQuestion >= questions.length) return; // Kunci undo jika sudah dihitung server

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