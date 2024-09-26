//Created by MansoorSatti 8/7/2024
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:physical_tracking_app/pages/activitiesScreen/activities_screen.dart';
import 'package:physical_tracking_app/pages/homeScreen/home_screen.dart';

import '../../insightsScreen/insigts_screen.dart';
import '../../moodScreen/mood_screen.dart';

class NavBarController extends GetxController {
  RxInt selectedIndex = 0.obs;

  static List<Widget> pages = [
    const HomeScreen(),
    ActivitiesScreen(),
    MoodScreen(),
    InsightsScreen(),
  ];
}
