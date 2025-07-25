// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:xml/xml.dart' as xml;
import '../canias_service.dart';
import 'insert_page.dart';
import 'ocr/ocr_screen.dart'; // OCR ekranı için import

class CrmScreen extends StatefulWidget {
  final String userName; // login ekranından gelecek
  const CrmScreen({super.key, required this.userName});

  @override
  State<CrmScreen> createState() => _CrmScreenState();
}

class _CrmScreenState extends State<CrmScreen> {
  bool _loading = false;
  List<Map<String, String>> _cards = [];

  @override
  void initState() {
    super.initState();
    _fetchData(); // sayfa açıldığında veri çek
  }

  Future<void> _fetchData() async {
    setState(() => _loading = true);

    final serviceResponse = await CaniasService.callService();
    if (serviceResponse != null) {
      final document = xml.XmlDocument.parse(serviceResponse);
      final valueElements = document.findAllElements('Value');

      String? innerXml;
      for (var valueElem in valueElements) {
        final text = valueElem.text;
        if (text.contains('CRMLIST')) {
          innerXml = text
              .replaceAll('&lt;', '<')
              .replaceAll('&gt;', '>')
              .replaceAll('&quot;', '"')
              .replaceAll('&amp;', '&');
          break;
        }
      }

      if (innerXml != null) {
        final crmDoc = xml.XmlDocument.parse(innerXml);
        final rows = crmDoc.findAllElements('ROW');

        List<Map<String, String>> tempCards = [];
        for (var row in rows) {
          tempCards.add({
            "id": row.getElement('ID')?.text ?? '',
            "name": row.getElement('NAME')?.text ?? '',
            "mail": row.getElement('MAIL')?.text ?? '',
            "usermail": row.getElement('USERMAIL')?.text ?? '',
            "position": row.getElement('POSITION')?.text ?? '',
            "telephone": row.getElement('TELEPHONE')?.text ?? '',
            "telephone2": row.getElement('TELEPHONE2')?.text ?? '',
            "company": row.getElement('COMPANY')?.text ?? '',
            "sites": row.getElement('SITES')?.text ?? '',
            "address": row.getElement('ADDRESS')?.text ?? '',
            "typeactions": row.getElement('TYPEACTIONS')?.text ?? '',
            "typematerial": row.getElement('TYPEMATERIAL')?.text ?? '',
            "notes": row.getElement('NOTES')?.text ?? '',
            "photopath": row.getElement('PHOTOPATH')?.text ?? '',
            "createname": row.getElement('CREATENAME')?.text ?? '',
          });
        }
        setState(() {
          _cards = tempCards;
          _loading = false;
        });
      } else {
        setState(() {
          _cards = [];
          _loading = false;
        });
      }
    } else {
      setState(() {
        _cards = [];
        _loading = false;
      });
    }
  }

  void _showCardDetail(Map<String, String> card) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            card['name'] ?? '',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('ID: ${card['id']}'),
                Text('Mail: ${card['mail']}'),
                Text('UserMail: ${card['usermail']}'),
                Text('Position: ${card['position']}'),
                Text('Telephone: ${card['telephone']}'),
                Text('Telephone2: ${card['telephone2']}'),
                Text('Company: ${card['company']}'),
                Text('Sites: ${card['sites']}'),
                Text('Address: ${card['address']}'),
                Text('TypeActions: ${card['typeactions']}'),
                Text('TypeMaterial: ${card['typematerial']}'),
                Text('Notes: ${card['notes']}'),
                Text('PhotoPath: ${card['photopath']}'),
                Text('CREATENAME: ${card['createname']}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Kapat'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0055A5),
        title: const Text(
          "CRM Listesi",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Yenile',
            onPressed: _fetchData,
          ),
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'insertPage') {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => InsertPage(userName: widget.userName),
                  ),
                );
                _fetchData();
              } else if (value == 'ocrScan') {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OCRScreen(userName: widget.userName),
                  ),
                );
                _fetchData();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'insertPage',
                child: Text('Yeni Kart Ekle'),
              ),
              const PopupMenuItem(
                value: 'ocrScan',
                child: Text('OCR'),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _cards.isEmpty
                ? const Center(
                    child: Text(
                      'Gösterilecek kayıt bulunamadı.',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _cards.length,
                    itemBuilder: (ctx, i) {
                      final card = _cards[i];
                      return GestureDetector(
                        onTap: () => _showCardDetail(card),
                        child: Card(
                          color: Colors.white,
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF81D4FA),
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                ),
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  card['name'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(card['mail'] ?? '',
                                        style: const TextStyle(fontSize: 14)),
                                    const SizedBox(height: 4),
                                    Text(
                                      card['company'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
