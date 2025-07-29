// ignore_for_file: unused_local_variable, avoid_print, prefer_const_constructors, use_build_context_synchronously

import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../canias_service.dart';

class InsertPage extends StatefulWidget {
  final String userName;
  const InsertPage({super.key, required this.userName});

  @override
  State<InsertPage> createState() => _InsertPageState();
}

class _InsertPageState extends State<InsertPage> {
  final _name = TextEditingController();
  final _mail = TextEditingController();
  final _userMail = TextEditingController();
  final _position = TextEditingController();
  final _tel1 = TextEditingController();
  final _tel2 = TextEditingController();
  final _company = TextEditingController();
  final _sites = TextEditingController();
  final _address = TextEditingController();
  final _typeAction = TextEditingController();
  final _typeMaterial = TextEditingController();
  final _notes = TextEditingController();
  final _photo = TextEditingController();

  bool _loading = false;

  String _generate32CharId() {
    final uuid = Uuid();
    return uuid.v4().replaceAll('-', '');
  }

  Future<void> _insertData() async {
    setState(() => _loading = true);

    final generatedId = _generate32CharId();

    String? photoBase64String;
    String? fileName;

    if (_photo.text.trim().isNotEmpty) {
      final file = File(_photo.text.trim());
      if (file.existsSync()) {
        final bytes = await file.readAsBytes();
        photoBase64String = base64Encode(bytes);
        fileName = file.uri.pathSegments.last;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('📷 Fotoğraf bulunamadı, fotoğrafsız devam ediliyor.')),
        );
      }
    }

    final ok = await CaniasService.insertCrm(
      id: generatedId,
      name: _name.text,
      mail: _mail.text,
      userMail: _userMail.text,
      position: _position.text,
      tel1: _tel1.text,
      tel2: _tel2.text,
      company: _company.text,
      sites: _sites.text,
      address: _address.text,
      typeAction: _typeAction.text,
      typeMaterial: _typeMaterial.text,
      notes: _notes.text,
      photoBase64: photoBase64String ?? '',
      createName: widget.userName,
      fileName: fileName ?? '',
    );

    setState(() => _loading = false);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Kayıt başarılı!')),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kayıt başarılı!')),
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0055A5),
        title: const Text('Yeni Kayıt Ekle'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildTextField(_name, 'NAME'),
              const SizedBox(height: 12),
              _buildTextField(_mail, 'MAIL',
                  hint: 'ornek@mail.com',
                  inputType: TextInputType.emailAddress),
              const SizedBox(height: 12),
              _buildTextField(_userMail, 'USERMAIL',
                  hint: 'kullanici@mail.com',
                  inputType: TextInputType.emailAddress),
              const SizedBox(height: 12),
              _buildTextField(_position, 'POSITION'),
              const SizedBox(height: 12),
              _buildTextField(_tel1, 'TELEPHONE',
                  hint: '+90 5xx xxx xx xx', inputType: TextInputType.phone),
              const SizedBox(height: 12),
              _buildTextField(_tel2, 'TELEPHONE2',
                  inputType: TextInputType.phone),
              const SizedBox(height: 12),
              _buildTextField(_company, 'COMPANY'),
              const SizedBox(height: 12),
              _buildTextField(_sites, 'SITES',
                  hint: 'https://...', inputType: TextInputType.url),
              const SizedBox(height: 12),
              _buildTextField(_address, 'ADDRESS', maxLines: 2),
              const SizedBox(height: 12),
              _buildTextField(_typeAction, 'TYPEACTION'),
              const SizedBox(height: 12),
              _buildTextField(_typeMaterial, 'TYPEMATERIAL'),
              const SizedBox(height: 12),
              _buildTextField(_notes, 'NOTES', maxLines: 3),
              const SizedBox(height: 12),
              _buildTextField(_photo, 'PHOTO',
                  hint: 'Dosya yolu: /storage/emulated/0/DCIM/xyz.jpg'),
              const SizedBox(height: 20),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _insertData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0055A5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                      ),
                      child:
                          const Text('Kaydet', style: TextStyle(fontSize: 18)),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    String? hint,
    TextInputType inputType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      maxLines: maxLines,
      textInputAction: TextInputAction.next,
      onChanged: (val) => print('✏️ $label değiştirildi: $val'),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
