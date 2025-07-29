// ignore_for_file: avoid_print, unused_element, use_build_context_synchronously

import 'dart:convert'; // BASE64 için gerekli
import 'dart:io'; // File için gerekli
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../canias_service.dart';
import '../crm_screen.dart'; // CRM ekranına yönlendirme için gerekli

class OCREditScreen extends StatefulWidget {
  final List<File> images;
  final Map<String, String> ocrData;
  final String userName;

  const OCREditScreen({
    super.key,
    required this.images,
    required this.ocrData,
    required this.userName,
  });

  @override
  State<OCREditScreen> createState() => _OCREditScreenState();
}

class _OCREditScreenState extends State<OCREditScreen> {
  late TextEditingController _name;
  late TextEditingController _mail;
  late TextEditingController _userMail;
  late TextEditingController _position;
  late TextEditingController _tel1;
  late TextEditingController _tel2;
  late TextEditingController _company;
  late TextEditingController _sites;
  late TextEditingController _address;
  late TextEditingController _typeAction;
  late TextEditingController _typeMaterial;
  late TextEditingController _notes;

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.ocrData['name'] ?? '');
    _mail = TextEditingController(text: widget.ocrData['email'] ?? '');
    _userMail = TextEditingController();
    _position = TextEditingController(text: widget.ocrData['department'] ?? '');
    _tel1 = TextEditingController(text: widget.ocrData['phone'] ?? '');
    _tel2 = TextEditingController();
    _company = TextEditingController(text: widget.ocrData['firma'] ?? '');
    _sites = TextEditingController();
    _address = TextEditingController();
    _typeAction = TextEditingController();
    _typeMaterial = TextEditingController();
    _notes = TextEditingController();
  }

  String _generate32CharId() {
    return const Uuid().v4().replaceAll('-', '');
  }

  Future<void> _insertAndReturn() async {
    setState(() => _loading = true);

    final generatedId = _generate32CharId();

    final firstImage = widget.images[0];
    final bytes = await firstImage.readAsBytes();
    final photoBase64String = base64Encode(bytes);
    final fileName = 'IMG_${DateTime.now().millisecondsSinceEpoch}.jpg';

    setState(() => _loading = true);

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
      photoBase64: photoBase64String,
      createName: widget.userName,
      fileName: fileName,
    );

    setState(() => _loading = false);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Kayıt başarılı!')),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => CrmScreen(userName: widget.userName),
        ),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kayıt başarılı!')),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => CrmScreen(userName: widget.userName),
        ),
        (route) => false,
      );
    }
  }

  void _showFullScreen(File img) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(backgroundColor: Colors.black),
          body: Center(child: Image.file(img)),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController c, String label) {
    return TextField(
      controller: c,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const themeColor = Color(0xFF0055A5);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        title: const Text('Bilgileri Düzenle',
            style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    SizedBox(
                      height: 140,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.images.length,
                        itemBuilder: (ctx, i) {
                          return GestureDetector(
                            onTap: () => _showFullScreen(widget.images[i]),
                            child: Container(
                              margin: const EdgeInsets.only(right: 12),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  widget.images[i],
                                  width: 140,
                                  height: 140,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildField(_name, 'NAME'),
                    const SizedBox(height: 12),
                    _buildField(_mail, 'MAIL'),
                    const SizedBox(height: 12),
                    _buildField(_userMail, 'USERMAIL'),
                    const SizedBox(height: 12),
                    _buildField(_position, 'POSITION'),
                    const SizedBox(height: 12),
                    _buildField(_tel1, 'TELEPHONE'),
                    const SizedBox(height: 12),
                    _buildField(_tel2, 'TELEPHONE2'),
                    const SizedBox(height: 12),
                    _buildField(_company, 'COMPANY'),
                    const SizedBox(height: 12),
                    _buildField(_sites, 'SITES'),
                    const SizedBox(height: 12),
                    _buildField(_address, 'ADDRESS'),
                    const SizedBox(height: 12),
                    _buildField(_typeAction, 'TYPEACTION'),
                    const SizedBox(height: 12),
                    _buildField(_typeMaterial, 'TYPEMATERIAL'),
                    const SizedBox(height: 12),
                    _buildField(_notes, 'NOTES'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _insertAndReturn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Kaydet ve Geri Dön'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
