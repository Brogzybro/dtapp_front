import 'package:dtapp_flutter/samples/sample_views/sample_dialog.dart';
import 'package:dtapp_flutter/util/date_format.dart';
import 'package:flutter/material.dart';
import 'package:openapi/api.dart' hide Type;

class GenericSampleView extends StatelessWidget {
  GenericSampleView(this.context, this.sample, this.color);
  final Sample sample;
  final Color color;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => mydialog(context, sample),
        child: Container(
            height: 50,
            color: color,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                          '${sample.type.value} : ${(sample.value is double) ? (sample.value as num).toStringAsFixed(4) : sample.value}'),
                      Text("Source: ${sample.source_}")
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                          "Start: ${formatDate(DateTime.fromMillisecondsSinceEpoch(sample.startDate))}"),
                      Text(
                          "End: ${formatDate(DateTime.fromMillisecondsSinceEpoch(sample.endDate))}")
                    ],
                  )
                ])));
  }
}
