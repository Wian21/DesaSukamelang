import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.4.239:8000';

  static Future<Map<String, dynamic>> storeAlternatif({
    required String nama_alternatif,
    required String nik,
    required String alamat,
    required String telepon,
  }) async {
    final String apiUrl = '$baseUrl/api/alternatif';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'nama_alternatif': nama_alternatif,
        'nik': nik,
        'alamat': alamat,
        'telepon': telepon,
      }),
    );

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else if (response.statusCode == 302) {
        throw Exception('Redirection: ${response.headers['location']}');
    } else {
      throw Exception('Failed to store alternatif data');
    }
  }

  static Future<Map<String, dynamic>> storePenilaian(Map<String, dynamic> penilaianData) async {
    final String apiUrl = '$baseUrl/api/penilaian';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(penilaianData),
    );

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to store penilaian data');
    }
  }

    static Future<Map<String, dynamic>> checkDataSubmission() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/check-data-submission'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to check data submission');
    }
  }

  static Future<List<dynamic>> fetchCrips() async {
    final String apiUrl = '$baseUrl/api/crips';
    final response = await http.get(Uri.parse(apiUrl));

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load crips');
    }
  }

  Future<Map<String, dynamic>> getUser() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');

    if (token != null) {
      final response = await http.get(
        Uri.parse('$baseUrl/user'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed with status: ${response.statusCode}');
        print('Failed with body: ${response.body}');
        throw Exception('Failed to load user');
      }
    } else {
      throw Exception('No token found');
    }
  }

  // Register a new user
  static Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
    required String alamat,
    required String telepon,
  }) async {
    final String apiUrl = '$baseUrl/api/auth/register';
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'name': name,
        'email': email,
        'password': password,
        'alamat': alamat,
        'telepon': telepon,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to register user');
    }
  }

  // Log in a user
  static Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    final String apiUrl = '$baseUrl/api/auth/login';
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to log in');
    }
  }
  Future<http.Response> postData(String apiUrl, String token) async {
    var fullUrl = '$baseUrl/api/$apiUrl';
    return await http.post(
      Uri.parse(fullUrl),
      headers: {'Authorization': 'Bearer $token'},
    );
  }
  
}
