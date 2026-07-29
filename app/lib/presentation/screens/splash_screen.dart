// ignore_for_file: use_build_context_synchronously

import 'package:app/core/app_color.dart';
import 'package:app/core/app_image.dart';
import 'package:app/data/repository/user_repository.dart';
import 'package:app/presentation/widgets/buttons/save_button.dart';
import 'package:app/presentation/widgets/textfields/textfields_name.dart';
import 'package:flutter/material.dart';
import 'package:app/core/app_font.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // 1. Tambahkan PageController untuk mengatur animasi geser
  final PageController _pageController = PageController(initialPage: 0);
  final TextEditingController _nameCtrl = TextEditingController(); 

  Future<void> _getInit() async {
    final userRepository = UserRepository();
    String? haveName = await userRepository.getName();
    await Future.delayed(const Duration(milliseconds: 2000));
    if (haveName != null) {
      if (context.mounted) {
        context.go('/home');
      }
      return;
    }
    
    if (mounted) {
      _pageController.animateToPage(
        1,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _saveName() async {
    final userRepository = UserRepository();
    bool isSave = await userRepository.saveName(_nameCtrl.text);
    if(isSave && context.mounted){
      context.go('/home');
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _pageController.dispose(); // Jangan lupa di-dispose biar tidak memory leak
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 3. Gunakan PageView agar bisa mendeteksi perpindahan dan animasi antar halaman
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Biar user tidak bisa swipe manual sebelum waktunya
        children: [
          _firstLayer(),
          _secondLayer(),
          _thirdLayer(),
        ],
      ),
    );
  }

  Widget _firstLayer() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColor.primary,
            Color(0xFF3A49A8),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04), 
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            left: -20,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.03),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24), 
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12), 
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    AppImage.logo, 
                    width: 64, 
                    height: 64,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Glucost App',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Solusi Kesehatan Modern',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _secondLayer() {
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColor.foreign, 
        child: Stack(
          children: [
            Positioned(
              top: -60,
              left: -60,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.primary.withValues(alpha: 0.05), 
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 280),
                    child: Image.asset(
                      AppImage.man,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Manage Your Health\nEasily & Flexibly',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppFont.nunito,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E244B),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Connect with top doctors, calculate BMI, and control your wellness journey anywhere, anytime.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppFont.inter,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[500],
                      height: 1.5,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      // 4. Animasi pindah ke layer input nama (indeks 2) ke arah kiri
                      _pageController.animateToPage(
                        2,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOutCubic,
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColor.accent,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.accent.withValues(alpha: 0.35),
                            offset: const Offset(0, 8),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Get Started',
                            style: TextStyle(
                              fontFamily: AppFont.inter,
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _thirdLayer() {
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFFF8F9FE),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.35,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColor.primary, Color(0xFF4A59C5)],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    GestureDetector(
                      // 5. Animasi mundur kembali ke onboarding (indeks 1) ke arah kanan
                      onTap: () => _pageController.animateToPage(
                        1,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOutCubic,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Welcome to GLUCOST!',
                      style: TextStyle(
                        fontFamily: AppFont.nunito,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Let us know you better to personalize your health tracking.',
                      style: TextStyle(
                        fontFamily: AppFont.inter,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF5D6CDA).withValues(alpha: 0.08),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'What should we call you?',
                            style: TextStyle(
                              fontFamily: AppFont.nunito,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E244B),
                        ),
                          ),
                          const SizedBox(height: 12),
                          TextfieldsName(ctrl: _nameCtrl),
                          const SizedBox(height: 28),
                          SaveButton(func: _saveName),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}