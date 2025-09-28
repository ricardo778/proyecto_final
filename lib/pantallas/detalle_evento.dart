import 'package:flutter/material.dart';
import '../modelos/evento.dart';

class DetalleEvento extends StatelessWidget {
  final Evento evento;

  const DetalleEvento({Key? key, required this.evento}) : super(key: key);

  String _obtenerNombreTipo(TipoEvento tipo) {
    switch (tipo) {
      case TipoEvento.CONCIERTO:
        return 'Concierto';
      case TipoEvento.FERIA:
        return 'Feria';
      case TipoEvento.CONFERENCIA:
        return 'Conferencia';
      case TipoEvento.GENERAL:
      default:
        return 'General';
    }
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year} a las ${fecha.hour}:${fecha.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Evento'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del evento
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://via.placeholder.com/400x200.png?text=Sin+Imagen',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Título
            Text(
              evento.nombre,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Tipo de evento
            Row(
              children: [
                const Icon(Icons.category, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  _obtenerNombreTipo(evento.tipo),
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // Fecha y hora
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  _formatearFecha(evento.fecha),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Ubicación
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  evento.ubicacion,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Descripción
            const Text(
              'Descripción:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              evento.descripcion,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
