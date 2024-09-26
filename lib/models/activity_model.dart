//Created by MansoorSatti 8/7/2024
import 'package:cloud_firestore/cloud_firestore.dart';

import '../main.dart';

class ActivityModel {
  String? docId;
  int stepCount;
  double distance;
  String currentLocation;
  String orgTemperature; //original temperature
  String feelsTemperature;
  String userId;
  Timestamp? startTime;
  Timestamp? endTime;
  String status;

  ActivityModel({
    this.docId,
    required this.stepCount,
    required this.distance,
    required this.currentLocation,
    required this.orgTemperature,
    required this.feelsTemperature,
    required this.userId,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  ActivityModel.initialize()
      : stepCount = 0,
        distance = 0,
        currentLocation = '',
        orgTemperature = '',
        feelsTemperature = '',
        userId = auth.currentUser!.uid,
        startTime = null,
        endTime = null,
        status = 'Active';

  factory ActivityModel.fromDocumentSnapShot(
      DocumentSnapshot<Map<String, dynamic>> map) {
    return ActivityModel(
      docId: map.id,
      stepCount: map['stepCount'] ?? 0,
      distance: map.data()!.containsKey('distance') ? map['distance'].toDouble() ?? 0.0 : 0.0,
      currentLocation: map['currentLocation'] ?? '',
      orgTemperature: map['orgTemperature'] ?? "",
      feelsTemperature: map['feelsTemperature'] ?? '',
      userId: map['userId'] ?? '',
      startTime: map['startTime'],
      endTime: map['endTime'],
      status: map['status'] ?? 'inActive',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'docId': docId,
      'stepCount': stepCount,
      'distance': distance,
      'currentLocation': currentLocation,
      'orgTemperature': orgTemperature,
      'feelsTemperature': feelsTemperature,
      'userId': userId,
      'startTime': startTime,
      'endTime': endTime,
      'status': status,
    };
  }
}
