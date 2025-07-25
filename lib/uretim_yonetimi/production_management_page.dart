import 'package:flutter/material.dart';

class ProductionManagementPage extends StatelessWidget {
  const ProductionManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0055A5),
        title: const Text(
          'Üretim Yönetimi',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Üretim ile ilgili işlev ekle
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Üretim Yönetimi > Buton 1')),
                  );
                },
                icon: const Icon(Icons.add_box),
                label: const Text('Yeni Üretim Emri'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0055A5),
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Üretim listesi işlevi ekle
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Üretim Yönetimi > Buton 2')),
                  );
                },
                icon: const Icon(Icons.list_alt),
                label: const Text('Üretim Listesi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const Spacer(),
              const Text(
                'Üretim yönetimi sayfası içerikleri buraya gelecek.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
