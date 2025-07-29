// OCRScreen.dart
// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'ocr_helper.dart';
import 'ocr_edit_screen.dart';

class OCRScreen extends StatefulWidget {
  final String userName;
  const OCRScreen({super.key, required this.userName});

  @override
  State<OCRScreen> createState() => _OCRScreenState();
}

class _OCRScreenState extends State<OCRScreen> {
  File? _selectedImage;
  bool _isLoading = false;
  final OCRHelper _ocrHelper = OCRHelper();

  Future<void> _pick(ImageSource src) async {
    final perm = src == ImageSource.camera
        ? await Permission.camera.request()
        : await Permission.photos.request();

    if (!perm.isGranted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('İzin verilmedi')));
      return;
    }

    final picked = await ImagePicker()
        .pickImage(source: src, imageQuality: 85, maxWidth: 1600);
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  void _showFull(File f) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(backgroundColor: Colors.black),
          body: Center(child: Image.file(f)),
        ),
      ),
    );
  }

  Future<void> _scan() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Fotoğraf seçin.')));
      return;
    }

    setState(() => _isLoading = true);

    final data = await _ocrHelper.extractTextFromImages([_selectedImage!]);

    // Fotoğrafı base64 olarak al
    final base64Photo = base64Encode(await _selectedImage!.readAsBytes());
    final filename = "IMG_${DateTime.now().millisecondsSinceEpoch}.jpg";

    debugPrint('📸 Fotoğraf dosya adı: $filename');
    debugPrint('📦 Base64 uzunluğu: ${base64Photo.length} karakter');

    setState(() => _isLoading = false);

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OCREditScreen(
          images: [_selectedImage!], // 👈 Sadece ilk foto gönderiliyor
          ocrData: data,
          userName: widget.userName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const theme = Color(0xFF0055A5);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme,
        title:
            const Text('Kartvizit Tara', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Expanded(
                      child: _selectedImage == null
                          ? const Center(child: Text('Henüz fotoğraf yok'))
                          : GestureDetector(
                              onTap: () => _showFull(_selectedImage!),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  _selectedImage!,
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () => _pick(ImageSource.gallery),
                      icon: const Icon(Icons.photo),
                      label: const Text('Galeriden Seç'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () => _pick(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Kameradan Çek'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _scan,
                      icon: const Icon(Icons.search, color: Colors.white),
                      label: const Text('Tara ve Düzenle',
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
