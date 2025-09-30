import 'package:flutter/material.dart';
import '../modelos/evento.dart';
import '../servicios/tema_service.dart';

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
        backgroundColor: TemaService.colorPrimario,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título principal
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: TemaService.colorPrimario.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    evento.nombre,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: TemaService.colorPrimario,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.category, size: 16, color: TemaService.colorPrimario),
                      const SizedBox(width: 6),
                      Text(
                        _obtenerNombreTipo(evento.tipo),
                        style: TextStyle(
                          fontSize: 14,
                          color: TemaService.colorPrimario,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Información del evento en tarjetas
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Fecha y hora
                    _buildInfoRow(
                      Icons.calendar_today,
                      'Fecha y hora',
                      _formatearFecha(evento.fecha),
                    ),
                    const SizedBox(height: 12),
                    // Ubicación
                    _buildInfoRow(
                      Icons.location_on,
                      'Ubicación',
                      evento.ubicacion,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Descripción
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Descripción',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      evento.descripcion.isEmpty 
                          ? 'Sin descripción' 
                          : evento.descripcion,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}