//Created by MansoorSatti 8/9/2024

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:physical_tracking_app/constants/app_colors.dart';
import 'package:physical_tracking_app/models/mood_check_model.dart';
import 'package:physical_tracking_app/pages/moodScreen/controller/mood_controller.dart';
import 'package:physical_tracking_app/services/db_services.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class MoodScreen extends StatelessWidget {
  MoodScreen({super.key});

  final controller = Get.put(MoodController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 36),
      child: FutureBuilder(
        future: DBServices().getQuestionAnswers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                controller.moodQuestions.length,
                (index) {
                  MoodQuestionsModel question = controller.moodQuestions[index];
                  if (snapshot.data!
                      .where(
                        (element) => element.question == question.question,
                      )
                      .isNotEmpty) {
                    DataBaseQuestion dbQuestion = snapshot.data!.firstWhere(
                        (element) => element.question == question.question);
                    question.sliderValues.value = dbQuestion.answer;
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildQuestion(
                            text:
                                "Q ${(index + 1).toString().padLeft(2, '0')}"),
                        const SizedBox(height: 4),
                        _buildQuestion(text: question.question),
                        const SizedBox(height: 24),
                        Obx(
                          () => SfRangeSliderTheme(
                            data: SfRangeSliderThemeData(
                              activeLabelStyle: _buildCustomText(),
                              inactiveLabelStyle: _buildCustomText(),
                            ),
                            child: Directionality(
                              textDirection: question.textDirection,
                              child: SfSlider(
                                min: 1.0,
                                max: 5.0,
                                interval: 1,
                                stepSize: 1,
                                showLabels: true,
                                activeColor: AppColors.skyBlue,
                                value: question.sliderValues.value,
                                onChanged: (value) {
                                  question.sliderValues.value = value;
                                  DBServices().updateOrAddMoodActivity(
                                      moodQuestion: question);
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
          return SizedBox(
            height: Get.height / 2,
            width: Get.width,
            child: const Center(
              child: CircularProgressIndicator(
                color: AppColors.skyBlue,
              ),
            ),
          );
        },
      ),
    );
  }

  Text _buildQuestion({required String text}) {
    return Text(
      text,
      style: _buildCustomText(),
    );
  }

  TextStyle _buildCustomText() {
    return const TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 16,
      fontFamily: "Raleway",
      color: AppColors.white,
    );
  }
}
