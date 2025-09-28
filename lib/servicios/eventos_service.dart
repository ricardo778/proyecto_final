import '../modelos/evento.dart'; // Importa la clase Evento

class EventosService {
  // Función síncrona para obtener eventos estáticos
  static List<Evento> obtenerEventos() {
    return [
      Evento(
        // 'id' y 'titulo' han sido reemplazados por 'nombre'
        nombre: 'Festival de Música 2024',
        descripcion: 'El mejor festival del año con artistas internacionales',
        fecha: DateTime(2024, 12, 15, 20, 0),
        ubicacion: 'Estadio Nacional',
        tipo: TipoEvento.CONCIERTO,
      ),
      Evento(
        // 'id' y 'titulo' han sido reemplazados por 'nombre'
        nombre: 'Feria de Tecnología',
        descripcion: 'Últimas innovaciones en tecnología y startups',
        fecha: DateTime(2024, 11, 20, 10, 0),
        ubicacion: 'Centro de Convenciones',
        tipo: TipoEvento.FERIA,
      ),
      Evento(
        // 'id' y 'titulo' han sido reemplazados por 'nombre'
        nombre: 'Conferencia de Desarrollo Mobile',
        descripcion: 'Workshops y charlas sobre Flutter y React Native',
        fecha: DateTime(2024, 11, 25, 9, 0),
        ubicacion: 'Universidad Central',
        tipo: TipoEvento.CONFERENCIA,
      ),
    ];
  }

  // Función síncrona para filtrar eventos por tipo
  static List<Evento> filtrarPorTipo(TipoEvento tipo) {
    return obtenerEventos().where((evento) => evento.tipo == tipo).toList();
  }
}
