// main.dart
import 'package:flutter/material.dart';
import 'pantallas/splash_screen.dart';
import 'servicios/tema_service.dart';
import 'servicios/idioma_service.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

  @override
  void initState() {
    super.initState();
    _modoOscuro = widget.modoOscuro;
    _idioma = widget.idioma;
  }

  void _cambiarConfiguracion(bool modoOscuro, String idioma) {
    setState(() {
      _modoOscuro = modoOscuro;
      _idioma = idioma;
    });
    TemaService.guardarModoOscuro(modoOscuro);
    TemaService.guardarIdioma(idioma);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: IdiomaService.traducir('app_title', _idioma), // ✅ USAR IDIOMA
      theme: TemaService.getTema(_modoOscuro),
      home: SplashScreen(onConfiguracionCambiada: _cambiarConfiguracion),
      debugShowCheckedModeBanner: false,
    );
  }
}