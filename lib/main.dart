import 'package:flutter/material.dart';
import 'pantallas/splash_screen.dart';
import 'servicios/tema_service.dart';
import 'servicios/idioma_service.dart';
import 'servicios/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Cargar configuraciones al iniciar
  final modoOscuro = await TemaService.esModoOscuro();
  final idioma = await TemaService.obtenerIdioma();
  
  runApp(MyApp(modoOscuro: modoOscuro, idioma: idioma));
}

class MyApp extends StatefulWidget {
  final bool modoOscuro;
  final String idioma;

  const MyApp({required this.modoOscuro, required this.idioma});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _modoOscuro = false;
  String _idioma = 'es';
  bool _logueado = false;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _modoOscuro = widget.modoOscuro;
    _idioma = widget.idioma;
    _verificarAutenticacion();
  }

  void _verificarAutenticacion() async {
    try {
      // Verificar si hay un token válido
      final resultado = await AuthService.verificarToken();
      
      setState(() {
        _logueado = resultado['success'] == true;
        _cargando = false;
      });
    } catch (e) {
      print('❌ Error verificando autenticación: $e');
      setState(() {
        _logueado = false;
        _cargando = false;
      });
    }
  }

  void _cambiarConfiguracion(bool modoOscuro, String idioma) {
    setState(() {
      _modoOscuro = modoOscuro;
      _idioma = idioma;
    });
    TemaService.guardarModoOscuro(modoOscuro);
    TemaService.guardarIdioma(idioma);
  }

  void _cambiarEstadoAutenticacion(bool logueado) {
    setState(() {
      _logueado = logueado;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EventAgenda',
      theme: TemaService.getTema(_modoOscuro),
      home: SplashScreen(
        onConfiguracionCambiada: _cambiarConfiguracion,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}