import 'package:app/core/app_color.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BackCustomButton extends StatelessWidget {
  final VoidCallback? onPressed; // Ditambahkan agar perilakunya bisa dicustom dari luar jika diperlukan

  const BackCustomButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () => context.pop(),
      child: Container(
        // Ukuran padding yang pas (10-12) membuat tombol lebih mudah ditekan jari pengguna
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 2), 
        decoration: BoxDecoration(
          color: AppColor.foreign, // Warna putih (#FFFFFF)
          borderRadius: BorderRadius.circular(12), // Sudut melengkung yang lebih modern dan halus
          boxShadow: [
            BoxShadow(
              // Menggunakan warna utama (biru) dengan opacity super tipis untuk efek bayangan premium
              color: const Color(0xFF5D6CDA).withValues(alpha: .06), 
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded, 
          size: 20, // Ukuran ikon diturunkan sedikit agar proporsional di dalam kotak padding
          color: AppColor.accent, // Warna oranye (#FF7F32)
        ),
      ),
    );
  }
}