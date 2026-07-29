import 'package:app/core/app_color.dart';
import 'package:flutter/material.dart';

class ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onBack;
  final bool enabled;

  const ChatInput({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onBack,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    // Menentukan warna tema utama secara lokal (bisa kamu ganti dengan AppColor milikmu)

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        // Membuat sudut atas sedikit melengkung agar terlihat premium
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, -4), // Bayangan halus mengarah ke atas
          ),
        ],
      ),
      child: SafeArea(
        top: false, // Menjaga padding bawah tetap aman di HP berponi bawah (iOS/Android)
        child: Row(
          children: [
            // 1. TOMBOL KEMBALI STYLISH
            GestureDetector(
              onTap: enabled ? onBack : null,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade100,
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded, // Lebih modern dibanding Icons.undo
                  size: 18,
                  color: enabled ? Colors.grey.shade700 : Colors.grey.shade400,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // 2. KOTAK INPUT TEXT SEAMLESS
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.shade200, width: 1),
                ),
                child: TextField(
                  controller: controller,
                  enabled: enabled,
                  maxLines: 4, // Mendukung multi-line jika pesan panjang
                  minLines: 1,
                  style: const TextStyle(fontSize: 15, color: Color(0xFF1E244B)),
                  decoration: InputDecoration(
                    hintText: "Ketik pesan...",
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                    border: InputBorder.none, // Menghilangkan border bawaan TextField yang kaku
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            GestureDetector(
              onTap: enabled ? onSend : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: enabled ? AppColor.accent : Colors.grey.shade300,
                  boxShadow: enabled
                      ? [
                          BoxShadow(
                            color: AppColor.accent.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  enabled ? Icons.send_rounded : Icons.hourglass_empty_rounded, // Berubah ikon saat loading
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}