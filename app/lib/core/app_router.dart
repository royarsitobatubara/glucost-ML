import 'package:app/presentation/screens/about_screen.dart';
import 'package:app/presentation/screens/calcbmi_screen.dart';
import 'package:app/presentation/screens/chat_screen.dart';
import 'package:app/presentation/screens/consultation_screen.dart';
import 'package:app/presentation/screens/home_screen.dart';
import 'package:app/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,

    routes: <RouteBase>[
      GoRoute(
        path: '/home',
        name: 'Home',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            buildPageWithTransition(
          key: state.pageKey,
          child: const HomeScreen(),
        ),
      ),

      GoRoute(
        path: '/',
        name: 'Splash',
        builder: (BuildContext context, GoRouterState state) {
          return const SplashScreen();
        },
      ),

      GoRoute(
        path: '/calc_bmi',
        name: 'calc bmi',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            buildPageWithTransition(
          key: state.pageKey,
          child: const CalcbmiScreen(),
        ),
      ),

      GoRoute(
        path: '/consultation',
        name: 'consultation',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            buildPageWithTransition(
          key: state.pageKey,
          child: const ConsultationScreen(),
        ),
      ),

      GoRoute(
        path: '/about',
        name: 'about',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            buildPageWithTransition(
          key: state.pageKey,
          child: const AboutScreen(),
        ),
      ),

      GoRoute(
        path: '/chat',
        name: 'chat',
        pageBuilder: (BuildContext context, GoRouterState state) {
          final extraData = state.extra as Map<String, dynamic>?;
          final title = extraData?['title'] ?? 'Chat';
          final category = extraData?['category'] ?? 'General';
          
          return buildPageWithTransition(
            key: state.pageKey,
            child: ChatScreen(category: category, title: title),
          );
        },
      ),
    ],

    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Halaman tidak ditemukan: ${state.error}')),
    ),
  );
}

CustomTransitionPage buildPageWithTransition<T>({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 350),
    reverseTransitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.15, 0.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ),
          ),
          child: child,
        ),
      );
    },
  );
}