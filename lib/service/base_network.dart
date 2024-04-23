import 'dart:convert';
import 'package:http/http.dart' as http;

class BaseNetwork {
  static const String baseUrl = "https://reqres.in/api";

  static Future<Map<String, dynamic>> get(String partUrl) async {
    final String fullUrl = "$baseUrl/$partUrl";
    final response = await http.get(Uri.parse(fullUrl));

    return _processResponse(response);
  }

  static Future<Map<String, dynamic>> _processResponse(
      http.Response response) async {
    final body = response.body;

    if (body.isNotEmpty) {
      final jsonBody = json.decode(body);
      return jsonBody;
    } else {
      print("processResponse error");
      return {"error": true};
    }
  }
}
