import '../modelos/evento.dart';

class EventosService {
  static List<Evento> obtenerEventos() {
    return [
      Evento(
        nombre: 'Festival de Música 2024',
        descripcion: 'El mejor festival del año con artistas internacionales',
        fecha: DateTime(2024, 12, 15, 20, 0),
        ubicacion: 'Estadio Nacional',
        tipo: TipoEvento.CONCIERTO,
      ),
      Evento(
        nombre: 'Feria de Tecnología',
        descripcion: 'Últimas innovaciones en tecnología y startups',
        fecha: DateTime(2024, 11, 20, 10, 0),
        ubicacion: 'Centro de Convenciones',
        tipo: TipoEvento.FERIA,
      ),
      Evento(
        nombre: 'Conferencia de Desarrollo Mobile',
        descripcion: 'Workshops y charlas sobre Flutter y React Native',
        fecha: DateTime(2024, 11, 25, 9, 0),
        ubicacion: 'Universidad Central',
        tipo: TipoEvento.CONFERENCIA,
      ),
    ];
  }

  static List<Evento> filtrarPorTipo(TipoEvento tipo) {
    return obtenerEventos().where((evento) => evento.tipo == tipo).toList();
  }
}