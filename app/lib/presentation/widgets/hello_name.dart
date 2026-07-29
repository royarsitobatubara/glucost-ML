import 'package:app/core/app_color.dart';
import 'package:app/core/app_font.dart';
import 'package:flutter/material.dart';

class HelloName extends StatelessWidget {
  final String name;
  const HelloName({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Hello,",
          style: TextStyle(
            color: AppColor.foreign,
            fontWeight: FontWeight.w300,
            fontFamily: AppFont.inter,
            fontSize: 20,
          ),
        ),
        Text(
          "$name!💊",
          style: const TextStyle(
            color: AppColor.foreign,
            fontWeight: FontWeight.w700,
            fontFamily: AppFont.nunito,
            fontSize: 30,
          ),
        ),
      ],
    );
  }
}
