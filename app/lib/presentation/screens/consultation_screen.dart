import 'package:app/presentation/layouts/screen_layout.dart';
import 'package:flutter/material.dart';

class ConsultationScreen extends StatelessWidget {
  const ConsultationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScreenLayout(title: 'Consultation',child: Center(child: Text('CONSULTATION'),), );
  }
}