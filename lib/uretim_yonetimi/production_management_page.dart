import 'package:flutter/material.dart';

class ProductionManagementPage extends StatelessWidget {
  const ProductionManagementPage({super.key});

  void _navigateToEmptyPage(BuildContext context, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: const Color(0xFF0055A5),
              title: Text(title, style: const TextStyle(color: Colors.white)),
              centerTitle: true,
            ),
            body: Center(
              child: Text(
                '$title sayfası hazırlanıyor...',
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color blue = Color(0xFF0055A5);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: blue,
        title: const Text(
          'Üretim Yönetimi',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Center(
          child: ElevatedButton(
            onPressed: () => _navigateToEmptyPage(context, 'Üretim Raporu'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: blue,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(32),
              elevation: 4,
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bar_chart, size: 40, color: blue),
                SizedBox(height: 8),
                Text(
                  'Üretim Raporu',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: blue,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
