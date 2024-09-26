//Created by MansoorSatti 8/7/2024
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:physical_tracking_app/constants/text_styles.dart';
import 'package:physical_tracking_app/main.dart';
import 'package:physical_tracking_app/models/user_model.dart';
import 'package:physical_tracking_app/pages/setInfo/controller/set_info_controller.dart';
import 'package:physical_tracking_app/widgets/custom_app_bar.dart';
import 'package:physical_tracking_app/widgets/custom_button.dart';
import 'package:physical_tracking_app/widgets/custom_text_field.dart';

import '../../constants/app_colors.dart';
import '../../utils/global_functions.dart';
import '../../utils/validations.dart';
import '../../widgets/custom_circular_progress.dart';

class SetInfo extends StatelessWidget {
  SetInfo({
    super.key,
    this.formHome = false,
  });

  final controller = Get.put(SetInfoController());
  final _infoFormKey = GlobalKey<FormState>();
  final bool formHome;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.jetBlack,
      appBar: const CustomAppBar(title: Text("Set Info")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: StreamBuilder(
            stream: auth.currentUser != null
                ? FirebaseFirestore.instance
                    .collection('Users')
                    .doc(auth.currentUser!.uid)
                    .snapshots()
                : null,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CustomCircularProgress();
              }
              if (snapshot.hasError) {
                return Text(
                  snapshot.error.toString(),
                  style: heading4,
                );
              }

              if (snapshot.data!.data() != null) {
                UserModel userModel =
                    UserModel.fromDocumentSnapShot(snapshot.data!);
                controller.infoModel = UserModel.copyModel(userModel);
              }

              return Form(
                key: _infoFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.054,
                    ),
                    _buildHeadingText(text: "Name"),
                    CustomTextField(
                      controller: controller.infoModel.name,
                      filled: true,
                      fillColor: AppColors.darkGray,
                      hintText: "Alex",
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(top: 14.0, bottom: 14),
                        child: Icon(
                          Icons.person,
                          size: 24,
                          color: AppColors.skyBlue,
                        ),
                      ),
                      validator: isNameVerified,
                    ),
                    const SizedBox(height: 16),
                    _buildHeadingText(text: "Date of Birth"),
                    GestureDetector(
                      onTap: () async {
                        var date = await selectDatePicker(context);
                        if (date != null) {
                          controller.infoModel.dateOfBirth.text =
                              DateFormat("dd-MM-yyyy").format(date);
                        }
                      },
                      child: CustomTextField(
                        controller: controller.infoModel.dateOfBirth,
                        filled: true,
                        enabled: false,
                        fillColor: AppColors.darkGray,
                        hintText: "DD-MM-YYYY",
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(top: 14.0, bottom: 14),
                          child: SvgPicture.asset(
                            "assets/icons/calender_icon.svg",
                            width: 27,
                            height: 24,
                            colorFilter: const ColorFilter.mode(
                                AppColors.skyBlue, BlendMode.srcIn),
                          ),
                        ),
                        validator: (p0) {
                          if (p0!.isEmpty) {
                            return "Required";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildHeadingText(text: "Gender"),
                    const SizedBox(height: 8),
                    _buildExpansionTitle(
                      context: context,
                      prefixIconPath: "assets/icons/gender_icon.svg",
                      title: controller.infoModel.gender,
                      stateVariable: controller.genderTileOpen,
                    ),
                    _expansionTileChild(
                      context: context,
                      stateVariable: controller.genderTileOpen,
                      itemList: controller.genderList,
                      changedVariable: controller.infoModel.gender,
                    ),
                    _buildHeadingText(text: "Education level"),
                    const SizedBox(height: 8),
                    _buildExpansionTitle(
                      context: context,
                      prefixIconPath: "assets/icons/education_icon.svg",
                      title: controller.infoModel.education,
                      stateVariable: controller.educationTileOpen,
                    ),
                    _expansionTileChild(
                      context: context,
                      stateVariable: controller.educationTileOpen,
                      itemList: controller.educationList,
                      changedVariable: controller.infoModel.education,
                    ),
                    _buildHeadingText(text: "Physical Activity"),
                    const SizedBox(height: 8),
                    _buildExpansionTitle(
                      context: context,
                      prefixIconPath: "assets/icons/physical_activity.svg",
                      title: controller.infoModel.physicalActivity,
                      stateVariable: controller.pActivityTileOpen,
                    ),
                    _expansionTileChild(
                      context: context,
                      stateVariable: controller.pActivityTileOpen,
                      itemList: controller.activityList,
                      changedVariable: controller.infoModel.physicalActivity,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                    ),
                    CustomButton(
                      onPressed: () {
                        if (_infoFormKey.currentState!.validate()) {
                          globalUserModel =
                              UserModel.copyModel(controller.infoModel).obs;
                          if (formHome == false) {
                            controller.addData();
                          } else {
                            controller.updateData();
                          }
                        }
                      },
                      width: Get.width,
                      text: "Save",
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            }),
      ),
    );
  }

  Obx _expansionTileChild({
    required BuildContext context,
    required RxBool stateVariable,
    required List<String> itemList,
    required RxString changedVariable,
  }) {
    return Obx(
      () => Offstage(
        offstage: !stateVariable.value,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          width: Get.width,
          padding:
              const EdgeInsets.only(top: 18, bottom: 2, right: 24, left: 24),
          decoration: BoxDecoration(
            color: AppColors.darkGray,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                  color: AppColors.black.withOpacity(0.15),
                  blurRadius: 12,
                  spreadRadius: 0,
                  offset: const Offset(0, 1)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: itemList
                .map(
                  (e) => GestureDetector(
                    onTap: () {
                      changedVariable.value = e;
                      stateVariable.value = false;
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        e,
                        style: heading4.copyWith(color: AppColors.mediumGray),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  //expansion tile title
  GestureDetector _buildExpansionTitle({
    required BuildContext context,
    required String prefixIconPath,
    required RxString title,
    required RxBool stateVariable,
  }) {
    return GestureDetector(
      onTap: () => stateVariable.toggle(),
      child: Obx(
        () => Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: AppColors.darkGray,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                  color: AppColors.black.withOpacity(0.15),
                  blurRadius: 12,
                  spreadRadius: 0,
                  offset: const Offset(0, 1)),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 14.0, bottom: 14, left: 18, right: 12),
                child: SvgPicture.asset(
                  prefixIconPath,
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                      AppColors.skyBlue, BlendMode.srcIn),
                ),
              ),
              Expanded(
                child: Text(
                  title.value,
                  style: heading4.copyWith(color: AppColors.mediumGray),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 14.0, bottom: 14, left: 16, right: 24),
                child: SvgPicture.asset(
                  stateVariable.value == false
                      ? "assets/icons/arrow_down.svg"
                      : "assets/icons/arrow_up.svg",
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                      AppColors.skyBlue, BlendMode.srcIn),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildHeadingText({required String text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        text,
        style: heading3,
      ),
    );
  }
}
