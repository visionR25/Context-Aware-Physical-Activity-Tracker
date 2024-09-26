//Created by MansoorSatti 8/27/2024

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:physical_tracking_app/constants/text_styles.dart';
import 'package:physical_tracking_app/models/activity_model.dart';
import 'package:physical_tracking_app/utils/custom_alert_dialog.dart';
import 'package:physical_tracking_app/utils/loading_dialog.dart';
import 'package:physical_tracking_app/widgets/custom_app_bar.dart';

import '../../constants/app_colors.dart';
import '../../widgets/activity_widget.dart';

class ActivityDetails extends StatelessWidget {
  const ActivityDetails({super.key, required this.activity});

  final ActivityModel activity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.jetBlack,
      appBar: CustomAppBar(
        title: const Text("Activity Details"),
        actions: [
          GestureDetector(
            onTap: () {
              customAlertDialog(
                "Delete",
                "Are you sure, you want to delete this activity? This action cannot be recovered.",
                () async {
                  Get.back();
                  loadingDialog('deleting');
                  await FirebaseFirestore.instance
                      .collection('MoodHistory')
                      .doc(activity.startTime!.toString())
                      .delete()
                      .then((value) async {
                    await FirebaseFirestore.instance
                        .collection('Activities')
                        .doc(activity.docId)
                        .delete();
                    Get.close(2);
                  });
                },
              );
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
                Icons.delete_forever,
                size: 24,
                color: AppColors.skyBlue,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Row(
              children: [
                Text("from", style: heading1),
                const Spacer(),
                Text(
                    DateFormat("MM/d h:mm a").format(
                        DateTime.fromMillisecondsSinceEpoch(
                            activity.startTime!.millisecondsSinceEpoch)),
                    style: heading5),
              ],
            ),
            Row(
              children: [
                Text("to", style: heading1),
                const Spacer(),
                Text(
                    DateFormat("MM/d h:mm a").format(
                        DateTime.fromMillisecondsSinceEpoch(
                            activity.endTime!.millisecondsSinceEpoch)),
                    style: heading5),
              ],
            ),
            const SizedBox(height: 24),
            buildActivityWidget(
              iconPath: "assets/icons/running_icon.svg",
              title: "Steps",
              content: activity.stepCount.toString(),
            ),
            buildActivityWidget(
              iconPath: "assets/icons/distance_icon.svg",
              title: "Distance",
              content: activity.distance.toString(),
            ),
            buildActivityWidget(
              iconPath: "assets/icons/map_icon.svg",
              title: "Current Location",
              content: activity.currentLocation,
            ),
            buildActivityWidget(
              iconPath: "assets/icons/weather_icon.svg",
              title: "Weather Today",
              content: activity.orgTemperature,
              feelsLike: activity.feelsTemperature,
            ),
          ],
        ),
      ),
    );
  }
}
