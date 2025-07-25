import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OCRHelper {
  final TextRecognizer _textRecognizer = TextRecognizer();

  Future<Map<String, String>> extractTextFromImages(List<File> images) async {
    Map<String, String> data = {};

    for (var image in images) {
      final inputImage = InputImage.fromFile(image);
      final RecognizedText recognizedText =
          await _textRecognizer.processImage(inputImage);

      final text = recognizedText.text;
      // 🔥 Basit bir parse işlemi (kendi kartvizit yapına göre düzenle)
      if (text.contains('@')) {
        data['email'] = text.split('\n').firstWhere(
              (line) => line.contains('@'),
              orElse: () => '',
            );
      }
      // örnek bazı alanları çıkar
      // bu alanları kendi ihtiyacına göre geliştir
      data['name'] = text.split('\n').isNotEmpty ? text.split('\n')[0] : '';
      data['phone'] = text.contains('+90')
          ? (text
              .split('\n')
              .firstWhere((l) => l.contains('+90'), orElse: () => ''))
          : '';
      data['department'] = ''; // ekstradan doldurulabilir
      data['firma'] = ''; // ekstradan doldurulabilir
    }

    return data;
  }

  void dispose() {
    _textRecognizer.close();
  }
}
