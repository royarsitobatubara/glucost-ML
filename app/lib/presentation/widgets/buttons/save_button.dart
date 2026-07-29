import 'package:flutter/material.dart';
import 'package:app/core/app_color.dart';
import 'package:app/core/app_font.dart';

class SaveButton extends StatelessWidget {
  final VoidCallback func;
  const SaveButton({super.key, required this.func});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: func,
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: AppColor.accent, // Warna oranye (#FF7F32)
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColor.accent.withValues(alpha: 0.3),
              offset: const Offset(0, 6),
              blurRadius: 16,
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'Save & Continue',
            style: TextStyle(
              fontFamily: AppFont.inter,
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}
