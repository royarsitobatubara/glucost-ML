import 'package:app/core/app_color.dart';
import 'package:app/core/app_font.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String location;
  final bool isActive;
  final Map<String, Object>? extraData;

  const MenuButton({
    super.key,
    required this.label,
    required this.icon,
    required this.location,
    this.isActive = false,
    this.extraData,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(location, extra: extraData),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut, // Animasi penekanan lebih organik
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        decoration: BoxDecoration(
          // 1. KOMBINASI GRADIENT PREMIUM JIKA AKTIF
          gradient: isActive
              ? LinearGradient(
                  colors: [
                    AppColor.accent, 
                    AppColor.accent.withValues(alpha: 0.85), // Gradasi halus ke warna lebih soft
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isActive ? null : AppColor.foreign, // Warna fallback putih jika tidak aktif
          borderRadius: BorderRadius.circular(20), // Lengkungan sudut lebih dinamis/modern
          border: isActive 
              ? null 
              : Border.all(color: Colors.grey.shade100, width: 1.5), // Border tipis pemisah kontras
          boxShadow: [
            BoxShadow(
              color: isActive
                  ? AppColor.accent.withValues(alpha: 0.35) // Bayangan menyala halus
                  : Colors.black.withValues(alpha: 0.04), // Bayangan redup natural
              offset: const Offset(0, 6),
              blurRadius: 12,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 2. KOTAK/BULATAN DEKORATIF IKON
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.white.withValues(alpha: 0.2) // 👈 Alpha diperbaiki menjadi 0.2 (maksimal 1.0)
                    : AppColor.accent.withValues(alpha: 0.08), // Warna background ikon pudar estetik
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 26,
                color: isActive ? Colors.white : AppColor.accent, // Ikon jadi putih jika aktif
              ),
            ),
            const SizedBox(height: 12),
            
            // 3. TEKS LABEL MENU
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: AppFont.inter,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
                // Kontras teks dinamis (Putih saat aktif, warna aksen/gelap saat mati)
                color: isActive ? AppColor.foreign : const Color(0xFF2C3256),
              ),
            ),
          ],
        ),
      ),
    );
  }
}