import 'package:flutter/material.dart';
import 'package:openapi/api.dart' hide Type;
import 'package:openapi/api.dart' as OA;

class GenericSampleView extends StatelessWidget {
  GenericSampleView(this.sample, this.color);
  final Sample sample;
  final Color color;
  @override
  Widget build(BuildContext context) {
    var string = sample.type.toString();
    return Container(
      height: 50,
      color: color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('${sample.type.value} : ${(sample.value is double) ? sample.value.toStringAsFixed(4) : sample.value}'),
              Text("Collected from: ${sample.source_}")
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("Start date: ${DateTime.fromMillisecondsSinceEpoch(sample.startDate)}"), 
              Text("End date: ${DateTime.fromMillisecondsSinceEpoch(sample.endDate)}")
            ],
          )
        ]
      )
    );
  }
}