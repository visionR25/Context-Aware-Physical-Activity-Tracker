//Created by MansoorSatti 8/23/2024

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';

void loadingDialog([String? text]) {
  showDialog(
    context: Get.context!,
    barrierColor: Colors.black.withOpacity(0.7),
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        backgroundColor: AppColors.darkGray,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        contentPadding: const EdgeInsets.all(16.0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              color: AppColors.skyBlue,
              strokeWidth: 3,
            ),
            if (text != null) ...{
              const SizedBox(height: 16.0),
              Text(
                text.toLowerCase(),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'SFProBold',
                  color: AppColors.mediumGray,
                ),
              ),
            },
          ],
        ),
      );
    },
  );
}
