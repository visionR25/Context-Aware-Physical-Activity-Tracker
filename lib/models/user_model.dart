//Created by MansoorSatti 8/7/2024
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class UserModel {
  String? docId;
  TextEditingController name;
  TextEditingController email;
  TextEditingController password;
  TextEditingController dateOfBirth;
  RxString gender;
  RxString education;
  RxString physicalActivity;

  UserModel({
    this.docId,
    required this.name,
    required this.email,
    required this.password,
    required this.dateOfBirth,
    required this.gender,
    required this.education,
    required this.physicalActivity,
  });

  UserModel.initialize()
      : name = TextEditingController(),
        email = TextEditingController(),
        password = TextEditingController(),
        dateOfBirth = TextEditingController(),
        gender = "Male".obs,
        education = 'High School'.obs,
        physicalActivity = 'lightly Active'.obs;

  UserModel.copyModel(UserModel other)
      : docId = other.docId,
        name = other.name,
        email = other.email,
        password = other.password,
        dateOfBirth = other.dateOfBirth,
        gender = other.gender,
        education = other.education,
        physicalActivity = other.physicalActivity;

  factory UserModel.fromDocumentSnapShot(
      DocumentSnapshot<Map<String, dynamic>> map) {
    return UserModel(
      docId: map.id,
      name: TextEditingController(text: map['name'] ?? ''),
      email: TextEditingController(text: map['email'] ?? ''),
      password: TextEditingController(text: map['password'] ?? ''),
      dateOfBirth: TextEditingController(text: map['dateOfBirth'] ?? ''),
      gender: RxString(map['gender'] ?? ''),
      education: RxString(map['education'] ?? ''),
      physicalActivity: RxString(map['physicalActivity'] ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'docId': docId,
      'name': name.text.trim(),
      'email': email.text.trim(),
      'password': password.text.trim(),
      'dateOfBirth': dateOfBirth.text.trim(),
      'gender': gender.value,
      'education': education.value,
      'physicalActivity': physicalActivity.value,
    };
  }

  Map<String, dynamic> toUpdate() {
    return {
      'docId': docId,
      'name': name.text.trim(),
      'dateOfBirth': dateOfBirth.text.trim(),
      'gender': gender.value,
      'education': education.value,
      'physicalActivity': physicalActivity.value,
    };
  }
}
