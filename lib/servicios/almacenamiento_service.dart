import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../modelos/evento.dart';

class AlmacenamientoService {
  static const String _keyEventos = 'eventos';

  static Future<void> guardarEventos(List<Evento> eventos) async {
    final prefs = await SharedPreferences.getInstance();
    final eventosJson = eventos.map((e) => jsonEncode({
      'id': e.id,
      'titulo': e.titulo,
      'descripcion': e.descripcion,
      'fecha': e.fecha.toIso8601String(),
      'ubicacion': e.ubicacion,
      'tipo': e.tipo.toString(),
      'imagenUrl': e.imagenUrl,
    })).toList();
    
    await prefs.setStringList(_keyEventos, eventosJson);
  }

  static Future<List<Evento>> cargarEventos() async {
    final prefs = await SharedPreferences.getInstance();
    final eventosJson = prefs.getStringList(_keyEventos) ?? [];
    
    return eventosJson.map((json) {
      final map = jsonDecode(json);
      return Evento(
        id: map['id'],
        titulo: map['titulo'],
        descripcion: map['descripcion'],
        fecha: DateTime.parse(map['fecha']),
        ubicacion: map['ubicacion'],
        tipo: TipoEvento.values.firstWhere(
          (e) => e.toString() == map['tipo']
        ),
        imagenUrl: map['imagenUrl'],
      );
    }).toList();
  }
}