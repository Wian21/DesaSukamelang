import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:untitled3/screens/preferensi_akun.dart';
import 'package:untitled3/services/my_api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled3/loginScreen.dart';

class ProfileScreen extends StatelessWidget {
Future<void> _logout(BuildContext context) async {
  final api = ApiService();
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  var token = localStorage.getString('token');

  if (token != null) {
    print('Logout with token: $token');

    final response = await api.postData('logout', token);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print('Logout response: $data');

      await localStorage.remove('token');
      await localStorage.remove('isDataSubmitted'); // Remove the isDataSubmitted flag

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const LoginScreen()),
      );
    } else {
      print('Logout failed with status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } else {
    print('No token found');
  }
}

  Future<String> getUsername() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? token = sharedPreferences.getString('token');

    final response = await http.get(
      Uri.parse('${ApiService.baseUrl}/api/user'), // Use baseUrl from ApiService
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonRes = json.decode(response.body);
      return jsonRes['user']['name'];
    } else {
      print('Failed with status: ${response.statusCode}');
      print('Failed with body: ${response.body}');
      throw Exception('Failed to load username');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
            height: 130,
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.1, 0.5],
                colors: [
                  Color(0xff886ff2),
                  Color(0xff6849ef),
                ],
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<String>(
                      future: getUsername(),
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        if (snapshot.hasData) {
                          return Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.black,
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                "${snapshot.data}",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Text('Failed to load username');
                        }
                        return CircularProgressIndicator();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Pengaturan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
           ListTile(
            leading: Icon(Icons.person),
            title: Text('Preferensi Akun'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountPreferencesPage()),
              );
            },
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () => _logout(context),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 245, 255, 250),
    );
  }
}
