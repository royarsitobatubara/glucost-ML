import 'package:app/core/app_color.dart';
import 'package:app/presentation/widgets/buttons/back_custom_button.dart';
import 'package:flutter/material.dart';

class ScreenLayout extends StatelessWidget {
  final Widget child;
  final String? title;

  const ScreenLayout({
    super.key, 
    required this.child,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary, // Latar belakang utama (biasanya biru/gelap)
      
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true, // Diubah ke true agar judul berada di tengah (lebih simetris & premium)
        leadingWidth: 64,
        leading: const Padding(
          padding: EdgeInsets.only(left: 18, top: 8, bottom: 8),
          child: BackCustomButton(),
        ),
        title: title != null
            ? Text(
                title!,
                style: const TextStyle(
                  color: AppColor.foreign, // Warna teks putih/cerah bawaanmu
                  fontFamily: 'Nunito', // Menyelaraskan dengan font brand aplikasi
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              )
            : null,
      ),
      
      body: Column(
        children: [
          const SizedBox(height: 10), // Jarak tipis yang elegan di bawah AppBar sebelum lengkungan dimulai
          
          Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: AppColor.foreign, // Warna isi halaman utama (biasanya putih/terang)
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32), // Dibuat melengkung penuh kiri-kanan
                  topRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                child: SafeArea(
                  top: false,
                  child: child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}