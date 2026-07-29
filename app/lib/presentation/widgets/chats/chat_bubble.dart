import 'package:app/core/app_color.dart';
import 'package:app/core/app_font.dart';
import 'package:app/core/app_image.dart'; // 👈 Mengimpor aset logomu
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String? text;
  final Widget? child;
  final bool isUser;

  const ChatBubble({
    super.key,
    this.text,
    this.child,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end, // Ikon sejajar dengan baris bawah teks
        children: [
          // 1. TAMPILKAN LOGO PROFIL JIKA BUKAN USER
          if (!isUser) ...[
            Container(
              margin: const EdgeInsets.only(right: 8, bottom: 4),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  AppImage.logo,
                  width: 28,
                  height: 28,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],

          // 2. BALON CHAT UTAMA
          Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.70,
            ),
            decoration: BoxDecoration(
              color: isUser ? AppColor.primary : AppColor.accent, 
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                // Sudut runcing pintar penanda arah pengirim chat
                bottomLeft: Radius.circular(isUser ? 16 : 4), 
                bottomRight: Radius.circular(isUser ? 4 : 16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isUser ? 0.06 : 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
              border: isUser ? null : Border.all(color: Colors.grey.shade200, width: 1),
            ),
            child: child ??
                Text(
                  text ?? "",
                  style: const TextStyle(
                    color: AppColor.foreign,
                    fontFamily: AppFont.inter,
                    fontWeight: FontWeight.w700, 
                    fontSize: 14.5,
                    height: 1.4,
                  ),
                ),
          ),
        ],
      ),
    );
  }
}