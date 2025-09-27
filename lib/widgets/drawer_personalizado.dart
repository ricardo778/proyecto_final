// widgets/drawer_personalizado.dart
import 'package:flutter/material.dart';
import '../pantallas/configuracion_screen.dart';
import '../servicios/idioma_service.dart';

class DrawerPersonalizado extends StatelessWidget {
  final Function(bool, String)? onConfiguracionCambiada;
  final String idiomaActual;
  final bool modoOscuroActual;

  const DrawerPersonalizado({
    this.onConfiguracionCambiada,
    required this.idiomaActual,
    required this.modoOscuroActual,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.lightBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: Icon(Icons.event, size: 40, color: Colors.blue),
                ),
                SizedBox(height: 10),
                Text(
                  'EventAgenda',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Tu agenda de eventos',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Colors.blue),
            title: Text(IdiomaService.traducir('inicio', idiomaActual)), 
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.blue),
            title: Text(IdiomaService.traducir('configuracion', idiomaActual)), 
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConfiguracionScreen(
                    onConfiguracionCambiada: onConfiguracionCambiada,
                    idiomaActual: idiomaActual,
                    modoOscuroActual: modoOscuroActual,
                  ),
                ),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info, color: Colors.grey),
            title: Text(IdiomaService.traducir('acerca_de', idiomaActual)), 
            onTap: () {
              // Mostrar diálogo about
            },
          ),
        ],
      ),
    );
  }
}