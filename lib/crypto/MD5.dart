import 'dart:convert';
import 'package:crypto/crypto.dart';

class MD5 {
  static String generateHash(String phoneNumber) {
    return md5.convert(utf8.encode(phoneNumber)).toString();
  }
}