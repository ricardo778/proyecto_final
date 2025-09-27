// pantallas/splash_screen.dart
import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../servicios/tema_service.dart';
import '../servicios/idioma_service.dart';

class SplashScreen extends StatefulWidget {
  final Function(bool, String)? onConfiguracionCambiada;

  const SplashScreen({this.onConfiguracionCambiada});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  _navigateToLogin() async {
    await Future.delayed(Duration(seconds: 2));
    
    final modoOscuro = await TemaService.esModoOscuro();
    final idioma = await TemaService.obtenerIdioma();
    
    if (widget.onConfiguracionCambiada != null) {
      widget.onConfiguracionCambiada!(modoOscuro, idioma);
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event, size: 100, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'EventAgenda',
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}