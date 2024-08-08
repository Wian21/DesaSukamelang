import 'package:flutter/material.dart';
import './login.dart';
// import 'beranda.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String? selectedValue;
  CarkMerk? selectedValueDua;
  List<CarkMerk?> cars = [
    CarkMerk(id: 1, name: 'Laki-Lki'),
    CarkMerk(id: 2, name: 'Perempuan')
  ];

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
                children: [
                  Container(
                    // color: Colors.amberAccent,
                    margin: EdgeInsets.only(top: 150),
                    child: Text(
                      'Register',
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
                    // height: bodyHeight * 0.08,
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
                    // height: bodyHeight * 0.08,
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      autofocus: true,
                      // obscureText: !JSvall,
                      decoration: InputDecoration(
                          hintText: 'Password',
                          border:
                              OutlineInputBorder(gapPadding: double.infinity)),
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
                          'NIK',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    // height: bodyHeight * 0.08,
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      autofocus: true,
                      // obscureText: !JSvall,
                      decoration: InputDecoration(
                          hintText: 'Enter your NIK',
                          border:
                              OutlineInputBorder(gapPadding: double.infinity)),
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
                          'Alamat',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    height: bodyHeight * 0.5 / 3.2,
                    child: TextFormField(
                      maxLines: 4,
                      textAlign: TextAlign.start,
                      autofocus: true,
                      decoration: InputDecoration(
                          hintText: 'Enter your alamat',
                          border: OutlineInputBorder(
                              // gapPadding: double.infinitys
                              )),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    width: MediaQuery.of(context).size.width,
                    height: bodyHeight * 0.07,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(5)),
                    child: DropdownButton<String?>(
                        underline: SizedBox(),
                        isExpanded: true,
                        elevation: 10,
                        borderRadius: BorderRadius.circular(15),
                        hint: Text("Pilih Nama Pendidikan"),
                        value: selectedValue,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value;
                          });
                        },
                        items: [
                          "SD",
                          "SMP",
                          "SMK",
                          "S1",
                          "S2",
                          "S3",
                        ]
                            .map<DropdownMenuItem<String?>>(
                                (e) => DropdownMenuItem(
                                      child: Text(e.toString()),
                                      value: e,
                                    ))
                            .toList()),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: bodyHeight * 0.07,
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(5)),
                    child: DropdownButton<CarkMerk?>(
                      value: selectedValueDua,
                      onChanged: (value) {
                        setState(() {
                          selectedValueDua = value;
                        });
                      },
                      hint: Text('Pilih Jenis Kelamin'),
                      underline: SizedBox(),
                      isExpanded: true,
                      items: cars
                          .map<DropdownMenuItem<CarkMerk>>(
                              (e) => DropdownMenuItem(
                                    child: Text((e?.name ?? "").toString()),
                                    value: e,
                                  ))
                          .toList(),
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

class CarkMerk {
  int? id;
  String? name;

  CarkMerk({this.id, this.name});
}
