import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../modelos/evento.dart';

class AlmacenamientoService {
  static const String _keyEventos = 'eventos';

  /// Guardar eventos en memoria local
  static Future<void> guardarEventos(List<Evento> eventos) async {
    final prefs = await SharedPreferences.getInstance();

    final eventosJson = eventos.map((e) => jsonEncode({
          'nombre': e.nombre,
          'descripcion': e.descripcion,
          'fecha': e.fecha.toIso8601String(),
          'ubicacion': e.ubicacion,
          'tipo': e.tipo.toString(), // Guardamos el enum como String
        })).toList();

    await prefs.setStringList(_keyEventos, eventosJson);
  }

  /// Cargar eventos desde memoria local
  static Future<List<Evento>> cargarEventos() async {
    final prefs = await SharedPreferences.getInstance();
    final eventosJson = prefs.getStringList(_keyEventos) ?? [];

    return eventosJson.map((jsonStr) {
      final map = jsonDecode(jsonStr);

      // Convertir el String de tipo de nuevo a enum
      final tipoEvento = TipoEvento.values.firstWhere(
        (e) => e.toString() == map['tipo'],
        orElse: () => TipoEvento.GENERAL,
      );

      return Evento(
        nombre: map['nombre'] ?? 'Sin nombre',
        descripcion: map['descripcion'] ?? 'Sin descripción',
        fecha: DateTime.tryParse(map['fecha']) ?? DateTime.now(),
        ubicacion: map['ubicacion'] ?? 'Ubicación desconocida',
        tipo: tipoEvento,
      );
    }).toList();
  }
}
