import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'login_screen.dart';

class PerfilScreen extends StatefulWidget {
  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> with SingleTickerProviderStateMixin {
  final _nombreController = TextEditingController(text: 'Juan Pérez');
  final _emailController = TextEditingController(text: 'juan@example.com');
  final _telefonoController = TextEditingController(text: '+1234567890');
  
  bool _editando = false;
  File? _imagenPerfil;
  final ImagePicker _picker = ImagePicker();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nombreController.dispose();
    _emailController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarImagen() async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Seleccionar foto de perfil',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildOpcionImagen(
                    icono: Icons.camera_alt,
                    texto: 'Cámara',
                    color: Colors.blue,
                    onTap: () => _tomarFoto(ImageSource.camera),
                  ),
                  _buildOpcionImagen(
                    icono: Icons.photo_library,
                    texto: 'Galería',
                    color: Colors.green,
                    onTap: () => _tomarFoto(ImageSource.gallery),
                  ),
                  if (_imagenPerfil != null)
                    _buildOpcionImagen(
                      icono: Icons.delete,
                      texto: 'Eliminar',
                      color: Colors.red,
                      onTap: _eliminarFoto,
                    ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOpcionImagen({
    required IconData icono,
    required String texto,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icono, color: color, size: 30),
          ),
          SizedBox(height: 8),
          Text(texto, style: TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Future<void> _tomarFoto(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 80,
      );
      
      if (image != null) {
        setState(() {
          _imagenPerfil = File(image.path);
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Foto de perfil actualizada'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al seleccionar imagen: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _eliminarFoto() {
    setState(() {
      _imagenPerfil = null;
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Foto de perfil eliminada'),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _toggleEditar() {
    setState(() {
      _editando = !_editando;
      if (!_editando) {
        // Guardar cambios
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.save, color: Colors.white),
                SizedBox(width: 8),
                Text('Perfil actualizado exitosamente'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    });
  }

  void _cerrarSesion() {
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

  Widget _buildInfoItem(String titulo, String valor, IconData icono, TextEditingController controller) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Card(
        elevation: _editando ? 3 : 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icono, color: Colors.blue, size: 20),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    _editando 
                        ? TextFormField(
                            controller: controller,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.blue, width: 1.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.blue, width: 2),
                              ),
                            ),
                          )
                        : Text(
                            valor,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[800],
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEstadisticas() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.bar_chart, color: Colors.blue, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Estadísticas',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.withOpacity(0.1), Colors.lightBlue.withOpacity(0.05)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withOpacity(0.2)),
                ),
                child: Column(
                  children: [
                    Icon(Icons.event, size: 40, color: Colors.blue),
                    SizedBox(height: 12),
                    Text(
                      '12',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Eventos Creados',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Mi Perfil',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onSelected: (value) {
              if (value == 'logout') {
                _cerrarSesion();
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red, size: 20),
                    SizedBox(width: 12),
                    Text(
                      'Cerrar Sesión',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar y información básica
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: _seleccionarImagen,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                blurRadius: 20,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.blue,
                            backgroundImage: _imagenPerfil != null ? FileImage(_imagenPerfil!) : null,
                            child: _imagenPerfil == null
                                ? Text(
                                    _nombreController.text.isNotEmpty 
                                        ? _nombreController.text.substring(0, 1).toUpperCase()
                                        : 'U',
                                    style: TextStyle(
                                      fontSize: 40,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _seleccionarImagen,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    _nombreController.text,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _emailController.text,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Botón editar mejorado
                  AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _animationController.forward().then((_) {
                              _animationController.reverse();
                            });
                            _toggleEditar();
                          },
                          icon: AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            child: Icon(
                              _editando ? Icons.save : Icons.edit,
                              key: ValueKey(_editando),
                              size: 20,
                            ),
                          ),
                          label: Text(
                            _editando ? 'Guardar' : 'Editar Perfil',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _editando ? Colors.green : Colors.blue,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 3,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 20),
            
            // Información personal
            _buildInfoItem('Nombre', _nombreController.text, Icons.person, _nombreController),
            _buildInfoItem('Email', _emailController.text, Icons.email, _emailController),
            _buildInfoItem('Teléfono', _telefonoController.text, Icons.phone, _telefonoController),
            
            // Estadísticas
            _buildEstadisticas(),
          ],
        ),
      ),
    );
  }
}