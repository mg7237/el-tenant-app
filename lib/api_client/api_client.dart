import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static ApiClient _instance;
  static const BASE_URL = "http://healthconnect.company/HCE_MOBILE/HealthConnect/index.php/";
  static const FILE_URL = "http://healthconnect.company/HCE_MOBILE/HealthConnect/";
  static final DEVICE_TYPE = Platform.operatingSystem;

  factory ApiClient() => _instance ??= new ApiClient._();

  ApiClient._();

  Future<Map<String, dynamic>> getMethod(String url) async {
    var response = await http.get(url);
    print(response.body);
    return json.decode(response.body.toString());
  }

  Future<http.Response> postMethod(
      String method, Map<String, String> body) async {
    print(body);
    var response = await http.post(BASE_URL + method, body: body);
    return response;
  }

  Future<http.Response> postMethodMultipart(var request) async {
    http.Response response =
        await http.Response.fromStream(await request.send());
    print(response.body);
    return response;
  }
}
