import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:convert';

class Utility {

  static Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64.decode(base64String),
      fit: BoxFit.fill,
    );
  }

  static Uint8List dataFromBase64String(String base64String) {
    return base64.decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64.encode(data);
  }
}