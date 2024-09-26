//Created by MansoorSatti 8/7/2024
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:physical_tracking_app/models/user_model.dart';
import 'package:physical_tracking_app/utils/custom_alert_dialog.dart';
import 'package:physical_tracking_app/utils/loading_dialog.dart';

import '../../../main.dart';
import '../../../utils/global_functions.dart';
import '../../navBar/nav_bar_screen.dart';

class SetInfoController extends GetxController {
  UserModel infoModel = UserModel.initialize();

  //is gender tile open
  RxBool genderTileOpen = false.obs;
  RxBool educationTileOpen = false.obs;
  RxBool pActivityTileOpen = false.obs;

  List<String> genderList = ['Male', 'Female'];
  List<String> educationList = [
    'Primary School',
    'High School',
    'Bachelor’s Degree',
    'Master’s Degree',
    'Ph.D. Degree'
  ];
  List<String> activityList = [
    'Lightly Active',
    'Moderate Active',
    'Active',
    'Very Active',
    'Super Active'
  ];

  ///add data
  void addData() async {
    loadingDialog();
    infoModel.email.text = auth.currentUser!.email!;
    var data = infoModel.toMap();
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser!.uid.toString())
        .set(data)
        .then((value) async {
      UserModel? userModel = await getUserData();
      if (userModel != null) {
        globalUserModel!.value = UserModel.copyModel(userModel);
      }
      Get.back();
      Get.offAll(() => NavBarScreen());
    }).onError((error, stackTrace) {
      debugPrint("Error: $error");
      Get.back();
      customAlertDialog('Error', "Something went wrong, try again later");
    });
  }

  ///update data
  void updateData() async {
    loadingDialog();
    var data = infoModel.toUpdate();
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser!.uid.toString())
        .update(data)
        .then((value) async {
      UserModel? userModel = await getUserData();
      if (userModel != null) {
        globalUserModel!.value = UserModel.copyModel(userModel);
      }
      Get.close(2);
    }).onError((error, stackTrace) {
      debugPrint("Error: $error");
      Get.back();
      customAlertDialog('Error', "Something went wrong, try again later");
    });
  }
}
