// ignore_for_file: deprecated_member_use

import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'dart:developer';

class CaniasService {
  static const String _url =
      'http://192.168.0.20:8080/CaniasWS-v2/services/CaniasWebService?wsdl';

  // Oturum bilgileri
  static String? _sessionId;
  static String? _securityKey;

  // Giriş yapan kullanıcının adını burada saklıyoruz
  static String? currentUserName = '';

  static String? get sessionId => _sessionId;
  static String? get securityKey => _securityKey;

  /// 🔑 LOGIN
  static Future<bool> loginWithParams(String username, String password) async {
    final loginRequest = '''<?xml version="1.0" encoding="utf-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://webservice.ias.com">
   <soapenv:Header/>
   <soapenv:Body>
      <web:login>
         <Client>00</Client>
         <Language>TR</Language>
         <DBServer>CANIAS</DBServer>
         <DBName>URTIM803</DBName>
         <ApplicationServer>192.168.0.20:27499</ApplicationServer>
         <Username>$username</Username>
         <Password>$password</Password>
         <Encrypted>false</Encrypted>
         <Compression>false</Compression>
         <LCheck></LCheck>
         <VKey></VKey>
      </web:login>
   </soapenv:Body>
</soapenv:Envelope>''';

    final response = await http.post(
      Uri.parse(_url),
      headers: {
        'Content-Type': 'text/xml; charset=utf-8',
        'SOAPAction': 'login',
      },
      body: loginRequest,
    );

    if (response.statusCode == 200) {
      final document = xml.XmlDocument.parse(response.body);
      final sessionNodes = document.findAllElements('SessionId');
      final securityNodes = document.findAllElements('SecurityKey');

      if (sessionNodes.isNotEmpty && securityNodes.isNotEmpty) {
        _sessionId = sessionNodes.first.text;
        _securityKey = securityNodes.first.text;

        // 👉 Giriş yapan kullanıcı adını burada saklıyoruz
        currentUserName = username;
        log('✅ Login başarılı! SessionId=$_sessionId SecurityKey=$_securityKey');
        log('👤 Giriş yapan kullanıcı: $currentUserName');
        return true;
      } else {
        log('❌ Login cevabında SessionId veya SecurityKey yok.');
      }
    } else {
      log('❌ Login hatası: ${response.statusCode}');
    }
    return false;
  }

  /// 🚪 LOGOUT
  static Future<bool> logout() async {
    if (_sessionId == null || _securityKey == null) {
      log('⚠️ Oturum bilgisi yok, logout gereksiz.');
      return true;
    }

    final logoutRequest = '''<?xml version="1.0" encoding="utf-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://webservice.ias.com">
   <soapenv:Header/>
   <soapenv:Body>
      <web:logout>
         <SessionId>$_sessionId</SessionId>
         <SecurityKey>$_securityKey</SecurityKey>
      </web:logout>
   </soapenv:Body>
</soapenv:Envelope>''';

    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {
          'Content-Type': 'text/xml; charset=utf-8',
          'SOAPAction': 'logout',
        },
        body: logoutRequest,
      );

      if (response.statusCode == 200) {
        log('✅ Logout başarılı!');

        _sessionId = null;
        _securityKey = null;
        currentUserName = '';
        return true;
      } else {
        log('❌ Logout başarısız! Kod: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      log('🔥 Logout sırasında hata: $e');
      return false;
    }
  }

  /// 📋 SERVİS ÇAĞIRMA (Liste çekmek için)
  static Future<String?> callService() async {
    if (_sessionId == null || _securityKey == null) {
      throw Exception('Önce login olmanız gerekiyor!');
    }

    final callServiceRequest = '''<?xml version="1.0" encoding="utf-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://webservice.ias.com">
   <soapenv:Header/>
   <soapenv:Body>
      <web:callService>
         <SessionId>$_sessionId</SessionId>
         <SecurityKey>$_securityKey</SecurityKey>
         <ServiceId>CONNTEST</ServiceId>
         <Parameters><![CDATA[
           <PARAMETERS>
             <PARAM>Urtim</PARAM>
           </PARAMETERS>
         ]]></Parameters>
         <Compressed>0</Compressed>
         <Permanent>0</Permanent>
         <ExtraVariables></ExtraVariables>
         <RequestId>1</RequestId>
      </web:callService>
   </soapenv:Body>
</soapenv:Envelope>''';

    final response = await http.post(
      Uri.parse(_url),
      headers: {
        'Content-Type': 'text/xml; charset=utf-8',
        'SOAPAction': 'callService',
      },
      body: callServiceRequest,
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      log('❌ CallService hatası: ${response.statusCode}');
      return null;
    }
  }

