import 'package:dtapp_flutter/samples/sample_views/ecg_sample_view.dart';
import 'package:flutter/material.dart';
import 'package:openapi/api.dart' hide Type;
import 'package:openapi/api.dart' as OA;

import 'sample_views/generic_sample_view.dart';
import 'sample_views/sleep_sample_view.dart';

Widget selectSampleView(BuildContext context, OA.Type type, Sample sample, Color color) {
  return GenericSampleView(context, sample, color);
  /*
  switch (type) {
    case OA.Type.sleep_:
      return SleepSampleView(sample, color);
      break;
    case OA.Type.ecg_:
      return ECGSampleView(context, sample, color);
      break;
    default:
      return GenericSampleView(context, sample, color);
  }
  */
}