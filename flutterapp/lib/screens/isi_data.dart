import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:untitled3/services/my_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';

class IsiDataPage extends StatefulWidget {
  @override
  _IsiDataPageState createState() => _IsiDataPageState();
}

class _IsiDataPageState extends State<IsiDataPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  int _currentStep = 0;
  Map<int, List<dynamic>> _cripsGroupedByKriteria = {};
  bool _isDataSubmitted = false;

  @override
void initState() {
    super.initState();
    _checkIfDataSubmitted();
    _fetchCrips();
}

Future<void> _checkIfDataSubmitted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
        final response = await ApiService.checkDataSubmission();
        final isDataSubmitted = response['is_data_submitted'];
        await prefs.setBool('isDataSubmitted', isDataSubmitted);
        setState(() {
            _isDataSubmitted = isDataSubmitted;
        });
    } catch (error) {
        print('Failed to check data submission: $error');
    }
}

  Future<void> _fetchCrips() async {
    try {
      List<dynamic> crips = await ApiService.fetchCrips();
      _groupCripsByKriteria(crips);
    } catch (error) {
      print('Failed to load crips: $error');
    }
  }

  void _groupCripsByKriteria(List<dynamic> crips) {
    Map<int, List<dynamic>> groupedCrips = {};
    for (var cripsOption in crips) {
      int kriteriaId = cripsOption['kriteria_id'];
      if (groupedCrips.containsKey(kriteriaId)) {
        groupedCrips[kriteriaId]!.add(cripsOption);
      } else {
        groupedCrips[kriteriaId] = [cripsOption];
      }
    }
    setState(() {
      _cripsGroupedByKriteria = groupedCrips;
    });
  }

  Widget _buildDropdownField(
      String name, String label, List<dynamic> items, String displayProperty) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: FormBuilderDropdown(
        name: name,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        items: items.map((item) {
          return DropdownMenuItem(
            value: item['id'],
            child: Text(item[displayProperty]),
          );
        }).toList(),
      ),
    );
  }

  List<Step> _getSteps() {
    return [
      Step(
        title: Text('Isi Data'),
        content: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: _buildTextField('nama_alternatif', 'Nama Lengkap (Sesuai KTP)'),
            ),
            _buildTextField('nik', 'NIK'),
            _buildTextField('alamat', 'Alamat'),
            _buildTextField('telepon', 'Telepon'),
          ],
        ),
        isActive: _currentStep == 0,
      ),
      Step(
        title: Text('Persyaratan'),
        content: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: _buildDropdownField('jenis_pekerjaan', 'Jenis Pekerjaan', _cripsGroupedByKriteria[1] ?? [], 'nama_crips'),
            ),
            _buildDropdownField('kondisi_rumah', 'Kondisi Rumah', _cripsGroupedByKriteria[2] ?? [], 'nama_crips'),
            _buildDropdownField('penghasilan', 'Penghasilan', _cripsGroupedByKriteria[3] ?? [], 'nama_crips'),
            _buildDropdownField('status_kepemilikan_rumah', 'Status Kepemilikan Rumah', _cripsGroupedByKriteria[4] ?? [], 'nama_crips'),
            _buildDropdownField('tanggungan', 'Tanggungan', _cripsGroupedByKriteria[5] ?? [], 'nama_crips'),
          ],
        ),
        isActive: _currentStep == 1,
      ),
      Step(
        title: Text('Konfirmasi'),
        content: Column(
          children: [
            Text('Pastikan semua data sudah benar sebelum menyimpan.'),
          ],
        ),
        isActive: _currentStep == 2,
      ),
    ];
  }

  void _continue() async {
    if (_currentStep < _getSteps().length - 1) {
      setState(() {
        _currentStep += 1;
      });
    } else {
      if (_formKey.currentState!.saveAndValidate()) {
        final formData = _formKey.currentState!.value;

        print('Form Data: $formData');

        final String? nama_alternatif = formData['nama_alternatif'];
        final String? nik = formData['nik'];
        final String? alamat = formData['alamat'];
        final String? telepon = formData['telepon'];

        if (nama_alternatif == null || nik == null || alamat == null || telepon == null) {
          print('One or more required fields are null');
          return;
        }

        try {
          final alternatifResponse = await ApiService.storeAlternatif(
            nama_alternatif: nama_alternatif,
            nik: nik,
            alamat: alamat,
            telepon: telepon,
          );

          Map<String, dynamic> penilaianData = {
            'crips_id': {
              'jenis_pekerjaan': formData['jenis_pekerjaan'],
              'kondisi_rumah': formData['kondisi_rumah'],
              'penghasilan': formData['penghasilan'],
              'status_kepemilikan_rumah': formData['status_kepemilikan_rumah'],
              'tanggungan': formData['tanggungan'],
            },
            'alternatif_id': alternatifResponse['id'],
          };
          final penilaianResponse = await ApiService.storePenilaian(penilaianData);

          print('Alternatif saved successfully: $alternatifResponse');
          print('Penilaian saved successfully: $penilaianResponse');

          // Set status data submitted
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isDataSubmitted', true);
          setState(() {
            _isDataSubmitted = true;
          });

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data berhasil disimpan')),
          );

          // Optionally, you can reset the form or navigate to another page here
          // For example, to reset the form:
          _formKey.currentState?.reset();
          
          // If you want to pop the current page:
          // Navigator.of(context).pop();
          
        } catch (error) {
          print('Failed to save data: $error');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save data')),
          );
        }
      } else {
        print('Form validation failed');
      }
    }
  }

  void _cancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }

  Widget _buildTextField(String name, String label, {ValueChanged<String?>? onChanged}) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: FormBuilderTextField(
        name: name,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          filled: true,
          fillColor: Colors.white,
        ),
        onChanged: onChanged,
      ),
    );
  }

@override
Widget build(BuildContext context) {
  if (_isDataSubmitted) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 255, 250),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 150, // Adjust the width as needed
              height: 150, // Adjust the height as needed
              child: Lottie.asset('assets/animation/datasent.json'),
            ),
            SizedBox(height: 20), // Add some spacing between the animation and the text
            Text(
              'Data berhasil dikirim!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Customize the text style as needed
            ),
          ],
        ),
      ),
    );
  }

  // Rest of the form code
  return Scaffold(
    backgroundColor: Color.fromARGB(255, 245, 255, 250),
    appBar: AppBar(
      title: Text('Formulir Pengisian Data'),
      automaticallyImplyLeading: false,
    ),
    body: FormBuilder(
      key: _formKey,
      child: Stepper(
        steps: _getSteps(),
        currentStep: _currentStep,
        onStepContinue: _continue,
        onStepCancel: _cancel,
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              children: <Widget>[
                ElevatedButton(
                  onPressed: details.onStepContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Button background color
                    foregroundColor: Colors.white, // Button text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    textStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  child: Text('Selanjutnya'),
                ),
                SizedBox(width: 8),
                TextButton(
                  onPressed: details.onStepCancel,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red, // Button text color
                    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    textStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  child: Text('Batal'),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}
}