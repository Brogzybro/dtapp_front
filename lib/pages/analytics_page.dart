import 'dart:async';

import 'package:dtapp_flutter/export_data_widget.dart';
import 'package:dtapp_flutter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:openapi/api.dart' hide Type;
import 'package:url_launcher/url_launcher.dart';

import 'login_page.dart';

UserApi userApi = UserApi();
FitbitApi fitbitApi = FitbitApi();
SamplesApi samplesApi = SamplesApi();
WithingsApi withingsApi = WithingsApi();
PredictionApi predictionApi = PredictionApi();

class AnalyticsPage extends StatefulWidget {
  @override
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  Future<String> _getHyperTensionRisk() async {
    String r = "No data";
    try {
      var p = await predictionApi.predictionGet();
      if (p.risk != -1) {
        double result = p.risk;
        r = result.toStringAsFixed(4);
      }
    } catch (e) {
      print(e);
    }
    return r;
  }

  Future<String> _refresh() {
    setState(() {});
    return Future.value("value doesnt matter ay lmao");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Analytics"),
        ),
        body: RefreshIndicator(
            child: ListView(children: <Widget>[
              AnalyticsSection(
                  title: Text("Risk predictions"),
                  children: <Widget>[
                    Text(
                        "Risk is calculated by your age and latest blood pressure data. Anything above 0.250 is regarded as high risk. Color code to the right is meant as an intuitive way of showing whether you are at risk or not."),
                    AnalyticsItem(
                        leftItem: Text("Hypertension risk"),
                        middleItem:
                            PredictionItem(future: _getHyperTensionRisk),
                        rightItem: PredictionColorCode(
                            predictionRisk: _getHyperTensionRisk))
                  ])
            ]),
            onRefresh: _refresh));
  }
}

class AnalyticsSection extends StatelessWidget {
  AnalyticsSection({@required this.title, @required this.children});
  final Widget title;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(margin: EdgeInsets.all(10), child: title),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: children)
            ]));
  }
}

class AnalyticsItem extends StatelessWidget {
  AnalyticsItem(
      {@required this.leftItem,
      @required this.middleItem,
      @required this.rightItem});
  final Widget leftItem;
  final Widget middleItem;
  final Widget rightItem;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        child: Card(
            child: Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[leftItem, middleItem, rightItem]))));
  }
}

class PredictionColorCode extends StatefulWidget {
  PredictionColorCode({@required this.predictionRisk});
  final Future Function() predictionRisk;
  @override
  _PredictionColorCodeState createState() => _PredictionColorCodeState();
}

class _PredictionColorCodeState extends State<PredictionColorCode> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.predictionRisk(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            double r = double.parse(snapshot.data);
            return SizedBox(
              width: 15.0,
              height: 15.0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                    color: r >= 0.250 ? Colors.red : Colors.green),
              ),
            );
          }
          return CircularProgressIndicator();
        });
  }
}

class PredictionItem extends StatefulWidget {
  PredictionItem({@required this.future});
  final Future Function() future;
  @override
  _PredictionItemState createState() => _PredictionItemState();
}

class _PredictionItemState extends State<PredictionItem> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.future(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return Text("${snapshot.data}");
          }
          return CircularProgressIndicator();
        });
  }
}
