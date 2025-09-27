import 'package:flutter/material.dart';
import '../modelos/evento.dart';

class DetalleEvento extends StatelessWidget {
  final Evento evento;

  const DetalleEvento({required this.evento});

  String _obtenerNombreTipo(TipoEvento tipo) {
    switch (tipo) {
      case TipoEvento.CONCIERTO:
        return 'Concierto';
      case TipoEvento.FERIA:
        return 'Feria';
      case TipoEvento.CONFERENCIA:
        return 'Conferencia';
    }
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year} a las ${fecha.hour}:${fecha.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle del Evento'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del evento
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(evento.imagenUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            
            // Título
            Text(
              evento.titulo,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            
            // Tipo de evento
            Row(
              children: [
                Icon(Icons.category, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  _obtenerNombreTipo(evento.tipo),
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 15),
            
            // Fecha y hora
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  _formatearFecha(evento.fecha),
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 10),
            
            // Ubicación
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  evento.ubicacion,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 20),
            
            // Descripción
            Text(
              'Descripción:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              evento.descripcion,
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}