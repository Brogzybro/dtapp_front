import 'package:flutter/material.dart';
import 'package:openapi/api.dart' hide Type;
import 'package:openapi/api.dart' as OA;

class GenericSampleView extends StatelessWidget {
  GenericSampleView(this.context, this.sample, this.color);
  final Sample sample;
  final Color color;
  final BuildContext context;

  Future<void> _openDialog() async {
    switch (await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Raw sample data'),
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Table(
                children: sample.toJson().map((k, v){
                            return MapEntry(k, TableRow(children: [Text(k.toString()), Text(v.toString())]));
                          }).values.toList()
              )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () { Navigator.pop(context, "closed"); },
                  child: const Text('Close'),
                )
              ]
            ),
          ],
        );
      }
    )) {
      case "closed":
        // Closed with button
      break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var string = sample.type.toString();
    return GestureDetector(
      onTap: _openDialog,
      child: Container(
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
      )
    );
  }
}