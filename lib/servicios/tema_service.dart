import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TemaService {
  static const String _keyTema = 'modo_oscuro';
  static const String _keyIdioma = 'idioma';

  static const Color colorPrimario = Color(0xFF6366F1);
  static const Color colorSecundario = Color(0xFFEC4899);
  static const Color colorAcento = Color(0xFF10B981);

  static Future<bool> esModoOscuro() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyTema) ?? false;
    } catch (e) {
      return false;
    }
  }

  static Future<void> guardarModoOscuro(bool modoOscuro) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyTema, modoOscuro);
    } catch (e) {
      print('Error guardando tema: $e');
    }
  }

  static Future<String> obtenerIdioma() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyIdioma) ?? 'es';
    } catch (e) {
      return 'es';
    }
  }

  static Future<void> guardarIdioma(String idioma) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyIdioma, idioma);
    } catch (e) {
      print('Error guardando idioma: $e');
    }
  }

  static ThemeData getTema(bool modoOscuro) {
    return modoOscuro ? ThemeData.dark() : ThemeData.light();
  }
}