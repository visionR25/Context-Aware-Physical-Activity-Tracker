import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:pedometer_2/pedometer_2.dart';
import 'package:physical_tracking_app/utils/check_physical_activity_permission.dart';
import 'package:physical_tracking_app/utils/get_location_permission.dart';

class ActivityController extends GetxController {
  RxInt stepCount = 0.obs;
  StreamSubscription? _subStepCount;
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  RxDouble orgTemperature = 0.0.obs;
  RxDouble feelTemperature = 0.0.obs;
  RxString currentLocation = ''.obs;
  Rx<int?> currentStep = Rx<int?>(null); // Updated declaration
  RxInt initialStepCount =
      0.obs; // Stores the initial step count when activity starts
  RxBool isCounting = false.obs; // Tracks if activity is ongoing

  @override
  void onInit() {
    super.onInit();
    ever(isCounting, (_) {
      _listenToSteps();
    });
    _listenToSteps();
  }

  Future<void> _listenToSteps() async {
    await determinePosition();
    await checkPhysicalActivityPermission();
    _subStepCount?.cancel(); // Cancel any existing subscription

    _subStepCount = Pedometer().stepCountStream().listen((steps) {
      stepCount.value = steps;

      if (isCounting.value) {
        currentStep.value = stepCount.value - initialStepCount.value;
      }
    });
  }

  Future<void> determinePosition() async {
    bool havePermission = await getLocationPermissions();
    if (!havePermission) {
      Get.snackbar('Permission Denied', 'Location permission is required.');
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.high));
    latitude.value = position.latitude;
    longitude.value = position.longitude;
  }

  void startActivity() {
    initialStepCount.value = stepCount.value; // Set the initial step count
    currentStep.value = 0; // Start counting from zero
    isCounting.value = true; // Mark the activity as ongoing
  }

  void stopActivity() {
    isCounting.value = false; // Stop the activity
    currentStep.value = null; // Reset current step counter
  }

  @override
  void dispose() {
    _subStepCount?.cancel();
    super.dispose();
  }
}
