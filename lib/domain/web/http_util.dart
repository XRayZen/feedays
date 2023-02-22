import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

Future<String> getHttpString(String url) async {
  final target = Uri.parse(url);
  final response = await http.get(target);
  if (response.statusCode != 200) {
    throw Exception('ERROR: ${response.statusCode}');
  }
  return response.body;
}

Future<ByteData> getHttpByteData(String url) async {
  final target = Uri.parse(url);
  final response = await http.get(target);
  if (response.statusCode != 200) {
    throw Exception('ERROR: ${response.statusCode}');
  }
  return response.bodyBytes.buffer.asByteData();
}
