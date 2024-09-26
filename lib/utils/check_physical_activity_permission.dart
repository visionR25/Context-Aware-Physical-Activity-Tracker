//Created by MansoorSatti 8/27/2024

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> checkPhysicalActivityPermission() async {
  PermissionStatus perm = Platform.isAndroid
      ? await Permission.activityRecognition.request()
      : await Permission.sensors.request();

  if (perm.isDenied || perm.isPermanentlyDenied || perm.isRestricted) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text(
          'You need to approve the permissions to use the pedometer',
          style: TextStyle(
            color: Theme.of(Get.context!).colorScheme.onError,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(Get.context!).colorScheme.errorContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        // Open the system settings to allow the permissions
        action: SnackBarAction(
          label: 'Settings',
          textColor: Theme.of(Get.context!).colorScheme.onError,
          onPressed: () => openAppSettings(),
        ),
      ),
    );
    // return false;
  }
  // return true;
  // Call the functions your need to read stepCount
}
