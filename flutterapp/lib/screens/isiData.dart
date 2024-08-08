import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:untitled3/services/my_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class IsiDataPage extends StatefulWidget {
  @override
  _IsiDataPageState createState() => _IsiDataPageState();
}

class _IsiDataPageState extends State<IsiDataPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  int _currentStep = 0;
  Map<int, List<dynamic>> _cripsGroupedByKriteria = {};

  @override
  void initState() {
    super.initState();
    _fetchCrips();
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
              child: 
            _buildTextField('nama_alternatif', 'Nama Lengkap (Sesuai KTP)'),),
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
              child: 
            _buildDropdownField('penghasilan', 'Penghasilan', _cripsGroupedByKriteria[3] ?? [], 'nama_crips'),),
            _buildDropdownField('tanggungan', 'Tanggungan', _cripsGroupedByKriteria[5] ?? [], 'nama_crips'),
            _buildDropdownField('kondisi_rumah', 'Kondisi Rumah', _cripsGroupedByKriteria[2] ?? [], 'nama_crips'),
            _buildDropdownField('jenis_pekerjaan', 'Jenis Pekerjaan', _cripsGroupedByKriteria[1] ?? [], 'nama_crips'),
            _buildDropdownField('status_kepemilikan_rumah', 'Status Kepemilikan Rumah', _cripsGroupedByKriteria[4] ?? [], 'nama_crips'),
          ],
        ),
        isActive: _currentStep == 1,
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
      
      // Debugging print statements
      print('Form Data: $formData');

      final String? namaAlternatif = formData['nama_alternatif'];
      final String? nik = formData['nik'];
      final String? alamat = formData['alamat'];
      final String? telepon = formData['telepon'];

      // Validate that all required fields are not null
      if (namaAlternatif == null || nik == null || alamat == null || telepon == null) {
        print('One or more required fields are null');
        return;
      }

      // Step 1: Store Alternatif Data
      try {
        final alternatifResponse = await ApiService.storeAlternatif(
          namaAlternatif: namaAlternatif,
          nik: nik,
          alamat: alamat,
          telepon: telepon,
        );

        // Step 2: Store Penilaian Data with the response from Alternatif
        Map<String, dynamic> penilaianData = {
          'crips_id': {
            'penghasilan': formData['penghasilan'],
            'tanggungan': formData['tanggungan'],
            'kondisi_rumah': formData['kondisi_rumah'],
            'jenis_pekerjaan': formData['jenis_pekerjaan'],
            'status_kepemilikan_rumah': formData['status_kepemilikan_rumah'],
          },
          'alternatif_id': alternatifResponse['id'],  // Assuming the response contains the new alternatif's ID
        };
        final penilaianResponse = await ApiService.storePenilaian(penilaianData);

        print('Alternatif saved successfully: $alternatifResponse');
        print('Penilaian saved successfully: $penilaianResponse');
      } catch (error) {
        print('Failed to save data: $error');
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
      print("Moved back to step: $_currentStep");  // Debug print
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Isi Data'),
      ),
      body: FormBuilder(
        key: _formKey,
        child: Stepper(
          steps: _getSteps(),
          currentStep: _currentStep,
          onStepContinue: _continue,
          onStepCancel: _cancel,
        ),
      ),
    );
  }
}