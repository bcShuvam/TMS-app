import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class TMSResponse {
  final int statusCode;
  final String body;

  TMSResponse({
    required this.statusCode,
    required this.body,
  });
}

class TMSServices {
  static Map<String, String> header = {
    'Content-Type': 'application/json',
  };

  static String localURL = dotenv.env['LOCAL_API'].toString();
  static String remoteURL = dotenv.env['REMOTE_API'].toString();
  static bool isServer = false;
  static String apiURL = isServer ? remoteURL : localURL;

  // Store the JWT token
  static String? authToken;

  /// Helper to get headers including Authorization if token is available
  static Map<String, String> getHeaders() {
    final Map<String, String> headers = Map.from(header);
    if (authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
    }
    return headers;
  }

  static Future<TMSResponse> getRequest(String path) async {
    print('$apiURL$path');
    try {
      final response = await http.get(
        Uri.parse('$apiURL$path'),
        headers: getHeaders(),
      );

      return TMSResponse(statusCode: response.statusCode, body: response.body);
    } catch (err) {
      return TMSResponse(statusCode: 500, body: err.toString());
    }
  }

  static Future<TMSResponse> postRequest(String path, Map<String, dynamic> body, {bool isLogin = false}) async {
    try {
      print('$apiURL$path');
      final response = await http.post(
        Uri.parse('$apiURL$path'),
        headers: getHeaders(),
        body: jsonEncode(body),
      );

      if (isLogin && response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData.containsKey('token')) {
          authToken = responseData['token'];
          print("JWT token stored: $authToken");
        }
      }

      return TMSResponse(statusCode: response.statusCode, body: response.body);
    } catch (err) {
      return TMSResponse(statusCode: 500, body: err.toString());
    }
  }

  static Future<TMSResponse> putRequest(String path, Map<String, dynamic> body) async {
    print('$apiURL$path');
    try {
      final response = await http.put(
        Uri.parse('$apiURL$path'),
        headers: getHeaders(),
        body: jsonEncode(body),
      );

      return TMSResponse(statusCode: response.statusCode, body: response.body);
    } catch (err) {
      return TMSResponse(statusCode: 500, body: err.toString());
    }
  }

  static Future<TMSResponse> deleteRequest(String path) async {
    print('$apiURL$path');
    try {
      final response = await http.delete(
        Uri.parse('$apiURL$path'),
        headers: getHeaders(),
      );

      return TMSResponse(statusCode: response.statusCode, body: response.body);
    } catch (err) {
      return TMSResponse(statusCode: 500, body: err.toString());
    }
  }

  /// Clears the token (e.g., on logout)
  static void logout() {
    authToken = null;
    print("JWT token cleared.");
  }
}