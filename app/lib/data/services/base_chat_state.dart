import 'package:flutter/material.dart';
import 'chat_message.dart';
// Import file tempat ChatMessage didefinisikan jika berada di file berbeda
// import '../widgets/chats/chat_message.dart'; 

abstract class BaseChatState extends ChangeNotifier {
  bool get isLoading;
  int currentQuestion = 0;
  List<String> get questions => [];
  // Ubah tipe data di sini dari Map<String, dynamic> menjadi ChatMessage
  List<ChatMessage> get messages; 
  
  Future<String?> sendMessage(String value);
  Future<void> undo();
}