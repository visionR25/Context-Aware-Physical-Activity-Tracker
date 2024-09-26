//Created by MansoorSatti 8/23/2024
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';
import '../widgets/custom_button.dart';

void customAlertDialog(
  String title,
  String content, [
  void Function()? onPressed,
]) {
  showDialog(
    context: Get.context!,
    barrierColor: AppColors.white.withOpacity(0.3),
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: AppColors.darkGray,
          actionsAlignment: MainAxisAlignment.center,
          title: Container(
            padding: const EdgeInsets.all(16),
            // width: Get.width,
            decoration: const BoxDecoration(
              color: AppColors.darkTealBlue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'SFProBold',
                color: AppColors.mediumGray,
              ),
            ),
          ),
          titlePadding: EdgeInsets.zero,
          content: Text(
            content,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: 'SFProBold',
              color: AppColors.mediumGray,
            ),
          ),
          actions: [
            if (onPressed != null) ...{
              CustomButton(
                onPressed: () {
                  Get.back();
                },
                text: 'Cancel',
                height: 30,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                borderRadius: 10,
                verticalPadding: 4,
                width: 70,
              ),
            },
            CustomButton(
              onPressed: onPressed ??
                  () {
                    Get.back();
                  },
              text: 'OK',
              height: 30,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              borderRadius: 10,
              verticalPadding: 4,
              width: 70,
            ),
          ],
        ),
      );
    },
  );
}
