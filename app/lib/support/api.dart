import 'dart:convert';
import 'package:http/http.dart' as http;

class API {
  static String apiUrl = 'http://127.0.0.1:8000/';

  dynamic get(String path) async {
    final url = apiUrl + path;
    final response = await http.get(Uri.parse(url));
    bool isSuccess = response.statusCode == 200;
    return {"status": isSuccess, "data": json.decode(response.body)};
  }

  dynamic post(String path, Map<String, dynamic> data) async {
    final url = apiUrl + path;
    final headers = {
      'Content-Type': 'application/json',
    };
    final response = await http.post(Uri.parse(url),
        body: jsonEncode(data), headers: headers);
    bool isSuccess = response.statusCode == 201;
    return {"status": isSuccess, "data": json.decode(response.body)};
  }

  dynamic put(String path, Map<String, dynamic> data) async {
    final url = apiUrl + path;
    final headers = {
      'Content-Type': 'application/json',
    };
    final response = await http.put(Uri.parse(url),
        body: jsonEncode(data), headers: headers);
    bool isSuccess = response.statusCode == 200;
    return {"status": isSuccess, "data": json.decode(response.body)};
  }

  dynamic delete(String path) async {
    final url = apiUrl + path;
    final response = await http.delete(Uri.parse(url));
    bool isSuccess = response.statusCode == 204;
    return {"status": isSuccess};
  }
}
