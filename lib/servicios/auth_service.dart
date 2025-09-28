import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:8000';

  // ========== FUNCIONES DE TOKEN Y USUARIO ==========
  static Future<void> guardarToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<String?> obtenerToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<void> guardarUsuario(Map<String, dynamic> usuario) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('usuario_data', json.encode(usuario));
  }

  static Future<Map<String, dynamic>?> obtenerUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final usuarioJson = prefs.getString('usuario_data');
    if (usuarioJson != null) {
      return json.decode(usuarioJson);
    }
    return null;
  }

  static Future<void> eliminarToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('usuario_data'); // También eliminar datos del usuario
  }

  static Future<bool> estaLogueado() async {
    final token = await obtenerToken();
    return token != null;
  }

  // ========== FUNCIONES DE API ==========
  static Future<Map<String, dynamic>> registrarUsuario({
    required String nombre,
    required String email,
    required String password,
    String? telefono,
  }) async {
    try {
      print('📝 Intentando registrar usuario: $email');
      
      final response = await http.post(
        Uri.parse('$baseUrl/auth/registro'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nombre': nombre,
          'email': email,
          'password': password,
          'telefono': telefono,
        }),
      );

      print('📝 Register Response Status: ${response.statusCode}');
      print('📝 Register Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // ✅ GUARDAR TOKEN Y USUARIO
        await guardarToken(data['token']);
        await guardarUsuario(data['usuario']);
        
        return {
          'success': true,
          'message': 'Usuario registrado exitosamente',
          'token': data['token'],
          'usuario': data['usuario'],
        };
      } else {
        final error = json.decode(response.body);
        return {
          'success': false,
          'message': error['detail'] ?? 'Error en el registro',
        };
      }
    } catch (e) {
      print('❌ Error en registro: $e');
      return {
        'success': false,
        'message': 'Error de conexión: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      print('🔐 Intentando login para: $email');
      
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      print('📡 Login Response Status: ${response.statusCode}');
      print('📡 Login Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // ✅ GUARDAR TOKEN Y USUARIO
        await guardarToken(data['token']);
        await guardarUsuario(data['usuario']);
        
        return {
          'success': true,
          'message': 'Login exitoso',
          'token': data['token'],
          'usuario': data['usuario'],
        };
      } else {
        final error = json.decode(response.body);
        return {
          'success': false,
          'message': error['detail'] ?? 'Error en el login',
        };
      }
    } catch (e) {
      print('❌ Error en login: $e');
      return {
        'success': false,
        'message': 'Error de conexión: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> verificarToken() async {
    try {
      final token = await obtenerToken();
      if (token == null) {
        return {'success': false, 'message': 'No hay token'};
      }

      final response = await http.get(
        Uri.parse('$baseUrl/auth/verificar?token=$token'),
      );

      print('🔍 Verificar Token Status: ${response.statusCode}');
      print('🔍 Verificar Token Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // ✅ ACTUALIZAR DATOS DEL USUARIO
        await guardarUsuario(data);
        return {
          'success': true,
          'message': 'Token válido',
          'usuario': data,
        };
      } else {
        await eliminarToken();
        final error = json.decode(response.body);
        return {
          'success': false,
          'message': error['detail'] ?? 'Token inválido',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e',
      };
    }
  }

  static Future<void> logout() async {
    await eliminarToken();
  }
}