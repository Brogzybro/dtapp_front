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
  // TypeChoice _selectedChoice = choices[0];
  Map<String, List<TypeChoice>> _choicesGrouped;

  /*
  void _select(TypeChoice choice) {
    setState(() {
      _selectedChoice = choice;
    });
  }
  */

  @override
  void initState() {
    _choicesGrouped = _getChociesGrouped();
    super.initState();
  }

  void _actionButtonAction() async {
    print("Useless aciton button pressed yo");
    final devices = await devicesapiInstance.devicesGet();
    print(devices.reduce((dev, dev2) => dev..model += ", " + dev2.model).model);
    print(getDevicesGrouped(devices));
    // print(choices);
    // _getChociesGrouped();
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
            /*
                bottom: TabBar(
                    isScrollable: true,
                    tabs: <Widget>[Text("test"), Text("test2")],
                  ),
                  */
            /*
        actions: <Widget>[
          Center(child: Text(_selectedChoice.title)),
          PopupMenuButton(
            onSelected: _select,
            itemBuilder: (BuildContext context) {
              return choices.map((TypeChoice choice) {
                return PopupMenuItem<TypeChoice>(
                    value: choice, child: Text(choice.title));
              }).toList();
            },
            icon: Icon(Icons.filter_list),
          ),
        ],
        */
          ),
          body: SamplesMenuDevices(),
          floatingActionButton: FloatingActionButton(
              onPressed: _actionButtonAction,
              tooltip: 'Yo',
              child: Icon(Icons.add)),
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
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: devicesGrouped.keys.length,
            itemBuilder: (BuildContext context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Card(
                      child: ListTile(
                    title: Text(
                        capitalize(devicesGrouped.keys.elementAt(index)) +
                            " devices"),
                    subtitle: Text(devicesGrouped.values
                        .elementAt(index)
                        .fold("\n", (str, dev2) => str += dev2.model + '\n  - Type: ' + dev2.type + '\n  - Battery: ' + dev2.battery + '\n')),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () => goToSamplesForDevicePage(
                        context,
                        choices
                            .where((choice) =>
                                choice.source ==
                                devicesGrouped.keys.elementAt(index))
                            .toList()),
                  ))
                  /*
                  Container(
                      padding: EdgeInsets.only(top: 5, left: 5),
                      child: Text(
                          '${capitalize(devicesGrouped.keys.elementAt(index))}',
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
                        itemCount:
                            devicesGrouped.values.elementAt(index).length,
                        itemBuilder: (BuildContext context, index2) {
                          return Card(
                            child: ListTile(isThreeLine: true,
                              title: Text(devicesGrouped.values
                                    .elementAt(index)[index2]
                                    .model),
                              subtitle: Text("yooo yo\nyoyoyo\nyoyoyyo\nyoyoyoyo"),
                              /*
                              Row(children: <Widget>[
                                Text(devicesGrouped.values
                                    .elementAt(index)[index2]
                                    .model),
                                Text("test123")
                              ]),
                              */
                              trailing: Icon(Icons.keyboard_arrow_right),
                              /*
                        onTap: () => goToSamplePage(context,
                            _choicesGrouped.values.elementAt(index)[index2]),
                            */
                            ),
                          );
                        },
                      ))
                      */
                ],
              );
            },
          );
        });
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
