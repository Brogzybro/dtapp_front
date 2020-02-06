import 'package:flutter/material.dart';
import 'package:openapi/api.dart' hide Type;
import 'package:openapi/api.dart' as OA;

import 'GenericSampleView.dart';
import 'SleepSampleView.dart';

Widget selectSampleView(OA.Type type, Sample sample, Color color) {
  switch (type) {
    case OA.Type.sleep_:
      return SleepSampleView(sample, color);
      break;
    default:
      return GenericSampleView(sample, color);
  }
}