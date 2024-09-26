//Created by MansoorSatti 8/27/2024
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class MoodActivityModel {
  String? docId;
  String userId;
  Timestamp? time;
  List<DataBaseQuestion> questions;

  MoodActivityModel(
      {this.docId, required this.userId, this.time, required this.questions});

  factory MoodActivityModel.fromDocumentSnapShot(
      DocumentSnapshot<Map<String, dynamic>> map) {
    return MoodActivityModel(
      docId: map.id,
      userId: map['userId'] ?? '',
      time: map['time'],
      questions: List<DataBaseQuestion>.from(
          map['questions'].map((e) => DataBaseQuestion.fromMap(e))),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'docId': docId,
      'userId': userId,
      'time': FieldValue.serverTimestamp(),
      'questions': questions.map((e) => e.toMap()),
    };
  }
}

///handle question from database
class DataBaseQuestion {
  String question;
  double answer;
  // double max;

  DataBaseQuestion({
    required this.question,
    required this.answer,
    // required this.max,
  });

  factory DataBaseQuestion.fromMap(Map<String, dynamic> map) {
    return DataBaseQuestion(
      question: map['question'],
      answer: map['answer'].toDouble(),
      // max: map['max'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answer': answer,
      // 'max': max,
    };
  }
}

///handle question mode front end
class MoodQuestionsModel {
  String question;
  RxDouble sliderValues;
  TextDirection textDirection;

  MoodQuestionsModel(
      {required this.question,
      required this.sliderValues,
      required this.textDirection});
}
