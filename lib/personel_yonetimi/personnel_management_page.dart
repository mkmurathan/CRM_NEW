import 'package:flutter/material.dart';

class PersonnelManagementPage extends StatelessWidget {
  const PersonnelManagementPage({super.key});

  // 🔥 Boş sayfa widget’ı
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

  // 🔥 Daire buton oluşturucu
  Widget _buildCircleButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String pageTitle,
  }) {
    const Color blue = Color(0xFF0055A5);
    return ElevatedButton(
      onPressed: () => _navigateToEmptyPage(context, pageTitle),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: blue,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(24),
        elevation: 4,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 40, color: blue),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: blue,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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
          'Personel Yönetimi',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildCircleButton(
                context: context,
                icon: Icons.calendar_today,
                label: 'İzin\nTalebi',
                pageTitle: 'İzin Talebi',
              ),
              _buildCircleButton(
                context: context,
                icon: Icons.school,
                label: 'Eğitim\nTalebi',
                pageTitle: 'Eğitim Talebi',
              ),
              _buildCircleButton(
                context: context,
                icon: Icons.receipt_long,
                label: 'Bordro\nTalebi',
                pageTitle: 'Bordro Talebi',
              ),
              _buildCircleButton(
                context: context,
                icon: Icons.track_changes,
                label: 'Yıllık İzin\nTakibi',
                pageTitle: 'Yıllık İzin Takibi',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
