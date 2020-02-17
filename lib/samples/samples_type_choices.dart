import 'package:flutter/material.dart';
import 'package:openapi/api.dart' as OA;

class TypeChoice {
  const TypeChoice({this.title, this.type, this.iconData = Icons.assignment});

  final String title;
  final OA.Type type;
  final IconData iconData;
}

const List<TypeChoice> choices = const <TypeChoice>[
  const TypeChoice(title: 'Distance', type: OA.Type.distance_, iconData: Icons.directions_run),
  const TypeChoice(title: 'Elevation', type: OA.Type.elevation_, iconData: Icons.flight_takeoff),
  const TypeChoice(title: 'Heart rate', type: OA.Type.heartRate_, iconData: Icons.favorite),
  const TypeChoice(title: 'Sleep', type: OA.Type.sleep_, iconData: Icons.local_hotel),
  const TypeChoice(title: 'Step count', type: OA.Type.stepCount_, iconData: Icons.directions_walk),
  const TypeChoice(title: 'Diastolic Blood Pressure', type: OA.Type.diastolicBloodPressure_, iconData: Icons.pause_circle_outline),
  const TypeChoice(title: 'Systolic Blood Pressure', type: OA.Type.systolicBloodPressure_, iconData: Icons.compare_arrows)
];
