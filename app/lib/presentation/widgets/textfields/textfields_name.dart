import 'package:app/core/app_font.dart';
import 'package:app/core/app_color.dart';
import 'package:flutter/material.dart';

class TextfieldsName extends StatelessWidget {
  final TextEditingController ctrl;
  const TextfieldsName({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: ctrl,
      textCapitalization: TextCapitalization.words,
      style: const TextStyle(
        fontFamily: AppFont.inter,
        fontSize: 15,
        color: Colors.black87,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: 'Enter your name...',
        hintStyle: TextStyle(
          fontFamily: AppFont.inter,
          fontSize: 15,
          color: Colors.grey[400],
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: const Icon(
          Icons.person_outline_rounded,
          color: AppColor.primary,
          size: 22,
        ),
        filled: true,
        fillColor: const Color(0xFFF4F6FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }
}
