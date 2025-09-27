class Evento {
  final String id;
  final String titulo;
  final String descripcion;
  final DateTime fecha;
  final String ubicacion;
  final TipoEvento tipo;
  final String imagenUrl;

  Evento({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.fecha,
    required this.ubicacion,
    required this.tipo,
    required this.imagenUrl,
  });
}

enum TipoEvento { CONCIERTO, FERIA, CONFERENCIA }