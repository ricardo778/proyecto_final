import 'package:flutter/material.dart';
import '../pantallas/configuracion_screen.dart';
import '../pantallas/perfil_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header del Drawer
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 25,
                  child: Icon(Icons.event, size: 30, color: Colors.blue),
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

          // Opciones del menú
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Inicio
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.home, color: Colors.blue, size: 22),
                  ),
                  title: Text(
                    IdiomaService.traducir('inicio', idiomaActual),
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),

                // Mi Perfil
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.person, color: Colors.green, size: 22),
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

                // Configuración
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

                // Divider
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Divider(),
                ),

                // Eventos Favoritos
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.favorite, color: Colors.purple, size: 22),
                  ),
                  title: Text(
                    'Eventos Favoritos',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Próximamente: Eventos Favoritos'),
                        backgroundColor: Colors.purple,
                      ),
                    );
                  },
                ),

                // Calendario
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.calendar_today, color: Colors.red, size: 22),
                  ),
                  title: Text(
                    'Calendario',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Próximamente: Vista de Calendario'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  },
                ),

                // Divider
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Divider(),
                ),

                // Acerca de
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

                // Ayuda y Soporte
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.help, color: Colors.teal, size: 22),
                  ),
                  title: Text(
                    'Ayuda y Soporte',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Centro de ayuda - Próximamente'),
                        backgroundColor: Colors.teal,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Footer del Drawer
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
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