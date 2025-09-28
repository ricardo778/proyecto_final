import 'package:flutter/material.dart';
import '../pantallas/configuracion_screen.dart';
import '../pantallas/perfil_screen.dart';
import '../pantallas/login_screen.dart';
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

  void _cerrarSesion(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

                // Divider
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Divider(thickness: 1.5),
                ),

                // Botón Cerrar Sesión
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
                    Navigator.pop(context); // Cerrar drawer primero
                    _cerrarSesion(context);
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