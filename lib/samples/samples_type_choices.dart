import 'package:flutter/material.dart';
import 'package:openapi/api.dart' as OA;

class TypeChoice {
  const TypeChoice({this.title, this.type, this.iconData = Icons.assignment, this.source});

  final String title;
  final OA.Type type;
  final IconData iconData;
  final String source;
}

const List<TypeChoice> choices = const <TypeChoice>[
  const TypeChoice(
    title: 'Heart Rate',
    type: OA.Type.heartRate_,
    iconData: Icons.favorite,
    source: 'fitbit',
  ),
  const TypeChoice(
    title: 'Distance',
    type: OA.Type.distance_,
    iconData: Icons.directions_run,
    source: 'fitbit',
  ),
  const TypeChoice(
    title: 'Elevation',
    type: OA.Type.elevation_,
    iconData: Icons.flight_takeoff,
    source: 'fitbit',
  ),
  const TypeChoice(
    title: 'Sleep',
    type: OA.Type.sleep_,
    iconData: Icons.local_hotel,
    source: 'fitbit',
  ),
  const TypeChoice(
    title: 'Step Count',
    type: OA.Type.stepCount_,
    iconData: Icons.directions_walk,
    source: 'fitbit',
  ),
  const TypeChoice(
    title: 'Diastolic Blood Pressure',
    type: OA.Type.diastolicBloodPressure_,
    iconData: Icons.pause_circle_outline,
    source: 'withings'
  ),
  const TypeChoice(
    title: 'Systolic Blood Pressure',
    type: OA.Type.systolicBloodPressure_,
    iconData: Icons.compare_arrows,
    source: 'withings'
  ),
  const TypeChoice(
    title: 'Electrocardiogram ',
    type: OA.Type.ecg_,
    iconData: Icons.show_chart,
    source: 'withings'
  ),
  const TypeChoice(
    title: 'Body Temperature',
    type: OA.Type.bodyTemp_,
    iconData: Icons.record_voice_over,
    source: 'withings'
  ),
  const TypeChoice(
    title: 'Sleep',
    type: OA.Type.sleep_,
    iconData: Icons.local_hotel,
    source: 'withings',
  ),
  const TypeChoice(
    title: 'Weight',
    type: OA.Type.weight_,
    iconData: Icons.accessibility,
    source: 'withings'
  ),
  const TypeChoice(
    title: 'Fat Free Mass',
    type: OA.Type.fatFreeMass_,
    iconData: Icons.accessibility,
    source: 'withings'
  ),
  const TypeChoice(
    title: 'Fat Ratio',
    type: OA.Type.fatRatio_,
    iconData: Icons.accessibility,
    source: 'withings'
  ),
  const TypeChoice(
    title: 'Fat Mass Weight',
    type: OA.Type.fatMassWeight_,
    iconData: Icons.accessibility,
    source: 'withings'
  ),
  const TypeChoice(
    title: 'Muscle Mass',
    type: OA.Type.muscleMass_,
    iconData: Icons.accessibility,
    source: 'withings'
  ),
  const TypeChoice(
    title: 'Bone Mass',
    type: OA.Type.boneMass_,
    iconData: Icons.accessibility,
    source: 'withings'
  ),
  const TypeChoice(
    title: 'Pulse Wave Velocity',
    type: OA.Type.pulseWaveVelocity_,
    iconData: Icons.accessibility,
    source: 'withings'
  ),
];
