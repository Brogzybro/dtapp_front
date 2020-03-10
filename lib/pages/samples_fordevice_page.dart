import 'package:dtapp_flutter/pages/sample_page.dart';
import 'package:dtapp_flutter/samples/samples_type_choices.dart';
import 'package:dtapp_flutter/util/string_format.dart';
import 'package:flutter/material.dart';

void goToSamplePage(BuildContext context, TypeChoice choice) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SamplePage(choice)),
  );
}

class SamplesForDevicePage extends StatelessWidget {
  SamplesForDevicePage(this.choices);
  final List<TypeChoice> choices;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(capitalize(choices.first.source) + " samples"),
        ),
        body: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: choices.length,
          itemBuilder: (BuildContext context, index) {
            return Card(
              child: ListTile(
                title: Row(children: <Widget>[
                  Icon(choices[index].iconData),
                  SizedBox(
                    width: 10,
                  ),
                  Text(choices[index].title),
                ]),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () => goToSamplePage(context, choices[index]),
              ),
            );
          },
        ));
  }
}
