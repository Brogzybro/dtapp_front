import 'package:dtapp_flutter/pages/sample_page.dart';
import 'package:dtapp_flutter/samples/sample_main_views/distance_main_view.dart';
import 'package:dtapp_flutter/samples/samples_type_choices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dtapp_flutter/main.dart';
import 'package:openapi/api.dart' as OA;

void main() {
  testWidgets('MyWidget has a title and message', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(DistanceMainView("test123"));
  });
}
