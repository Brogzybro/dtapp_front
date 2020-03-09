import 'package:dtapp_flutter/samples/sample_views/sample_dialog.dart';
import 'package:dtapp_flutter/util/date_format.dart';
import 'package:dtapp_flutter/util/string_format.dart';
import 'package:dtapp_flutter/util/units_format.dart';
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
      behavior: HitTestBehavior.opaque,
        onTap: () => mydialog(context, sample),
        child: Container(
            height: 50,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${formatType(sample.type, sample.value)}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text("${capitalize(sample.source_)}"),
                    ],
                  )),
                  Container(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      TimeWidget(
                        DateTime.fromMillisecondsSinceEpoch(sample.startDate),
                      ),
                      Row(
                        children: <Widget>[
                          Text("to"),
                          SizedBox(width: 2),
                          TimeWidget(
                            DateTime.fromMillisecondsSinceEpoch(sample.endDate),
                          ),
                        ],
                      )
                    ],
                  ))
                ])));
  }
}

class TimeWidget extends StatelessWidget {
  TimeWidget(this.date);
  DateTime date;
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          color: Colors.black45, borderRadius: BorderRadius.circular(3)),
      child: Container(
        padding: EdgeInsets.only(top: 1, bottom: 1, left: 3, right: 3),
        child: Text("${formatTimeFull(date)}",
            style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
