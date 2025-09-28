import 'package:flutter/material.dart';
enum TipoEvento { GENERAL, CONCIERTO, FERIA, CONFERENCIA }

class Evento {
  final String nombre;
  final String descripcion;
  final String ubicacion;
  final DateTime fecha;
  final TipoEvento tipo;

  Evento({
    required this.nombre,
    required this.descripcion,
    required this.ubicacion,
    required this.fecha,
    required this.tipo,
  });

  factory Evento.fromJson(Map<String, dynamic> json) {
    // Combinar fecha y hora en un solo DateTime
    String fechaStr = json['fecha'] ?? '';
    String horaStr = json['hora'] ?? '';
    DateTime fechaEvento = DateTime.tryParse("$fechaStr $horaStr") ?? DateTime.now();

    // Mapear ubicación
    String ubicacionStr = json['ubicacion'] != null
        ? json['ubicacion']['nombre_lugar'] ?? 'Ubicación desconocida'
        : 'Ubicación desconocida';

    // Mapear tipo
    String tipoStr = (json['tipo'] ?? '').toUpperCase();
    TipoEvento tipoEvento;
    switch (tipoStr) {
      case 'CONCIERTO':
        tipoEvento = TipoEvento.CONCIERTO;
        break;
      case 'FERIA':
        tipoEvento = TipoEvento.FERIA;
        break;
      case 'CONFERENCIA':
        tipoEvento = TipoEvento.CONFERENCIA;
        break;
      default:
        tipoEvento = TipoEvento.GENERAL;
    }

    return Evento(
      nombre: json['nombre'] ?? 'Sin nombre',
      descripcion: json['descripcion_corta'] ?? 'Sin descripción',
      ubicacion: ubicacionStr,
      fecha: fechaEvento,
      tipo: tipoEvento,
    );
  }
}

/// Método auxiliar para mostrar nombre legible del tipo
String _obtenerNombreTipo(TipoEvento tipo) {
  switch (tipo) {
    case TipoEvento.CONCIERTO:
      return 'Concierto';
    case TipoEvento.FERIA:
      return 'Feria';
    case TipoEvento.CONFERENCIA:
      return 'Conferencia';
    case TipoEvento.GENERAL:
      return 'General';
    default:
      return 'Otro';
  }
}

/// Widget de ejemplo mostrando la fila con icono + tipo de evento
class EventoWidget extends StatelessWidget {
  final Evento evento;

  const EventoWidget({Key? key, required this.evento}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.category, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          _obtenerNombreTipo(evento.tipo),
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }
}
