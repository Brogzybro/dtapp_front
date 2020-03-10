import 'package:dtapp_flutter/pages/samples_fordevice_page.dart';
import 'package:dtapp_flutter/util/string_format.dart';
import 'package:flutter/material.dart';
import 'package:openapi/api.dart' hide Type;

import '../samples/samples_type_choices.dart';

final samplesapiInstance = SamplesApi();
final devicesapiInstance = DevicesApi();

class SamplesPage extends StatefulWidget {
  SamplesPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SamplesPageState createState() => _SamplesPageState();
}

class _SamplesPageState extends State<SamplesPage> {
  Map<String, List<TypeChoice>> _choicesGrouped;

  @override
  void initState() {
    _choicesGrouped = _getChociesGrouped();
    super.initState();
  }

  Map<String, List<TypeChoice>> _getChociesGrouped() {
    return choices.fold<Map<String, List<TypeChoice>>>({}, (map, currentMap) {
      if (map[currentMap.source] == null) {
        map[currentMap.source] = [];
      }
      map[currentMap.source].add(currentMap);
      return map;
    });
  }

  Widget build(BuildContext context) {
    return Navigator(onGenerateRoute: (RouteSettings settings) {
      return MaterialPageRoute(builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Devices"),
            actions: <Widget>[],
          ),
          body: SamplesMenuDevices(),
        );
      });
    });
  }
}

Map<String, List<Device>> getDevicesGrouped(List<Device> devices) {
  return devices.fold<Map<String, List<Device>>>({}, (map, currentMap) {
    if (map[currentMap.source_] == null) {
      map[currentMap.source_] = [];
    }
    map[currentMap.source_].add(currentMap);
    return map;
  });
}

Future<Map<String, List<Device>>> getDevicesGroupedFuture() async {
  return getDevicesGrouped(await devicesapiInstance.devicesGet());
}

void goToSamplesForDevicePage(BuildContext context, List<TypeChoice> choices) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SamplesForDevicePage(choices)),
  );
}

class SamplesMenuDevices extends StatelessWidget {
  SamplesMenuDevices();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getDevicesGroupedFuture(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData != true)
            return Center(child: CircularProgressIndicator());

          final devicesGrouped = snapshot.data as Map<String, List<Device>>;
          return Container(
              child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: devicesGrouped.keys.length,
            itemBuilder: (BuildContext context, index) {
              return GestureDetector(
                child: DevicesCard(
                  devicesGrouped.keys.elementAt(index),
                  devicesGrouped.values.elementAt(index),
                ),
                onTap: () => {
                  goToSamplesForDevicePage(
                      context,
                      choices
                          .where((choice) =>
                              choice.source ==
                              devicesGrouped.keys.elementAt(index))
                          .toList())
                },
              );
            },
          ));
        });
  }
}

class DevicesCard extends StatelessWidget {
  DevicesCard(this.title, this.devices);
  final String title;
  final List<Device> devices;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(capitalize(title), style: TextStyle(fontSize: 18)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ...(devices.map((device) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(device.model),
                                    Text(device.type,
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.grey[600]))
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Icon(Icons.battery_charging_full,
                                        color: (device.battery == "high")
                                            ? Colors.green
                                            : Colors.yellow[700]),
                                    Text(device.battery)
                                  ],
                                )
                              ],
                            );
                          }).toList())
                        ],
                      )),
                ),
                Icon(Icons.keyboard_arrow_right)
              ],
            )
          ],
        ),
      ),
    );
  }
}

class TestTestTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[Text("model"), Text("type")],
        ),
        Text("battery")
      ],
    );
  }
}

class SamplesMenu extends StatelessWidget {
  SamplesMenu(this._choicesGrouped);
  final Map<String, List<TypeChoice>> _choicesGrouped;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: _choicesGrouped.keys.length,
      itemBuilder: (BuildContext context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(top: 5, left: 5),
                child:
                    Text('${capitalize(_choicesGrouped.keys.elementAt(index))}',
                        style: TextStyle(
                          fontSize: 20,
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 1,
                              color: Color.fromARGB(100, 0, 0, 0),
                            ),
                          ],
                        ))),
            Container(
                padding: EdgeInsets.all(5),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: _choicesGrouped.values.elementAt(index).length,
                  itemBuilder: (BuildContext context, index2) {
                    return Card(
                      child: ListTile(
                        title: Row(children: <Widget>[
                          Icon(_choicesGrouped.values
                              .elementAt(index)[index2]
                              .iconData),
                          SizedBox(
                            width: 10,
                          ),
                          Text(_choicesGrouped.values
                              .elementAt(index)[index2]
                              .title),
                        ]),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () => goToSamplePage(context,
                            _choicesGrouped.values.elementAt(index)[index2]),
                      ),
                    );
                  },
                ))
          ],
        );
      },
    );
  }
}
