// import 'package:dispora_mobile/main.dart';
// import 'package:dispora_mobile/view/berita.dart';
// import 'package:dispora_mobile/view/register.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/regScreen.dart';
// import 'package:http/http.dart' as http;
// import 'dart:async';
// import 'dart:convert';

// Future<void> loginUser(User user) async {
//   final String apiUrl = 'https://diasporacirebonkab.online/api/login';
//   final response = await http.post(
//     Uri.parse(apiUrl),
//     headers: <String, String>{
//       'Content-Type': 'application/json',
//     },
//     body: jsonEncode(user.toJson()), // Mengonversi objek User ke JSON
//   );

//   if (response.statusCode == 200) {
//     // Berhasil login, lakukan sesuatu seperti navigasi ke beranda
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => Beranda()),
//     );
//   } else {
//     // Gagal login, tampilkan pesan kesalahan atau lakukan tindakan yang sesuai
//     final Map<String, dynamic> responseData = jsonDecode(response.body);
//     final String errorMessage = responseData['message'];
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(errorMessage),
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }
// }

class User {
  final String username;
  final String password;

  User({required this.username, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool JSvall = false;
  @override
  Widget build(BuildContext context) {
    final mediaQueryHeigh = MediaQuery.of(context).size.height;
    final myAppBar = AppBar(
      title: Text('MediaQueri'),
    );
    final bodyHeight = mediaQueryHeigh - myAppBar.preferredSize.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            CustomPaint(
              size: Size(
                  MediaQuery.of(context).size.width,
                  (MediaQuery.of(context).size.width * 1.3930232558139535)
                      .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
              painter: RPSCustomPainter(),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    // color: Colors.amberAccent,
                    margin: EdgeInsets.only(top: 150),
                    child: Text(
                      'Login',
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(

                        // color: Colors.amberAccent,
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          'Username',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    height: bodyHeight * 0.08,
                    child: TextFormField(
                      autofocus: true,
                      decoration: InputDecoration(
                          hintText: "Username", border: OutlineInputBorder()),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          'Password',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    height: bodyHeight * 0.08,
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      autofocus: true,
                      obscureText: !JSvall,
                      decoration: InputDecoration(
                          hintText: 'Password',
                          border:
                              OutlineInputBorder(gapPadding: double.infinity)),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    width: MediaQuery.of(context).size.width,
                    height: bodyHeight * 0.07,

                    // alignment: Alignment.topLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: JSvall,
                              onChanged: (value) {
                                setState(() {
                                  JSvall = value!;
                                });
                              },
                            ),
                            Text('Show Password')
                          ],
                        ),
                        TextButton(
                            onPressed: () {}, child: Text('Forgot Password'))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextButton(
                      onPressed: () {},
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 25),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: bodyHeight * 0.08,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromARGB(255, 84, 41, 255)),
                        child: Text(
                          'Login',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      )),
                  // SizedBox(
                  //   height: ,
                  // ),
                  TextButton(
                      onPressed: () {},
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 25),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: bodyHeight * 0.08,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: Color.fromARGB(255, 208, 213, 221)),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: Container(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/image/google.png'))),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Login With Google',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                          ],
                        )),
                      )),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    // color: Colors.amberAccent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const RegScreen()));
                            },
                            child: Text('Register'))
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 1.295349, size.height * 0.07588331);
    path_0.cubicTo(
        size.width * 1.295349,
        size.height * 0.3344808,
        size.width * 0.9112256,
        size.height * 0.5454090,
        size.width * 0.5492628,
        size.height * 0.5454090);
    path_0.cubicTo(
        size.width * 0.1872991,
        size.height * 0.5454090,
        size.width * -0.2147921,
        size.height * 1.197987,
        size.width * -0.2147921,
        size.height * 0.9393890);
    path_0.cubicTo(
        size.width * -0.2147921,
        size.height * 0.6807930,
        size.width * -0.2567605,
        size.height * -0.1087317,
        size.width * 0.1052040,
        size.height * -0.1087317);
    path_0.cubicTo(
        size.width * 0.4671674,
        size.height * -0.1087317,
        size.width * 1.295349,
        size.height * -0.1827145,
        size.width * 1.295349,
        size.height * 0.07588331);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xffCBCCE8).withOpacity(0.6);
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
