import 'package:flutter/material.dart';
import 'crm/crm_screen.dart';
import 'login_screen.dart';
import 'uretim_yonetimi/production_management_page.dart';
import 'personel_yonetimi/personnel_management_page.dart';
import 'canias_service.dart';

class HomeScreen extends StatefulWidget {
  final String userName; // Login ekranından gönderilecek kullanıcı adı
  const HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _navigateToEmptyPage(String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: const Color(0xFF0055A5),
              title: Text(title),
              centerTitle: true,
            ),
            body: const Center(child: Text('Bu sayfa henüz hazırlanmadı.')),
          ),
        ),
      ),
    );
  }

  void _logout() async {
    final success = await CaniasService.logout();
    // Başarılı veya başarısız olsun, login sayfasına geri dön
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF0055A5),
          title: Text('Hoş geldin, ${widget.userName}!'),
          centerTitle: true,
        ),
        drawer: SafeArea(
          child: Drawer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(color: Color(0xFF0055A5)),
                  child: Center(
                    child: Text(
                      'Menü',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.people, color: Color(0xFF1976D2)),
                  title: const Text('Personel Yönetimi',
                      style: TextStyle(color: Color(0xFF0055A5))),
                  onTap: () {
                    Navigator.pop(context);
                    _navigateToEmptyPage('Personel Yönetimi');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_today,
                      color: Color(0xFF1976D2)),
                  title: const Text('İzin Yönetimi',
                      style: TextStyle(color: Color(0xFF0055A5))),
                  onTap: () {
                    Navigator.pop(context);
                    _navigateToEmptyPage('İzin Yönetimi');
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.info, color: Color(0xFF1976D2)),
                  title: const Text('Hakkında',
                      style: TextStyle(color: Color(0xFF0055A5))),
                  onTap: () {
                    Navigator.pop(context);
                    _navigateToEmptyPage('Hakkında');
                  },
                ),
                const Spacer(),
                ListTile(
                  tileColor: Colors.red.shade50,
                  leading: Icon(Icons.logout, color: Colors.red.shade700),
                  title: Text(
                    'Çıkış Yap',
                    style: TextStyle(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _logout();
                  },
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildCircleButton(
                icon: Icons.people_outline,
                label: 'CRM',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CrmScreen(userName: widget.userName),
                    ),
                  );
                },
              ),
              _buildCircleButton(
                icon: Icons.trending_up,
                label: 'Satış Yönetimi',
                onTap: () => _navigateToEmptyPage('Satış Yönetimi'),
              ),
              _buildCircleButton(
                icon: Icons.local_shipping,
                label: 'Tedarik Zinciri',
                onTap: () => _navigateToEmptyPage('Tedarik Zinciri'),
              ),
              _buildCircleButton(
                icon: Icons.account_balance_wallet,
                label: 'Finans Yönetimi',
                onTap: () => _navigateToEmptyPage('Finans Yönetimi'),
              ),
              _buildCircleButton(
                icon: Icons.factory,
                label: 'Üretim Yönetimi',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProductionManagementPage(),
                    ),
                  );
                },
              ),
              _buildCircleButton(
                icon: Icons.people,
                label: 'Personel Yönetimi',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PersonnelManagementPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0055A5),
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(24),
        elevation: 4,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: const Color(0xFF0055A5)),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF0055A5)),
          ),
        ],
      ),
    );
  }
}
