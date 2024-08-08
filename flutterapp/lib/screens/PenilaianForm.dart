import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PenilaianForm extends StatefulWidget {
  @override
  _PenilaianFormState createState() => _PenilaianFormState();
}

class _PenilaianFormState extends State<PenilaianForm> {
  List<dynamic> _alternatif = [];
  List<dynamic> _crips = [];
  String? _selectedAlternatif;
  Map<String, List<String>> _selectedCrips = {};

  @override
  void initState() {
    super.initState();
    _fetchAlternatif();
    _fetchCrips();
  }

  Future<void> _fetchAlternatif() async {
    final response =
        await http.get(Uri.parse('http://192.168.45.73:8000/api/alternatif'));
    if (response.statusCode == 200 && mounted) {
      setState(() {
        _alternatif = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load alternatif');
    }
  }

  Future<void> _fetchCrips() async {
    final response =
        await http.get(Uri.parse('http://192.168.45.73:8000/api/crips'));
    if (response.statusCode == 200 && mounted) {
      setState(() {
        _crips = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load crips');
    }
  }

  void _submitForm() async {
    final response = await http.post(
      Uri.parse('http://192.168.45.73:8000/api/penilaian'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'crips_id': _selectedCrips,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Data saved successfully')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to save data')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Isi Data'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              hint: Text('Select Alternatif'),
              value: _selectedAlternatif,
              items: _alternatif.map((item) {
                return DropdownMenuItem<String>(
                  value: item['id'].toString(),
                  child: Text(item['name'] ?? 'Unknown Name'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedAlternatif = value;
                  _selectedCrips[_selectedAlternatif!] = [];
                });
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _alternatif.length,
                itemBuilder: (context, index) {
                  if (_selectedAlternatif ==
                      _alternatif[index]['id'].toString()) {
                    return Column(
                      children: _crips.map((crip) {
                        return CheckboxListTile(
                          title: Text(crip['name'] ?? 'Unknown Crip Name'),
                          value: _selectedCrips[_selectedAlternatif!]
                                  ?.contains(crip['id'].toString()) ??
                              false,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                _selectedCrips[_selectedAlternatif!]!
                                    .add(crip['id'].toString());
                              } else {
                                _selectedCrips[_selectedAlternatif!]!
                                    .remove(crip['id'].toString());
                              }
                            });
                          },
                        );
                      }).toList(),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
