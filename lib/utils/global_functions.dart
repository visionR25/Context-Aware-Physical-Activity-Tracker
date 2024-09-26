//Created by MansoorSatti 8/7/2024

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';
import '../main.dart';
import '../models/user_model.dart';

// Function to pick a date with custom theme
Future<DateTime?> selectDatePicker([BuildContext? context]) async {
  final DateTime? picked = await showDatePicker(
    context: context ?? Get.context!,
    initialDate: DateTime.now(),
    firstDate: DateTime(1930),
    lastDate: DateTime.now(),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.white, // <-- SEE HERE
            onPrimary: AppColors.skyBlue, // <-- SEE HERE
            onSurface: AppColors.lightGray, // <-- SEE HERE
          ),
        ),
        child: child!,
      );
    },
  );
  return picked;
}

//get user data
Future<UserModel?> getUserData() async {
  try {
    if (auth.currentUser != null) {
      var snap = await FirebaseFirestore.instance
          .collection('Users')
          .doc(auth.currentUser!.uid)
          .get();

      if (snap.exists) {
        return UserModel.fromDocumentSnapShot(snap);
      } else {
        return null;
      }
    } else {
      return null;
    }
  } catch (e) {
    // Handle connection error
    debugPrint('Error fetching user data global_function: $e');
    return null;
  }
}

String formatDistance(double distanceInFeet) {
  // Constants for conversion
  const double feetToMeters = 0.3048;
  const double feetToKilometers = 0.0003048;

  // Convert feet to meters and kilometers
  double meters = distanceInFeet * feetToMeters;
  double kilometers = distanceInFeet * feetToKilometers;

  // Determine the appropriate unit and format the distance
  if (meters < 1) {
    // Return distance in feet if less than 1 meter
    return '${distanceInFeet.toStringAsFixed(2)} f';
  } else if (kilometers < 1) {
    // Return distance in meters if between 1 meter and 1 kilometer
    return '${meters.toStringAsFixed(2)} m';
  } else {
    // Return distance in kilometers if 1 kilometer or more
    return '${kilometers.toStringAsFixed(2)} km';
  }
}


//get address from lat long
Future<String> getAddressFromLatLng(double latitude, double longitude) async {
  try {
    List<Placemark> placeMarks =
    await placemarkFromCoordinates(latitude, longitude);
    Placemark place = placeMarks[0];

    return '${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}';
  } catch (e) {
    debugPrint("global functions getAddressFromLatLng error: $e");
    return '';
  }
}
String formatNumber(double value) {
  if (value < 1000) {
    return value.toStringAsFixed(0);
  } else if (value < 1000000) {
    return '${(value / 1000).toStringAsFixed(1)}k';
  } else if (value < 1000000000) {
    return '${(value / 1000000).toStringAsFixed(1)}M';
  } else {
    return '${(value / 1000000000).toStringAsFixed(1)}B';
  }
}


