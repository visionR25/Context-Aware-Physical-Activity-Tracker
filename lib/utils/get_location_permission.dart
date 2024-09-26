//Created by MansoorSatti 8/31/2024
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> getLocationPermissions() async {
  LocationPermission permission;
  bool serviceEnabled;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return false;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return false;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text(
          'Please manually enable location permission for this app in your device settings.',
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

    // showDialog(
    //   context: Get.context!,
    //   builder: (context) => AlertDialog(
    //     title: const Text('Location permission is denied forever'),
    //     content: const Text(
    //         'Please manually enable location permission for this app in your device settings.'),
    //     actions: [
    //       TextButton(
    //         onPressed: () {
    //           Get.back();
    //           openAppSettings();
    //         },
    //         child: const Text('Open Settings'),
    //       ),
    //     ],
    //   ),
    // );
    return false;
  }

  if (permission == LocationPermission.whileInUse ||
      permission == LocationPermission.always) {
    return true;
  }

  return false;
}

getCurrentLocation(){

}
