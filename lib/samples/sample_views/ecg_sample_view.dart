import 'package:dtapp_flutter/model/ecg.dart';
import 'package:dtapp_flutter/samples/sample_views/sample_dialog.dart';
import 'package:dtapp_flutter/util/date_format.dart';
import 'package:flutter/material.dart';
import 'package:openapi/api.dart' hide Type;

class ECGSampleView extends StatelessWidget {
  ECGSampleView(this.context, this.sample, this.color) : ecg = ECG.fromJson(sample.value);
  final Sample sample;
  final Color color;
  final BuildContext context;
  final ECG ecg;

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
                Text('${sample.type.value} : [id: ${ecg.signalid.toString()}]'),
                Text("Source: ${sample.source_}")
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("Start: ${formatDateTimeFull(DateTime.fromMillisecondsSinceEpoch(sample.startDate))}"), 
                Text("End: ${formatDateTimeFull(DateTime.fromMillisecondsSinceEpoch(sample.endDate))}")
              ],
            )
          ]
        )
      )
    );
  }
}