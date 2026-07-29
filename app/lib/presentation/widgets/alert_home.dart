import 'package:app/core/app_color.dart';
import 'package:app/core/app_font.dart';
import 'package:app/core/app_image.dart';
import 'package:flutter/material.dart';

class AlertHome extends StatelessWidget {
  const AlertHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias, 
      decoration: BoxDecoration(
        color: AppColor.primary, 
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColor.primary.withValues(alpha: .25),
            offset: const Offset(0, 10),
            blurRadius: 24,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: -30,
            bottom: -30,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.accent.withValues(alpha: .8),
              ),
            ),
          ),

          Positioned(
            right: 30,
            top: -20,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.accent.withValues(alpha: .8),
              ),
            ),
          ),

          Positioned(
            right: 30,
            bottom: -20,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.accent.withValues(alpha: .8),
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 8, 20),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Stay Home!',
                        style: TextStyle(
                          color: AppColor.foreign, 
                          fontFamily: AppFont.nunito,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Schedule an e-visit and discuss the plan with a doctor.',
                        style: TextStyle(
                          color: Color(0xFFE2E7FF), 
                          fontFamily: AppFont.inter,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          height: 1.4, 
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 12),
                
                SizedBox(
                  width: 150, 
                  height: 150,
                  child: Image.asset(
                    AppImage.woman,
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}