//Created by MansoorSatti 8/1/2024
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../widgets/custom_text_field.dart';
import '../../constants/app_colors.dart';
import '../../constants/text_styles.dart';
import '../../utils/validations.dart';
import '../../widgets/custom_button.dart';
import 'controller/forget_password_controller.dart';

///forget password dialog
void forgetPasswordDialog(BuildContext? context) {
  //initialise forget password controller
  final controller = Get.put(ForgetPasswordController());
  //forget password form key
  final forgetFormKey = GlobalKey<FormState>();

  //clear email controller
  controller.email.clear();

  ///show dialog
  showDialog(
    context: context ?? Get.context!,
    barrierColor: AppColors.charcoal.withOpacity(0.63),
    builder: (context) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        insetPadding: const EdgeInsets.all(38),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: AppColors.darkGray,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 26),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColors.darkGray,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Not to worry, it happens to the best of us. Please enter your email address below.",
                  style: heading4,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),

                ///form
                Form(
                  key: forgetFormKey,

                  ///email text field

                  child: CustomTextField(
                    controller: controller.email,
                    keyboardType: TextInputType.emailAddress,
                    labelText: "Email",
                    prefixIcon: Padding(
                      padding:
                          const EdgeInsets.only(top: 11.0, bottom: 11, left: 0),
                      child: SvgPicture.asset(
                        "assets/icons/email_icon.svg",
                        width: 21,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                            AppColors.skyBlue, BlendMode.srcIn),
                      ),
                    ),
                    validator: isEmailVerified,
                  ),
                ),
                const SizedBox(height: 62),
                CustomButton(
                  onPressed: () {
                    if (forgetFormKey.currentState!.validate()) {
                      controller.forgetPassword();
                    }
                  },
                  width: Get.width,
                  text: 'Save',
                )
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
