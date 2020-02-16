import 'dart:io';

import 'package:dtapp_flutter/util/sample_json_encoding.dart';
import 'package:flutter/material.dart';
import 'package:openapi/api.dart' hide Type;
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

final loadingContentController = BehaviorSubject<LoadingContent>();

SamplesApi samplesApi = SamplesApi();

enum LoadingState { NULL, LOADING, READY, ERROR }

class LoadingContent {
  LoadingContent(this.state, {this.progressString, this.path});
  LoadingState state;
  String progressString;
  String path;
}

class ExportDataWidget extends StatefulWidget {
  @override
  _ExportDataWidgetState createState() => _ExportDataWidgetState();
}

class _ExportDataWidgetState extends State<ExportDataWidget> {
  Future<String> _exportData() async {
    loadingContentController.add(LoadingContent(LoadingState.LOADING,
        progressString: "Getting samples..."));

    var allSamples = List<Sample>();
    const SAMPLE_LIMIT = 10000;
    var offset = 0;
    var curLength = 0;
    do {
      final samples =
          await samplesApi.samplesGet(limit: SAMPLE_LIMIT, offset: offset);
      offset += samples.length;
      curLength = samples.length;
      allSamples.addAll(samples);
      print("offset " + offset.toString());
      loadingContentController.add(LoadingContent(LoadingState.LOADING,
          progressString: "Samples loaded so far: " + offset.toString()));
    } while (curLength >= SAMPLE_LIMIT);

    print("Got " + allSamples.length.toString() + " samples");

    String jsonSamples = null;
    try {
      jsonSamples = sampleJSONEncoding(allSamples);
    } catch (e) {
      print(e);
      loadingContentController.add(
          LoadingContent(LoadingState.ERROR, progressString: e.toString()));
      return "Failure";
    }
    print(jsonSamples);

    try {
      // TODO cross platform solution for getExternalStorageDirectory
      final path = (await getExternalStorageDirectory()).path;
      print(path);
      final fullPath = '$path/samples.json';
      final file = File(fullPath);
      await file.writeAsString(jsonSamples);
      loadingContentController
          .add(LoadingContent(LoadingState.READY, path: fullPath));
      return "Data saved to file: " + fullPath;
    } catch (e) {
      print("Error exporting data to file.");
      print(e);
      loadingContentController.add(LoadingContent(LoadingState.NULL));
      return "Error";
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: loadingContentController.stream,
        initialData: LoadingContent(LoadingState.NULL),
        builder: (BuildContext context, snapshot) {
          final loadingContent = snapshot.data;
          return Row(children: <Widget>[
            RaisedButton(
              child: Text("Export data"),
              onPressed: (loadingContent.state == LoadingState.LOADING)
                  ? null
                  : _exportData,
            ),
            if (loadingContent.state != LoadingState.NULL)
              if (loadingContent.state == LoadingState.LOADING)
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(loadingContent.progressString),
                      CircularProgressIndicator(),
                    ],
                  ),
                ))
              else
                Flexible(
                    child: Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: loadingContent.state == LoadingState.READY
                            ? Text("Data saved to " + loadingContent.path)
                            : Text(
                                "Failed: " + loadingContent.progressString,
                                style: TextStyle(color: Colors.red),
                              )))
            else
              Container()
          ]);
        });
  }
}
