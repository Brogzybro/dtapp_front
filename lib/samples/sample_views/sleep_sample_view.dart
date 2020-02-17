import 'package:flutter/material.dart';
import 'package:openapi/api.dart' hide Type;

class SleepSampleView extends StatelessWidget {
  SleepSampleView(this.sample, this.color);
  final Sample sample;
  final Color color;
  @override
  Widget build(BuildContext context) {
    final Duration duration = Duration(milliseconds: sample.value);
    return Container(
      height: 50,
      color: color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('Slept ${duration.inHours} hrs ${duration.inMinutes - (duration.inHours * 60)} min'),
              Text("Collected from: ${sample.source_}")
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("From: ${DateTime.fromMillisecondsSinceEpoch(sample.startDate)}"), 
              Text("To: ${DateTime.fromMillisecondsSinceEpoch(sample.endDate)}")
            ],
          )
        ]
      )
    );
  }
}