  /// ➕ TABLOYA EKLEME
  static Future<bool> insertCrm({
    required String id,
    required String name,
    required String mail,
    required String userMail,
    required String position,
    required String tel1,
    required String tel2,
    required String company,
    required String sites,
    required String address,
    required String typeAction,
    required String typeMaterial,
    required String notes,
    String? photoBase64, // opsiyonel oldu // opsiyonel oldu
    required String createName,
    String? fileName,
  }) async {
    final insertRequest = '''<?xml version="1.0" encoding="utf-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://webservice.ias.com">
  <soapenv:Header/>
  <soapenv:Body>
    <web:callService>
      <SessionId>$_sessionId</SessionId>
      <SecurityKey>$_securityKey</SecurityKey>
      <ServiceId>CONNTEST_INSERT</ServiceId>
      <Parameters><![CDATA[
        <PARAMETERS>
          <PARAM>$id</PARAM>
          <PARAM>$name</PARAM>
          <PARAM>$mail</PARAM>
          <PARAM>$userMail</PARAM>
          <PARAM>$position</PARAM>
          <PARAM>$tel1</PARAM>
          <PARAM>$tel2</PARAM>
          <PARAM>$company</PARAM>
          <PARAM>$sites</PARAM>
          <PARAM>$address</PARAM>
          <PARAM>$typeAction</PARAM>
          <PARAM>$typeMaterial</PARAM>
          <PARAM>$notes</PARAM>
          <PARAM>${photoBase64 ?? ''}</PARAM>
          <PARAM>$createName</PARAM>
          <PARAM>${fileName ?? ''}</PARAM>
        </PARAMETERS>
      ]]></Parameters>
      <Compressed>0</Compressed>
      <Permanent>0</Permanent>
      <ExtraVariables></ExtraVariables>
      <RequestId>1</RequestId>
    </web:callService>
  </soapenv:Body>
</soapenv:Envelope>''';

    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {
          'Content-Type': 'text/xml; charset=utf-8',
          'SOAPAction': 'callService',
        },
        body: insertRequest,
      );

      if (response.statusCode == 200) {
        if (response.body.contains('<SYSStatus>0</SYSStatus>')) {
          log('✅ [insertCrm] Kayıt başarılı.');
          return true;
        } else {
          log('⚠️ [insertCrm] SYSStatus != 0');
          return false;
        }
      } else {
        log('❌ [insertCrm] HTTP hatası: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      log('🔥 [insertCrm] Hata: $e');
      return false;
    }
  }

  /// Üretim duruşu örnek servisi
  static Future<String?> getPrdDurus() async {
    if (_sessionId == null || _securityKey == null) {
      throw Exception('Önce login olmanız gerekiyor!');
    }

    final requestXml = '''<?xml version="1.0" encoding="utf-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://webservice.ias.com">
  <soapenv:Header/>
  <soapenv:Body>
    <web:callService>
      <SessionId>$_sessionId</SessionId>
      <SecurityKey>$_securityKey</SecurityKey>
      <ServiceId>PRDDURUS</ServiceId>
      <Parameters><![CDATA[
        <PARAMETERS>
        </PARAMETERS>
      ]]></Parameters>
      <Compressed>0</Compressed>
      <Permanent>0</Permanent>
      <ExtraVariables></ExtraVariables>
      <RequestId>1</RequestId>
    </web:callService>
  </soapenv:Body>
</soapenv:Envelope>''';

    final response = await http.post(
      Uri.parse(_url),
      headers: {
        'Content-Type': 'text/xml; charset=utf-8',
        'SOAPAction': 'callService',
      },
      body: requestXml,
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      log('❌ PRDDURUS hatası: ${response.statusCode}');
      return null;
    }
  }
}
