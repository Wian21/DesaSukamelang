import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import '../services/my_api.dart';
import '../widgets/circle_button.dart'; // Pastikan Anda mengimpor CircleButton

class FeaturedScreen extends StatefulWidget {
  const FeaturedScreen({Key? key}) : super(key: key);

  @override
  _FeaturedScreenState createState() => _FeaturedScreenState();
}

class _FeaturedScreenState extends State<FeaturedScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 245, 255, 250),
        body: Column(
          children: const [
            CustomAppBar(),
            Expanded(
              child: Body(),
            ),
          ],
        ),
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  Future<String> getUsername() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? token = sharedPreferences.getString('token');

    final response = await http.get(
      Uri.parse('${ApiService.baseUrl}/api/user'),
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
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Informasi Bantuan",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          // const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFEFAE0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: const Offset(0, 2),
                  blurRadius: 6.0,
                ),
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Center(
                child: Lottie.asset('assets/animation/lamp.json', width: 200, height: 200),
              ),
                const SizedBox(height: 20),
                Text(
        "1. Isi data terlebih dahulu, dengan baik dan benar",
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontFamily: 'Manrope'),
      ),
      const SizedBox(height: 10),
      Text(
        "2. Data yang terkirim akan diproses secepatnya",
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontFamily: 'Manrope'),
      ),
      const SizedBox(height: 10),
      Text(
        "3. Hasil pengumuman akan diberikan oleh RT setempat",
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontFamily: 'Manrope'),
      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  Future<String> getUsername() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? token = sharedPreferences.getString('token');

    final response = await http.get(
      Uri.parse('${ApiService.baseUrl}/api/user'),
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
    return Container(
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
                    return Text(
                      "Selamat Datang,\n${snapshot.data} !",
                      style: Theme.of(context).textTheme.titleLarge,
                    );
                  } else if (snapshot.hasError) {
                    return const Text('Failed to load username');
                  }
                  return const CircularProgressIndicator();
                },
              ),
              CircleButton(
                icon: Icons.notifications,
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
