import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled3/services/my_api.dart';

class AccountPreferencesPage extends StatefulWidget {
  @override
  _AccountPreferencesPageState createState() => _AccountPreferencesPageState();
}

class _AccountPreferencesPageState extends State<AccountPreferencesPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  late TextEditingController _nameController;
  late TextEditingController _alamatController;
  late TextEditingController _teleponController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _alamatController = TextEditingController();
    _teleponController = TextEditingController();
    _loadUserData();
  }

  _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('name') ?? '';
      _alamatController.text = prefs.getString('alamat') ?? '';
      _teleponController.text = prefs.getString('telepon') ?? '';
    });
  }

  _updateUser() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      try {
        final formData = _formKey.currentState?.value;

        final response = await ApiService.updateUser(
          name: formData?['name'] ?? '',
          alamat: formData?['alamat'] ?? '',
          telepon: formData?['telepon'] ?? '',
        );

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('name', response['user']['name']);
        prefs.setString('alamat', response['user']['alamat']);
        prefs.setString('telepon', response['user']['telepon']);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User updated successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update user: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 255, 250),
      appBar: AppBar(
        title: Text('Preferensi Akun'),
        backgroundColor: Color.fromARGB(255, 245, 255, 250),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              FormBuilderTextField(
                name: 'name',
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: FormBuilderValidators.required(),
              ),
              SizedBox(height: 16),
              FormBuilderTextField(
                name: 'alamat',
                controller: _alamatController,
                decoration: InputDecoration(
                  labelText: 'Alamat',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: FormBuilderValidators.required(),
              ),
              SizedBox(height: 16),
              FormBuilderTextField(
                name: 'telepon',
                controller: _teleponController,
                decoration: InputDecoration(
                  labelText: 'Telepon',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: FormBuilderValidators.required(),
              ),
              SizedBox(height: 20),
               Align(
                alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: _updateUser,
                child: Text('Simpan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Background color
                  foregroundColor: Colors.white, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                  textStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ),
               )
            ],
          ),
        ),
      ),
    );
  }
}
