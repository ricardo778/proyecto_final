import 'package:flutter/material.dart';
import '../modelos/evento.dart';
import '../servicios/eventos_service.dart';
import '../servicios/almacenamiento_service.dart';
import '../servicios/tema_service.dart';
import '../servicios/idioma_service.dart';
import '../widgets/tarjeta_evento.dart';
import '../widgets/drawer_personalizado.dart';
import '../widgets/responsive_layout.dart';
import 'nuevo_evento.dart';
import 'configuracion_screen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Evento> eventos = [];
  List<Evento> eventosFiltrados = [];
  TipoEvento? filtroActual;
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
    
    // Cargar eventos desde SharedPreferences
    final eventosGuardados = await AlmacenamientoService.cargarEventos();
    
    setState(() {
      if (eventosGuardados.isNotEmpty) {
        eventos = eventosGuardados;
      } else {
        // Datos de ejemplo si no hay eventos guardados
        eventos = EventosService.obtenerEventos();
        AlmacenamientoService.guardarEventos(eventos);
      }
      _cargando = false;
      _aplicarFiltros();
    });
  }

  Future<void> _cargarEventos() async {
    setState(() {
      _cargando = true;
    });

    final eventosGuardados = await AlmacenamientoService.cargarEventos();
    
    setState(() {
      eventos = eventosGuardados.isNotEmpty ? eventosGuardados : eventos;
      _cargando = false;
      _aplicarFiltros();
    });
  }

  void _aplicarFiltro(TipoEvento? tipo) {
    setState(() {
      filtroActual = tipo;
      _aplicarFiltros();
    });
  }

  void _aplicarFiltros() {
    List<Evento> eventosTemp = List.from(eventos);
    
    // Aplicar filtro por tipo
    if (filtroActual != null) {
      eventosTemp = eventosTemp.where((evento) => evento.tipo == filtroActual).toList();
    }
    
    // Aplicar filtro de búsqueda
    if (_buscando && _controladorBusqueda.text.isNotEmpty) {
      final textoBusqueda = _controladorBusqueda.text.toLowerCase();
      eventosTemp = eventosTemp.where((evento) =>
        evento.titulo.toLowerCase().contains(textoBusqueda) ||
        evento.descripcion.toLowerCase().contains(textoBusqueda) ||
        evento.ubicacion.toLowerCase().contains(textoBusqueda)
      ).toList();
    }
    
    // Ordenar por fecha (más cercanos primero)
    eventosTemp.sort((a, b) => a.fecha.compareTo(b.fecha));
    
    eventosFiltrados = eventosTemp;
  }

  void _alternarBusqueda() {
    setState(() {
      _buscando = !_buscando;
      if (!_buscando) {
        _controladorBusqueda.clear();
      }
      _aplicarFiltros();
    });
  }

  void _limpiarFiltros() {
    setState(() {
      filtroActual = null;
      _controladorBusqueda.clear();
      _buscando = false;
      _aplicarFiltros();
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

  String _obtenerSubtitulo() {
    if (filtroActual != null) {
      switch (filtroActual!) {
        case TipoEvento.CONCIERTO:
          return IdiomaService.traducir('conciertos', _idioma);
        case TipoEvento.FERIA:
          return IdiomaService.traducir('ferias', _idioma);
        case TipoEvento.CONFERENCIA:
          return IdiomaService.traducir('conferencias', _idioma);
      }
    }
    return IdiomaService.traducir('todos_eventos', _idioma);
  }

  Widget _construirIndicadorFiltros() {
    if (filtroActual != null || _buscando) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.withOpacity(0.1), Colors.lightBlue.withOpacity(0.05)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          border: Border.all(color: Colors.blue.withOpacity(0.3), width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Icon(Icons.filter_list, size: 18, color: Colors.blue),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                '${IdiomaService.traducir('filtros', _idioma)}: ${_obtenerSubtitulo()}${_buscando && _controladorBusqueda.text.isNotEmpty ? ' + "${_controladorBusqueda.text}"' : ''}',
                style: TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            TextButton(
              onPressed: _limpiarFiltros,
              child: Text(
                IdiomaService.traducir('limpiar', _idioma),
                style: TextStyle(fontSize: 12, color: Colors.blue),
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                backgroundColor: Colors.blue.withOpacity(0.1),
              ),
            ),
          ],
        ),
      );
    }
    return SizedBox.shrink();
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
                _buscando || filtroActual != null 
                  ? IdiomaService.traducir('intenta_otros_filtros', _idioma)
                  : IdiomaService.traducir('agrega_primer_evento', _idioma),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              if (filtroActual != null || _buscando) 
                ElevatedButton.icon(
                  onPressed: _limpiarFiltros,
                  icon: Icon(Icons.clear_all, size: 18),
                  label: Text(IdiomaService.traducir('limpiar_filtros', _idioma)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
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
        _construirIndicadorFiltros(),
        Expanded(child: _construirListaEventos()),
      ],
    );
  }

  Widget _construirVistaTablet() {
    return Row(
      children: [
        // Panel lateral de filtros
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
                  IdiomaService.traducir('filtros', _idioma),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              _construirOpcionesFiltro(),
            ],
          ),
        ),
        // Lista de eventos
        Expanded(
          child: Column(
            children: [
              _construirIndicadorFiltros(),
              Expanded(child: _construirListaEventos()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _construirOpcionesFiltro() {
    return Expanded(
      child: ListView(
        children: [
          _buildOpcionFiltro(
            icono: Icons.all_inclusive,
            color: Colors.grey,
            texto: IdiomaService.traducir('todos_eventos', _idioma),
            tipo: null,
          ),
          _buildOpcionFiltro(
            icono: Icons.music_note,
            color: Colors.purple,
            texto: IdiomaService.traducir('conciertos', _idioma),
            tipo: TipoEvento.CONCIERTO,
          ),
          _buildOpcionFiltro(
            icono: Icons.shopping_cart,
            color: Colors.orange,
            texto: IdiomaService.traducir('ferias', _idioma),
            tipo: TipoEvento.FERIA,
          ),
          _buildOpcionFiltro(
            icono: Icons.school,
            color: Colors.blue,
            texto: IdiomaService.traducir('conferencias', _idioma),
            tipo: TipoEvento.CONFERENCIA,
          ),
        ],
      ),
    );
  }

  Widget _buildOpcionFiltro({
    required IconData icono,
    required Color color,
    required String texto,
    required TipoEvento? tipo,
  }) {
    final bool seleccionado = filtroActual == tipo;
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: seleccionado ? color : color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icono,
            color: seleccionado ? Colors.white : color,
            size: 20,
          ),
        ),
        title: Text(
          texto,
          style: TextStyle(
            fontWeight: seleccionado ? FontWeight.bold : FontWeight.normal,
            color: seleccionado ? color : Colors.grey[700],
          ),
        ),
        trailing: seleccionado ? Icon(Icons.check, color: color, size: 20) : null,
        onTap: () => _aplicarFiltro(tipo),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        tileColor: seleccionado ? color.withOpacity(0.05) : null,
      ),
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
            PopupMenuButton<TipoEvento>(
              onSelected: _aplicarFiltro,
              icon: Icon(Icons.filter_alt),
              tooltip: IdiomaService.traducir('filtrar', _idioma),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: null,
                  child: Row(
                    children: [
                      Icon(Icons.all_inclusive, color: Colors.grey),
                      SizedBox(width: 12),
                      Text(IdiomaService.traducir('todos_eventos', _idioma)),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: TipoEvento.CONCIERTO,
                  child: Row(
                    children: [
                      Icon(Icons.music_note, color: Colors.purple),
                      SizedBox(width: 12),
                      Text(IdiomaService.traducir('conciertos', _idioma)),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: TipoEvento.FERIA,
                  child: Row(
                    children: [
                      Icon(Icons.shopping_cart, color: Colors.orange),
                      SizedBox(width: 12),
                      Text(IdiomaService.traducir('ferias', _idioma)),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: TipoEvento.CONFERENCIA,
                  child: Row(
                    children: [
                      Icon(Icons.school, color: Colors.blue),
                      SizedBox(width: 12),
                      Text(IdiomaService.traducir('conferencias', _idioma)),
                    ],
                  ),
                ),
              ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final resultado = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NuevoEvento()),
          );
          
          if (resultado != null && resultado is Evento) {
            setState(() {
              eventos.insert(0, resultado);
              AlmacenamientoService.guardarEventos(eventos);
              _aplicarFiltros();
            });
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 8),
                    Text(IdiomaService.traducir('evento_agregado', _idioma)),
                  ],
                ),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          }
        },
        child: Icon(Icons.add, size: 28),
        tooltip: IdiomaService.traducir('agregar_evento', _idioma),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }

  @override
  void dispose() {
    _controladorBusqueda.dispose();
    super.dispose();
  }
}