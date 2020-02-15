import 'dart:convert';

import 'package:openapi/api.dart' hide Type;
import 'package:openapi/api.dart' as OA;

String sampleJSONEncoding(samples) {
  return jsonEncode(samples, toEncodable: (Object object) {
    if (object is OA.Type) {
      return object.value;
    } else if (object is Sample) {
      return object.toJson();
    }
    throw Exception(
        "Object was not json convertible, Object: " + object.toString());
  });
}
