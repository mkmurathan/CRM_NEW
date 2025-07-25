// ignore_for_file: deprecated_member_use

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
  final List<File> _images = [];
  bool _isLoading = false;
  final OCRHelper _ocrHelper = OCRHelper();

  Future<void> _pick(ImageSource src) async {
    if (_images.length >= 2) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('En fazla iki fotoğraf.')));
      return;
    }

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
      setState(() => _images.add(File(picked.path)));
    }
  }

  void _remove(int i) {
    setState(() => _images.removeAt(i));
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
    if (_images.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Fotoğraf seçin.')));
      return;
    }
    setState(() => _isLoading = true);
    final data = await _ocrHelper.extractTextFromImages(_images);
    setState(() => _isLoading = false);

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OCREditScreen(
          images: _images,
          ocrData: data,
          userName: widget.userName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = const Color(0xFF0055A5);
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
                      child: _images.isEmpty
                          ? const Center(child: Text('Henüz fotoğraf yok'))
                          : ListView.builder(
                              itemCount: _images.length,
                              itemBuilder: (ctx, i) {
                                final img = _images[i];
                                return Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () => _showFull(img),
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 12),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.file(img,
                                              height: 180,
                                              width: double.infinity,
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 8,
                                      top: 8,
                                      child: CircleAvatar(
                                        backgroundColor:
                                            Colors.black.withOpacity(0.6),
                                        child: IconButton(
                                          icon: const Icon(Icons.close,
                                              color: Colors.white),
                                          onPressed: () => _remove(i),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
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
