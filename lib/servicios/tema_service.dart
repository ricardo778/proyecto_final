// servicios/tema_service.dart (CON CARDTHEME)
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TemaService {
  static const String _keyTema = 'modo_oscuro';
  static const String _keyIdioma = 'idioma';

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
    if (modoOscuro) {
      return ThemeData.dark().copyWith(
        primaryColor: Colors.blue[800],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue[800],
          elevation: 4,
        ),
      );
    } else {
      return ThemeData.light().copyWith(
        primaryColor: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          elevation: 4,
        ),
      );
    }
  }
}