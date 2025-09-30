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
        SnackBar(
          content: Text("Error cargando eventos: $e"),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
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
        SnackBar(
          content: Text("Error recargando eventos: $e"),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _aplicarFiltros() {
    List<Evento> eventosTemp = List.from(eventos);

    if (_buscando && _controladorBusqueda.text.isNotEmpty) {
      final textoBusqueda = _controladorBusqueda.text.toLowerCase();
      eventosTemp = eventosTemp
          .where((evento) =>
              evento.nombre.toLowerCase().contains(textoBusqueda) ||
              evento.descripcion.toLowerCase().contains(textoBusqueda) ||
              evento.ubicacion.toLowerCase().contains(textoBusqueda))
          .toList();
    }

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
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(TemaService.colorPrimario),
              ),
            ),
            const SizedBox(height: 20),
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
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.event_available_outlined,
                size: 80,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 20),
              Text(
                IdiomaService.traducir('no_eventos', _idioma),
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
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
      backgroundColor: TemaService.colorPrimario,
      color: Colors.white,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: eventosFiltrados.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
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
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                TemaService.colorPrimario,
                TemaService.colorSecundario.withOpacity(0.8),
              ],
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Agenda de Eventos',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Descubre y organiza tus eventos',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  controller: _controladorBusqueda,
                  decoration: InputDecoration(
                    hintText: IdiomaService.traducir('buscar_eventos', _idioma),
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.7)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  style: TextStyle(color: Colors.white),
                  onChanged: (value) => _aplicarFiltros(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(child: _construirListaEventos()),
      ],
    );
  }

  Widget _construirVistaTablet() {
    return Row(
      children: [
        Container(
          width: 320,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(2, 0),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      TemaService.colorPrimario,
                      TemaService.colorSecundario.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Agenda de Eventos',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Todos los eventos disponibles',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextField(
                        controller: _controladorBusqueda,
                        decoration: InputDecoration(
                          hintText: IdiomaService.traducir('buscar_eventos', _idioma),
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                        onChanged: (value) => _aplicarFiltros(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: TemaService.colorAcento.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: TemaService.colorAcento, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '${eventosFiltrados.length} eventos encontrados',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _construirListaEventos(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buscando ? AppBar(
        title: TextField(
          controller: _controladorBusqueda,
          decoration: InputDecoration(
            hintText: IdiomaService.traducir('buscar_eventos', _idioma),
            border: InputBorder.none,
            hintStyle: TextStyle(color: const Color.fromARGB(179, 0, 0, 0)),
            icon: Icon(Icons.search, color: const Color.fromARGB(179, 0, 0, 0)),
          ),
          style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontSize: 16),
          autofocus: true,
          onChanged: (value) => _aplicarFiltros(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: _alternarBusqueda,
            tooltip: IdiomaService.traducir('cerrar_busqueda', _idioma),
          ),
        ],
      ) : AppBar(
        title: Text(
          IdiomaService.traducir('app_title', _idioma),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: TemaService.colorPrimario,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (!_buscando) 
            IconButton(
              icon: Icon(Icons.search),
              onPressed: _alternarBusqueda,
              tooltip: IdiomaService.traducir('buscar', _idioma),
            ),
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
      floatingActionButton: !_buscando ? FloatingActionButton(
        onPressed: _recargarEventos,
        backgroundColor: TemaService.colorPrimario,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Icon(Icons.refresh_rounded),
      ) : null,
    );
  }

  @override
  void dispose() {
    _controladorBusqueda.dispose();
    super.dispose();
  }
}