import 'package:flutter/material.dart';
import 'package:openapi/api.dart' hide Type;
import 'package:openapi/api.dart' as OA;

import 'sample_views/generic_sample_view.dart';
import 'sample_views/sleep_sample_view.dart';

Widget selectSampleView(BuildContext context, OA.Type type, Sample sample, Color color) {
  switch (type) {
    case OA.Type.sleep_:
      return SleepSampleView(sample, color);
      break;
    default:
      return GenericSampleView(context, sample, color);
  }
}