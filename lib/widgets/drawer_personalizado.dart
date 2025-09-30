import 'package:flutter/material.dart';
import '../pantallas/configuracion_screen.dart';
import '../pantallas/perfil_screen.dart';
import '../pantallas/login_screen.dart';
import '../servicios/idioma_service.dart';
import '../servicios/tema_service.dart';

class DrawerPersonalizado extends StatelessWidget {
  final Function(bool, String)? onConfiguracionCambiada;
  final String idiomaActual;
  final bool modoOscuroActual;

  const DrawerPersonalizado({
    this.onConfiguracionCambiada,
    required this.idiomaActual,
    required this.modoOscuroActual,
  });

  void _mostrarAcercaDe(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Acerca de EventAgenda'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'EventAgenda v2.0.0',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 10),
              Text('Tu aplicación de gestión de eventos favorita.'),
              SizedBox(height: 10),
              Text('Desarrollada con Flutter 💙'),
              SizedBox(height: 10),
              Text('Características:'),
              SizedBox(height: 5),
              Text('• Gestión completa de eventos'),
              Text('• Perfiles de usuario'),
              Text('• Modo claro/oscuro'),
              Text('• Multi-idioma'),
              Text('• Interfaz responsive'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _cerrarSesion(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.logout, color: Colors.red),
            SizedBox(width: 8),
            Text('Cerrar Sesión'),
          ],
        ),
        content: Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [TemaService.colorPrimario, TemaService.colorSecundario],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 25,
                  child: Icon(Icons.event, size: 30, color: TemaService.colorPrimario),
                ),
                SizedBox(height: 15),
                Text(
                  'EventAgenda',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Bienvenido/a',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: TemaService.colorPrimario.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.home, color: TemaService.colorPrimario, size: 22),
                  ),
                  title: Text(
                    IdiomaService.traducir('inicio', idiomaActual),
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: TemaService.colorAcento.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.person, color: TemaService.colorAcento, size: 22),
                  ),
                  title: Text(
                    'Mi Perfil',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PerfilScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.settings, color: Colors.orange, size: 22),
                  ),
                  title: Text(
                    IdiomaService.traducir('configuracion', idiomaActual),
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
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
                  leading: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.info, color: Colors.grey, size: 22),
                  ),
                  title: Text(
                    IdiomaService.traducir('acerca_de', idiomaActual),
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  onTap: () => _mostrarAcercaDe(context),
                ),
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.logout, color: Colors.red, size: 22),
                  ),
                  title: Text(
                    'Cerrar Sesión',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _cerrarSesion(context);
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'EventAgenda v2.0.0',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '© 2024 Todos los derechos reservados',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}