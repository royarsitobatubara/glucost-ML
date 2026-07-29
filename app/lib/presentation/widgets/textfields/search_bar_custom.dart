import 'package:app/core/app_color.dart';
import 'package:flutter/material.dart';

class SearchBarCustom extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterPressed;
  final String hintText;

  const SearchBarCustom({
    super.key,
    this.controller,
    this.onChanged,
    this.onFilterPressed,
    this.hintText = 'Search...',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16), // Sudut membulat modern
        boxShadow: [
          BoxShadow(
            color: AppColor.primary.withValues(alpha: .5),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 15,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 15,
            color: Colors.grey[400],
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColor.primary,
            size: 24,
          ),
          suffixIcon: onFilterPressed != null
              ? Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF7F32).withValues(alpha: .5), // Background Oranye soft
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.tune_rounded, // Ikon filter/setting modern
                        color: Color(0xFFFF7F32), // Warna aksen (Oranye)
                        size: 20,
                      ),
                      onPressed: onFilterPressed,
                    ),
                  ),
                )
              : null,
          border: InputBorder.none, // Menghilangkan border bawaan biar clean
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}