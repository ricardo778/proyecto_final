// pantallas/configuracion_screen.dart
import 'package:flutter/material.dart';
import '../servicios/tema_service.dart';
import '../servicios/idioma_service.dart';

class ConfiguracionScreen extends StatefulWidget {
  final Function(bool, String)? onConfiguracionCambiada;
  final String idiomaActual;
  final bool modoOscuroActual;
  
  const ConfiguracionScreen({
    required this.onConfiguracionCambiada,
    required this.idiomaActual,
    required this.modoOscuroActual,
  });

  @override
  _ConfiguracionScreenState createState() => _ConfiguracionScreenState();
}

class _ConfiguracionScreenState extends State<ConfiguracionScreen> {
  bool _modoOscuro = false;
  bool _notificaciones = true;
  String _idioma = 'es';
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarConfiguraciones();
  }

  void _cargarConfiguraciones() {
    setState(() {
      _modoOscuro = widget.modoOscuroActual;
      _idioma = widget.idiomaActual;
      _cargando = false;
    });
  }

  void _cambiarModoOscuro(bool valor) async {
    setState(() {
      _modoOscuro = valor;
    });
    
    await TemaService.guardarModoOscuro(valor);
    if (widget.onConfiguracionCambiada != null) {
      widget.onConfiguracionCambiada!(valor, _idioma);
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Modo ${valor ? 'oscuro' : 'claro'} activado'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _cambiarIdioma(String? valor) {
    if (valor != null) {
      setState(() {
        _idioma = valor;
      });
      
      TemaService.guardarIdioma(valor);
      if (widget.onConfiguracionCambiada != null) {
        widget.onConfiguracionCambiada!(_modoOscuro, valor);
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Idioma cambiado a ${valor == 'es' ? 'Español' : 'English'}'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  Widget _construirItemConfiguracion({
    required IconData icono,
    required String titulo,
    required String subtitulo,
    required Widget control,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: Icon(icono, color: Colors.blue),
        title: Text(titulo, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitulo),
        trailing: control,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return Scaffold(
        appBar: AppBar(title: Text('Configuración')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Configuración')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Modo Oscuro
            _construirItemConfiguracion(
              icono: Icons.brightness_6,
              titulo: 'Modo Oscuro',
              subtitulo: 'Activar el tema oscuro',
              control: Switch(
                value: _modoOscuro,
                onChanged: _cambiarModoOscuro,
                activeColor: Colors.blue,
              ),
            ),

            // Idioma
            _construirItemConfiguracion(
              icono: Icons.language,
              titulo: 'Idioma',
              subtitulo: 'Selecciona tu idioma preferido',
              control: DropdownButton<String>(
                value: _idioma,
                onChanged: _cambiarIdioma,
                items: [
                  DropdownMenuItem(value: 'es', child: Text('Español')),
                  DropdownMenuItem(value: 'en', child: Text('English')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}