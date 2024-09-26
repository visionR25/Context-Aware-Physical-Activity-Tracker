//Created by MansoorSatti 8/7/2024

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:physical_tracking_app/constants/app_colors.dart';
import 'package:physical_tracking_app/pages/navBar/controller/nav_bar_controller.dart';
import 'package:physical_tracking_app/pages/setInfo/set_info.dart';
import 'package:physical_tracking_app/widgets/custom_app_bar.dart';

import '../../constants/text_styles.dart';
import '../../main.dart';
import '../../utils/custom_alert_dialog.dart';
import '../../utils/loading_dialog.dart';
import '../logIn/log_in.dart';

class NavBarScreen extends StatelessWidget {
  NavBarScreen({super.key});

  final controller = Get.put(NavBarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.jetBlack,
      appBar: CustomAppBar(
        title: Obx(
          () => Text(
            controller.selectedIndex.value == 0
                ? "Home"
                : controller.selectedIndex.value == 1
                    ? "Activity"
                    : controller.selectedIndex.value == 2
                        ? "Mood"
                        : "Insights",
          ),
        ),
        actions: [
          Obx(
            () => controller.selectedIndex.value == 0
                ? GestureDetector(
                    onTap: () => Get.to(() => SetInfo(formHome: true)),
                    child: Container(
                      width: 40,
                      height: 40,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.darkGray,
                      ),
                      child: SvgPicture.asset(
                        "assets/icons/edit_info.svg",
                        width: 24,
                        height: 24,
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () async {
                      loadingDialog('logging out');
                      await auth.signOut().then((value) {
                        Get.back();
                        Get.offAll(() => LogIn());
                      }).onError((error, stackTrace) {
                        Get.back();
                        customAlertDialog(
                            'Error', "Something went wrong, try again later");
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.darkGray,
                      ),
                      child: const Icon(
                        Icons.logout,
                        size: 24,
                        color: AppColors.skyBlue,
                      ),
                    ),
                  ),
          ),
        ],
      ),
      body: Obx(
        () => NavBarController.pages.elementAt(controller.selectedIndex.value),
      ),
      bottomNavigationBar: Container(
        width: Get.width,
        // height: 62,
        margin: const EdgeInsets.only(bottom: 20, left: 25, right: 25),
        padding: const EdgeInsets.only(left: 26, right: 26, bottom: 9),
        decoration: BoxDecoration(
          color: AppColors.darkGray,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          children: [
            _buildNavWidget(
              currentIndex: 0,
              selectedIndex: controller.selectedIndex,
              activeIconPath: "assets/icons/home_active.svg",
              inActiveIconPath: "assets/icons/home_inactive_icon.svg",
              text: "Home",
              onTap: () => controller.selectedIndex.value = 0,
            ),
            _buildNavWidget(
              currentIndex: 1,
              selectedIndex: controller.selectedIndex,
              activeIconPath: "assets/icons/activity_active.svg",
              inActiveIconPath: "assets/icons/activity_inactive.svg",
              text: "Activity",
              onTap: () => controller.selectedIndex.value = 1,
            ),
            _buildNavWidget(
              currentIndex: 2,
              selectedIndex: controller.selectedIndex,
              activeIconPath: "assets/icons/mood_active.svg",
              inActiveIconPath: "assets/icons/mood_inactive.svg",
              text: "Mood",
              onTap: () => controller.selectedIndex.value = 2,
            ),
            _buildNavWidget(
              currentIndex: 3,
              selectedIndex: controller.selectedIndex,
              activeIconPath: "assets/icons/insights_active.svg",
              inActiveIconPath: "assets/icons/insights_inactive.svg",
              text: "Insights",
              onTap: () => controller.selectedIndex.value = 3,
            ),
          ],
        ),
      ),
    );
  }

  Expanded _buildNavWidget({
    required int currentIndex,
    required RxInt selectedIndex,
    required String activeIconPath,
    required String inActiveIconPath,
    required String text,
    required void Function()? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Obx(
          () => Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (selectedIndex.value == currentIndex)
                    Container(
                      margin: const EdgeInsets.only(bottom: 8, top: 1),
                      height: 2,
                      width: 52,
                      color: AppColors.skyBlue,
                    ),
                  SvgPicture.asset(
                    selectedIndex.value == currentIndex
                        ? activeIconPath
                        : inActiveIconPath,
                    height: 24,
                    width: 24,
                  ),
                  if (selectedIndex.value == currentIndex)
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: Text(
                        text,
                        style: navBarStyle,
                      ),
                    ),
                ],
              ),
              if (selectedIndex.value == currentIndex)
                Positioned(
                  top: -1,
                  child: SvgPicture.asset(
                    "assets/icons/bottom_active_shadow.svg",
                    height: 40,
                    width: double.maxFinite,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
