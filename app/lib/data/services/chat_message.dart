import 'package:flutter/material.dart';

class ChatMessage {
  final String type; // text, typing, result
  final String? text;
  final Widget? widget;
  final bool isUser;

  ChatMessage({
    required this.type,
    this.text,
    this.widget,
    required this.isUser,
  });
}