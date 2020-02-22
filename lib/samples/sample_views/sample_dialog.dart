import 'package:flutter/material.dart';
import 'package:openapi/api.dart';

Future<void> mydialog(BuildContext context, Sample sample) async {
  switch (await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Raw sample data'),
          children: <Widget>[
            Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Table(
                    children: sample
                        .toJson()
                        .map((k, v) {
                          return MapEntry(
                              k,
                              TableRow(children: [
                                Text(k.toString()),
                                Text(v.toString())
                              ]));
                        })
                        .values
                        .toList())),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, "closed");
                },
                child: const Text('Close'),
              )
            ]),
          ],
        );
      })) {
    case "closed":
      // Closed with button
      break;
  }
}
