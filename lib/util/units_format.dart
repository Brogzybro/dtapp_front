/*
Distance: KM
Sleep: ms
Elevation: m
Blood Pessure: mmHg
Weight: grams
Bodytemp: Celsius unit -3
*/

import 'package:dtapp_flutter/model/ecg.dart';
import 'package:openapi/api.dart' as OA;
import 'dart:math' as math;

String formatType(OA.Type type, Object value) {
  var func = formatMap[type];
  return (func != null)
      ? func(value)
      : (value is int) ? value.toString() : (value as num).toStringAsFixed(4);
}

Map<OA.Type, String Function(Object)> formatMap =
    <OA.Type, String Function(Object)>{
  OA.Type.heartRate_: (Object heartRateInBPMObj) {
    return formatHeartRate(heartRateInBPMObj as num);
  },
  OA.Type.distance_: (Object distanceInKMObj) {
    return formatDistance(distanceInKMObj as num);
  },
  OA.Type.elevation_: (Object heightInMetersObj) {
    return formatElevation(heightInMetersObj as num);
  },
  OA.Type.sleep_: (Object sleepDurationInMillisecondsObj) {
    var sleepDuration = Duration(
      milliseconds: (sleepDurationInMillisecondsObj as num),
    );

    return "${sleepDuration.inHours} hrs ${sleepDuration.inMinutes - (sleepDuration.inHours * 60)} min";
  },
  OA.Type.stepCount_: (Object val) {
    return '${(val as int)} steps';
  },
  OA.Type.diastolicBloodPressure_: (Object val) {
    return '${(val as int)} mmHg';
  },
  OA.Type.systolicBloodPressure_: (Object val) {
    return '${(val as int)} mmHg';
  },
  OA.Type.ecg_: (Object val) {
    return 'ECG Sample';
  },
  OA.Type.bodyTemp_: (Object val) {
    // Temporary workaround because different unit forms are not saved with data samples currently
    // (See withings measures "unit" along with "value")
    return '${((val as int) / (math.pow(10, ((val as int).toString().length - 2)))).toStringAsFixed(3)} °C';
    /*
    if ((val as int).toString().length > 5)
      return '${((val as int) / 10000000).toStringAsFixed(3)} °C';
    else if ((val as int).toString().length > 3)
      return '${((val as int) / 1000).toStringAsFixed(3)} °C';
    else
      return '${((val as int) / 10).toStringAsFixed(3)} °C';
      */
  },
  OA.Type.weight_: (Object val) {
    return '${((val as int) / 1000).toStringAsFixed(2)} kg';
  },
  OA.Type.fatFreeMass_: (Object val) {
    return '${((val as int) / 1000).toStringAsFixed(2)} kg';
  },
  OA.Type.fatRatio_: (Object val) {
    return '${((val as int) / 1000).toStringAsFixed(2)}%';
  },
  OA.Type.fatMassWeight_: (Object val) {
    // unit (kg -2) decagram
    return '${((val as int) / 100).toStringAsFixed(2)} kg';
  },
  OA.Type.muscleMass_: (Object val) {
    // unit (kg -2) decagram
    return '${((val as int) / 100).toStringAsFixed(2)} kg';
  },
  OA.Type.boneMass_: (Object val) {
    // unit (kg -2) decagram
    return '${((val as int) / 100).toStringAsFixed(2)} kg';
  },
  OA.Type.pulseWaveVelocity_: (Object val) {
    return '${((val as int) / 1000).toStringAsFixed(3)} m/s';
  },
};

String formatHeartRate(num heartRateInBPM) {
  return "$heartRateInBPM bpm";
}

String formatDistance(num distanceInKM) {
  if (distanceInKM < 1)
    return "${(distanceInKM * 1000).toStringAsFixed(1)} m";
  else
    return "${distanceInKM.toStringAsFixed(4)} km";
}

String formatElevation(num heightInMeters) {
  return "${heightInMeters.toStringAsPrecision(3)} m";
}
