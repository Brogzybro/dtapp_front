import 'package:openapi/api.dart' as OA;

class TypeChoice {
  const TypeChoice({this.title, this.type});

  final String title;
  final OA.Type type;
}

const List<TypeChoice> choices = const <TypeChoice>[
  const TypeChoice(title: 'Distance', type: OA.Type.distance_),
  const TypeChoice(title: 'Elevation', type: OA.Type.elevation_),
  const TypeChoice(title: 'Heart rate', type: OA.Type.heartRate_),
  const TypeChoice(title: 'Sleep', type: OA.Type.sleep_),
  const TypeChoice(title: 'Step count', type: OA.Type.stepCount_),
  const TypeChoice(title: 'Diastolic Blood Pressure', type: OA.Type.diastolicBloodPressure_),
  const TypeChoice(title: 'Systolic Blood Pressure', type: OA.Type.systolicBloodPressure_)
];
