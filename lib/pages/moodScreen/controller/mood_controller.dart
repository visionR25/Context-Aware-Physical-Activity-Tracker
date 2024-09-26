//Created by MansoorSatti 8/9/2024
import 'dart:ui';

import 'package:get/get.dart';

import '../../../models/mood_check_model.dart';

class MoodController extends GetxController {
  // RxString moodEmojiValue = ''.obs;
  //
  // RxDouble minValue=1.0.obs;
  // RxDouble maxValue=1.0.obs;

  final List<MoodQuestionsModel> moodQuestions = [
    MoodQuestionsModel(
      question: "How happy do you feel right now?",
      sliderValues: 3.0.obs,
      textDirection: TextDirection.ltr,
    ),
    MoodQuestionsModel(
      question: "How energetic do you feel right now?",
      sliderValues: 3.0.obs,
      textDirection: TextDirection.ltr,
    ),
    MoodQuestionsModel(
      question: "How calm do you feel right now?",
      sliderValues: 3.0.obs,
      textDirection: TextDirection.ltr,
    ),
    MoodQuestionsModel(
      question: "How nervous do you feel right now?",
      sliderValues: 3.0.obs,
      textDirection: TextDirection.ltr,
    ),
    MoodQuestionsModel(
      question: "How tired do you feel right now?",
      sliderValues: 3.0.obs,
      textDirection: TextDirection.ltr,
    ),
    MoodQuestionsModel(
      question: "How sad do you feel right now?",
      sliderValues: 3.0.obs,
      textDirection: TextDirection.rtl,
    ),
  ];
}
