import 'package:flutter/material.dart';
import '../modelos/evento.dart';
import '../servicios/tema_service.dart';
import '../pantallas/detalle_evento.dart';

class TarjetaEvento extends StatelessWidget {
  final Evento evento;

  const TarjetaEvento({super.key, required this.evento});

  IconData _obtenerIconoPorTipo(TipoEvento tipo) {
    switch (tipo) {
      case TipoEvento.CONCIERTO:
        return Icons.music_note;
      case TipoEvento.FERIA:
        return Icons.shopping_cart;
      case TipoEvento.CONFERENCIA:
        return Icons.school;
      default:
        return Icons.event;
    }
  }

  Color _obtenerColorPorTipo(TipoEvento tipo) {
    switch (tipo) {
      case TipoEvento.CONCIERTO:
        return TemaService.colorSecundario;
      case TipoEvento.FERIA:
        return Colors.orange;
      case TipoEvento.CONFERENCIA:
        return TemaService.colorAcento;
      default:
        return TemaService.colorPrimario;
    }
  }

  String _formatearFecha(DateTime fecha) {
    final meses = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    return '${fecha.day} ${meses[fecha.month - 1]} • ${fecha.hour}:${fecha.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final colorTipo = _obtenerColorPorTipo(evento.tipo);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetalleEvento(evento: evento),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorTipo.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _obtenerIconoPorTipo(evento.tipo),
                  color: colorTipo,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      evento.nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatearFecha(evento.fecha),
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Text(
                      evento.ubicacion,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}