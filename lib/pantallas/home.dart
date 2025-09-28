import 'package:flutter/material.dart';
import '../modelos/evento.dart';
import '../servicios/eventos_service.dart';
import '../servicios/almacenamiento_service.dart';
import '../servicios/tema_service.dart';
import '../servicios/idioma_service.dart';
import '../widgets/tarjeta_evento.dart';
import '../widgets/drawer_personalizado.dart';
import '../widgets/responsive_layout.dart';
import 'configuracion_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../modelos/evento.dart';

class ApiEventosService {
  static const String baseUrl = "http://localhost:8000/api/v1/eventos";

  static Future<List<Evento>> obtenerEventos() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Evento.fromJson(json)).toList();
    } else {
      throw Exception("Error al cargar eventos: ${response.statusCode}");
    }
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Evento> eventos = [];
  List<Evento> eventosFiltrados = [];
  final TextEditingController _controladorBusqueda = TextEditingController();
  bool _buscando = false;
  bool _modoOscuro = false;
  bool _cargando = true;
  String _idioma = 'es';

  @override
  void initState() {
    super.initState();
    _inicializarApp();
  }

  void _inicializarApp() async {
    // Cargar preferencias de tema e idioma
    _modoOscuro = await TemaService.esModoOscuro();
    _idioma = await TemaService.obtenerIdioma();

    try {
      final eventosApi = await ApiEventosService.obtenerEventos();
      setState(() {
        eventos = eventosApi;
        eventosFiltrados = eventosApi;
        _cargando = false;
      });
    } catch (e) {
      setState(() {
        _cargando = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error cargando eventos: $e")),
      );
    }
  }

  Future<void> _cargarEventos() async {
    setState(() {
      _cargando = true;
    });

    try {
      final eventosApi = await ApiEventosService.obtenerEventos();
      setState(() {
        eventos = eventosApi;
        eventosFiltrados = eventosApi;
        _cargando = false;
      });
    } catch (e) {
      setState(() {
        _cargando = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error recargando eventos: $e")),
      );
    }
  }

  void _aplicarFiltros() {
    List<Evento> eventosTemp = List.from(eventos);

    // Aplicar filtro de búsqueda
    if (_buscando && _controladorBusqueda.text.isNotEmpty) {
      final textoBusqueda = _controladorBusqueda.text.toLowerCase();
      eventosTemp = eventosTemp
          .where((evento) =>
              evento.nombre.toLowerCase().contains(textoBusqueda) ||
              evento.descripcion.toLowerCase().contains(textoBusqueda) ||
              evento.ubicacion.toLowerCase().contains(textoBusqueda))
          .toList();
    }

    // Ordenar por fecha (más cercanos primero)
    eventosTemp.sort((a, b) => a.fecha.compareTo(b.fecha));

    setState(() {
      eventosFiltrados = eventosTemp;
    });
  }

  void _alternarBusqueda() {
    setState(() {
      _buscando = !_buscando;
      if (!_buscando) {
        _controladorBusqueda.clear();
        eventosFiltrados = eventos;
      }
    });
  }

  void _actualizarConfiguracion(bool modoOscuro, String idioma) {
    setState(() {
      _modoOscuro = modoOscuro;
      _idioma = idioma;
    });
  }

  Future<void> _recargarEventos() async {
    await _cargarEventos();
  }

  Widget _construirListaEventos() {
    if (_cargando) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              strokeWidth: 3,
            ),
            SizedBox(height: 20),
            Text(
              IdiomaService.traducir('cargando', _idioma),
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (eventosFiltrados.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.event_available,
                size: 80,
                color: Colors.grey[300],
              ),
              SizedBox(height: 20),
              Text(
                IdiomaService.traducir('no_eventos', _idioma),
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                _buscando
                    ? IdiomaService.traducir('intenta_otros_filtros', _idioma)
                    : IdiomaService.traducir('agrega_primer_evento', _idioma),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _recargarEventos,
      backgroundColor: Colors.blue,
      color: Colors.white,
      child: ListView.builder(
        itemCount: eventosFiltrados.length,
        itemBuilder: (context, index) {
          final evento = eventosFiltrados[index];
          return TarjetaEvento(evento: evento);
        },
      ),
    );
  }

  Widget _construirVistaMobile() {
    return Column(
      children: [
        // Header estilo imagen (sin filtros)
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Agenda de Eventos',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Todos los eventos disponibles',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        Expanded(child: _construirListaEventos()),
      ],
    );
  }

  Widget _construirVistaTablet() {
    return Row(
      children: [
        // Panel lateral (sin filtros)
        Container(
          width: 280,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(2, 0),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Agenda de Eventos',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Todos los eventos disponibles',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Lista de eventos
        Expanded(
          child: _construirListaEventos(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buscando
            ? TextField(
                controller: _controladorBusqueda,
                decoration: InputDecoration(
                  hintText: IdiomaService.traducir('buscar_eventos', _idioma),
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white70),
                  icon: Icon(Icons.search, color: Colors.white70),
                ),
                style: TextStyle(color: Colors.white, fontSize: 16),
                autofocus: true,
                onChanged: (value) => _aplicarFiltros(),
              )
            : Text(
                IdiomaService.traducir('app_title', _idioma),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
        actions: [
          if (!_buscando) ...[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: _alternarBusqueda,
              tooltip: IdiomaService.traducir('buscar', _idioma),
            ),
          ] else ...[
            IconButton(
              icon: Icon(Icons.close),
              onPressed: _alternarBusqueda,
              tooltip: IdiomaService.traducir('cerrar_busqueda', _idioma),
            ),
          ],
        ],
      ),
      drawer: DrawerPersonalizado(
        onConfiguracionCambiada: _actualizarConfiguracion,
        idiomaActual: _idioma,
        modoOscuroActual: _modoOscuro,
      ),
      body: ResponsiveLayout(
        mobile: _construirVistaMobile(),
        tablet: _construirVistaTablet(),
        desktop: _construirVistaTablet(),
      ),
    );
  }

  @override
  void dispose() {
    _controladorBusqueda.dispose();
    super.dispose();
  }
}