import 'package:flutter/material.dart';
import 'login_screen.dart';

class PerfilScreen extends StatefulWidget {
  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final _nombreController = TextEditingController(text: 'Juan Pérez');
  final _emailController = TextEditingController(text: 'juan@example.com');
  final _telefonoController = TextEditingController(text: '+1234567890');
  bool _editando = false;

  void _toggleEditar() {
    setState(() {
      _editando = !_editando;
      if (!_editando) {
        // Guardar cambios
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Perfil actualizado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  void _cerrarSesion() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cerrar Sesión'),
        content: Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
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
            child: Text('Cerrar Sesión'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String titulo, String valor, IconData icono) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icono, color: Colors.blue),
        title: Text(titulo, style: TextStyle(fontSize: 12, color: Colors.grey)),
        subtitle: _editando 
            ? TextFormField(
                controller: titulo == 'Nombre' ? _nombreController :
                          titulo == 'Email' ? _emailController : _telefonoController,
                decoration: InputDecoration(border: UnderlineInputBorder()),
              )
            : Text(valor, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Perfil'),
        actions: [
          IconButton(
            icon: Icon(_editando ? Icons.save : Icons.edit),
            onPressed: _toggleEditar,
            tooltip: _editando ? 'Guardar' : 'Editar',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar y nombre
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue,
                    child: Text(
                      _nombreController.text.substring(0, 1).toUpperCase(),
                      style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    _nombreController.text,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _emailController.text,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 30),
            
            // Información personal
            _buildInfoItem('Nombre', _nombreController.text, Icons.person),
            _buildInfoItem('Email', _emailController.text, Icons.email),
            _buildInfoItem('Teléfono', _telefonoController.text, Icons.phone),
            
            SizedBox(height: 20),
            
            // Estadísticas
            Text('Estadísticas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard('Eventos Creados', '12', Icons.event),
                _buildStatCard('Favoritos', '5', Icons.favorite),
              ],
            ),
            
            SizedBox(height: 30),
            
            // Botón cerrar sesión
            ElevatedButton.icon(
              onPressed: _cerrarSesion,
              icon: Icon(Icons.logout),
              label: Text('Cerrar Sesión'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String titulo, String valor, IconData icono) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icono, size: 30, color: Colors.blue),
            SizedBox(height: 8),
            Text(valor, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(titulo, style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }
}