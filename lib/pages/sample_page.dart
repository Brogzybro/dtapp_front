import 'package:dtapp_flutter/samples/sample_main_views/distance_main_view.dart';
import 'package:dtapp_flutter/samples/sample_main_views/ecg_main_view.dart';
import 'package:dtapp_flutter/samples/sample_main_views/heartrate_main_view.dart';
import 'package:dtapp_flutter/samples/samples_type_choices.dart';
import 'package:dtapp_flutter/samples/samples_views/date_grouped_samples_view.dart';
import 'package:flutter/material.dart';
import 'package:openapi/api.dart' as OA show Type;

class SamplePage extends StatefulWidget {
  SamplePage(this.choice, {this.otherUser});
  @override
  _SamplePageState createState() => _SamplePageState();
  final TypeChoice choice;
  final String otherUser;
}

class _SamplePageState extends State<SamplePage> {
  List<Widget> _tabChoices;
  List<Widget> _tabViews;

  @override
  initState() {
    final sampleMainView = _sampleMainViewFactory(widget.choice);
    _tabViews = [
      if (sampleMainView != null) Tab(child: Text("Main")),
      Tab(child: Text("Raw")),
    ];
    _tabChoices = [
      if (sampleMainView != null) sampleMainView,
      DateGroupedSamplesView(widget.choice, this.widget.otherUser),
    ];
    super.initState();
  }

  Widget _sampleMainViewFactory(TypeChoice choice) {
    switch (choice.type) {
      case OA.Type.distance_:
        return DistanceMainView(this.widget.otherUser);
        break;
      case OA.Type.heartRate_:
        return HeartRateMainView(this.widget.otherUser);
      case OA.Type.ecg_:
        return ECGMainView(this.widget.otherUser);
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: _tabChoices.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.choice.title),
            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.all(10),
                  child: TabBar(
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)), 
                      color: Colors.white30),
                    isScrollable: true,
                    tabs: _tabViews,
                  )),
            ],
          ),
          body: TabBarView(
              physics: NeverScrollableScrollPhysics(), children: _tabChoices),
          //DateGroupedSamplesView(widget.choice),
        ));
  }
}
