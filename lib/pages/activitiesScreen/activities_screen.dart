//Created by MansoorSatti 8/7/2024

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:physical_tracking_app/pages/activitiesScreen/controller/activity_controller.dart';
import 'package:physical_tracking_app/services/weather_service.dart';

import '../../utils/global_functions.dart';
import '../../widgets/activity_widget.dart';

class ActivitiesScreen extends StatelessWidget {
  ActivitiesScreen({super.key});

  final controller = Get.put(ActivityController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Obx(
            () => buildActivityWidget(
              iconPath: "assets/icons/running_icon.svg",
              title: "Steps",
              content: controller.isCounting.value
                  ? controller.currentStep.value?.toString() ?? '0'
                  : controller.stepCount.value.toString(),
            ),
          ),
          Obx(
            () => buildActivityWidget(
              iconPath: "assets/icons/distance_icon.svg",
              title: "Distance",
              content: formatDistance(controller.isCounting.value
                  ? ((controller.currentStep.value ?? 0) * 0.762)
                  : (controller.stepCount.value * 0.762)),
            ),
          ),
          Obx(
            () => FutureBuilder(
              future: getAddressFromLatLng(
                  controller.latitude.value, controller.longitude.value),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  controller.currentLocation.value = snapshot.data!;
                  return buildActivityWidget(
                    iconPath: "assets/icons/map_icon.svg",
                    title: "Current Location",
                    content: snapshot.data ?? '',
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return buildActivityWidget(
                  iconPath: "assets/icons/map_icon.svg",
                  title: "Current Location",
                  content: "Loading...",
                );
              },
            ),
          ),
          Obx(
            () => FutureBuilder(
              future: WeatherService().fetchWeather(
                  controller.latitude.value, controller.longitude.value),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final weather = snapshot.data!['current_weather'];
                  final temperature =
                      weather['temperature']; // Assuming the API provides this
                  final weatherCode =
                      weather['weathercode']; // Weather condition code

                  double windSpeed = weather['windspeed']; // wind speed in m/s

                  double feelsLike = WeatherService()
                      .calculateFeelsLikeTemperature(temperature, windSpeed);

                  controller.orgTemperature.value = temperature;
                  controller.feelTemperature.value = temperature;

                  return buildActivityWidget(
                    iconPath: "assets/icons/weather_icon.svg",
                    title: "Weather Today",
                    content: temperature.toString(),
                    feelsLike: feelsLike.toString(),
                    weatherCode: weatherCode,
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return buildActivityWidget(
                    iconPath: "assets/icons/weather_icon.svg",
                    title: "Weather Today",
                    content: "Loading",
                    feelsLike: "Loading");
              },
            ),
          ),
        ],
      ),
    );
  }
}
