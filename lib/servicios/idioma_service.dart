class IdiomaService {
  static Map<String, Map<String, String>> _traducciones = {
    'es': {
      'inicio': 'Inicio',
      'app_title': 'Agenda de Eventos',
      'conciertos': 'Conciertos',
      'ferias': 'Ferias',
      'conferencias': 'Conferencias',
      'todos_eventos': 'Todos los eventos',
      'buscar_eventos': 'Buscar eventos...',
      'buscar': 'Buscar',
      'filtrar': 'Filtrar',
      'agregar_evento': 'Agregar nuevo evento',
      'evento_agregado': 'Evento agregado exitosamente!',
      'cargando': 'Cargando eventos...',
      'no_eventos': 'No se encontraron eventos',
      'limpiar_filtros': 'Limpiar filtros',
      'limpiar': 'Limpiar',
      'filtros': 'Filtros',
      'configuracion': 'Configuración',
      'acerca_de': 'Acerca de',
      'intenta_otros_filtros': 'Intenta con otros filtros de búsqueda',
      'agrega_primer_evento': 'Agrega tu primer evento usando el botón +',
      'cerrar_busqueda': 'Cerrar búsqueda',
    },
    'en': {
      'inicio': 'Home',
      'app_title': 'Events Agenda',
      'conciertos': 'Concerts',
      'ferias': 'Fairs',
      'conferencias': 'Conferences',
      'todos_eventos': 'All events',
      'buscar_eventos': 'Search events...',
      'buscar': 'Search',
      'filtrar': 'Filter',
      'agregar_evento': 'Add new event',
      'evento_agregado': 'Event added successfully!',
      'cargando': 'Loading events...',
      'no_eventos': 'No events found',
      'limpiar_filtros': 'Clear filters',
      'limpiar': 'Clear',
      'filtros': 'Filters',
      'configuracion': 'Settings',
      'acerca_de': 'About',
      'intenta_otros_filtros': 'Try other search filters',
      'agrega_primer_evento': 'Add your first event using the + button',
      'cerrar_busqueda': 'Close search',
    },
  };

  static String traducir(String clave, String idioma) {
    return _traducciones[idioma]?[clave] ?? _traducciones['es']![clave]!;
  }
}