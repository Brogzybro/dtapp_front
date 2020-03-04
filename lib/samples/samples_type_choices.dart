import 'package:flutter/material.dart';
import 'package:openapi/api.dart' as OA;

class TypeChoice {
  const TypeChoice({this.title, this.type, this.iconData = Icons.assignment});

  final String title;
  final OA.Type type;
  final IconData iconData;
}

const List<TypeChoice> choices = const <TypeChoice>[
  const TypeChoice(title: 'Heart Rate', type: OA.Type.heartRate_, iconData: Icons.favorite),
  const TypeChoice(title: 'Distance', type: OA.Type.distance_, iconData: Icons.directions_run),
  const TypeChoice(title: 'Elevation', type: OA.Type.elevation_, iconData: Icons.flight_takeoff),
  const TypeChoice(title: 'Sleep', type: OA.Type.sleep_, iconData: Icons.local_hotel),
  const TypeChoice(title: 'Step Count', type: OA.Type.stepCount_, iconData: Icons.directions_walk),
  const TypeChoice(title: 'Diastolic Blood Pressure', type: OA.Type.diastolicBloodPressure_, iconData: Icons.pause_circle_outline),
  const TypeChoice(title: 'Systolic Blood Pressure', type: OA.Type.systolicBloodPressure_, iconData: Icons.compare_arrows),
  const TypeChoice(title: 'Electrocardiogram ', type: OA.Type.ecg_, iconData: Icons.show_chart),
  const TypeChoice(title: 'Body Temperature', type: OA.Type.bodyTemp_, iconData: Icons.record_voice_over),
  const TypeChoice(title: 'Weight', type: OA.Type.weight_, iconData: Icons.accessibility),
  const TypeChoice(title: 'Fat Free Mass', type: OA.Type.fatFreeMass_, iconData: Icons.accessibility),
  const TypeChoice(title: 'Fat Ratio', type: OA.Type.fatRatio_, iconData: Icons.accessibility),
  const TypeChoice(title: 'Fat Mass Weight', type: OA.Type.fatMassWeight_, iconData: Icons.accessibility),
  const TypeChoice(title: 'Muscle Mass', type: OA.Type.muscleMass_, iconData: Icons.accessibility),
  const TypeChoice(title: 'Bone Mass', type: OA.Type.boneMass_, iconData: Icons.accessibility),
  const TypeChoice(title: 'Pulse Wave Velocity', type: OA.Type.pulseWaveVelocity_, iconData: Icons.accessibility),
];
